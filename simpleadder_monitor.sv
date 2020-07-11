


import "DPI-C" function chandle cl_predict_new(string name);
import "DPI-C" function int 	cl_predict_set_values_handle(int x, int y, chandle handle);



class simpleadder_monitor_before extends uvm_monitor;
	`uvm_component_utils(simpleadder_monitor_before)

	virtual simpleadder_if 	m_vif;
	clk_data_config 		mon_config;

	simpleadder_transaction sa_tx;

	uvm_analysis_port#(simpleadder_transaction) mon_ap_before;		/* port definition */	


	extern function 		new(string name, uvm_component parent);
	extern function void 	build_phase(uvm_phase phase);
	extern function void 	connect_phase(uvm_phase phase);
	extern task 			run_phase(uvm_phase phase);
	extern task 			do_mon();

endclass: simpleadder_monitor_before


function simpleadder_monitor_before::new(string name, uvm_component parent);
	super.new(name, parent);
	mon_ap_before 	= new( .name("mon_ap_before"), .parent(this) );	/* port instansiation */
endfunction: new


function void simpleadder_monitor_before::build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info( get_type_name(), "In build phase", UVM_HIGH);


	/* load agent_config from uvm_config_db */
	if( !uvm_config_db#(clk_data_config)::get(this, "", "config", mon_config) )
		`uvm_error(get_type_name(), "Unable to get clk_data_config..");

endfunction: build_phase


function void simpleadder_monitor_before::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
endfunction: connect_phase


task simpleadder_monitor_before::run_phase(uvm_phase phase);
	`uvm_info(get_type_name(), "run_phase", UVM_HIGH);

	sa_tx 	= simpleadder_transaction::type_id::create(	.name("sa_tx")			, 
														.contxt(get_full_name()) );
	do_mon();
endtask : run_phase

task simpleadder_monitor_before::do_mon();
	integer counter_mon = 0, state = 0;

	forever begin
		@(posedge m_vif.sig_clock)
		begin
			if(m_vif.sig_en_o)
			begin
				state 			= 1;

				/* recording time stamp */
				accept_tr(sa_tx, $time);

				/* start recording */
				void'( begin_tr(sa_tx, {get_type_name(),"_stream"}) );
			end

			if(state == 1)
			begin
				sa_tx.out[2] 	= m_vif.sig_out;
				state 		 	= 2;
			end else
			if(state == 2) begin
				sa_tx.out[1] 	= m_vif.sig_out;
				state 		 	= 3;
			end else
			if(state == 3) begin
				sa_tx.out[0] 	= m_vif.sig_out;				

				/* Send the transaction to the analysis port */
				mon_ap_before.write(sa_tx);
				state 			= 0;
				/* end recording */
				end_tr(sa_tx);
			end

/*			`uvm_info("not final: ", $sformatf("\ncounter_mon=%0d, \nm_vif.sig_en_o=%0d, \nm_vif.sig_out=%0d",
								counter_mon				,
								m_vif.sig_en_o			,
								m_vif.sig_out), UVM_LOW);
*/
			counter_mon 	= counter_mon + 1;
		end // @(posedge m_vif.sig_clock)
	end // forever
endtask : do_mon


class simpleadder_monitor_after extends uvm_monitor;
	`uvm_component_utils(simpleadder_monitor_after)

	uvm_analysis_port#(simpleadder_transaction) mon_ap_after;	/* port definition */		

	virtual simpleadder_if 	m_vif;
	clk_data_config 		mon_config;

	simpleadder_transaction sa_tx;
	
	//For coverage
	simpleadder_transaction sa_tx_cg;

	//handle for C++ predict implementation
	chandle hPredict;

	//Define coverpoints
	covergroup simpleadder_cg;
      		ina_cp:     coverpoint sa_tx_cg.ina;
      		inb_cp:     coverpoint sa_tx_cg.inb;
		cross ina_cp, inb_cp;
	endgroup: simpleadder_cg

	extern function 		new(string name, uvm_component parent);
	extern function void 	build_phase(uvm_phase phase);
	extern function void 	connect_phase(uvm_phase phase);
	extern task 		 	run_phase(uvm_phase phase);
	extern task 		 	do_mon();
	//extern function void 	predictor();
endclass: simpleadder_monitor_after


function simpleadder_monitor_after::new(string name, uvm_component parent);
	super.new(name, parent);
	
	simpleadder_cg 	= new;
	hPredict		= cl_predict_new("my_cpp_predictor");
	
endfunction: new


function void simpleadder_monitor_after::build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info(get_type_name(), "build_phase", UVM_HIGH);

	mon_ap_after	= new(	.name("mon_ap_after"), .parent(this)  );/* port instansiation */

	/* load agent_config from uvm_config_db */
	if( !uvm_config_db#(clk_data_config)::get(this, "", "config", mon_config) )
		`uvm_error(get_type_name(), "Unable to get clk_data_config..");

endfunction: build_phase



function void simpleadder_monitor_after::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	sa_tx 	= simpleadder_transaction::type_id::create(	.name("sa_tx")		, 
														.contxt(get_full_name()) );
	//m_vif already instanciated from the agent level... 

endfunction: connect_phase


task simpleadder_monitor_after::run_phase(uvm_phase phase);
	`uvm_info(get_type_name(), "run_phase", UVM_HIGH);

	do_mon();

endtask: run_phase



task simpleadder_monitor_after::do_mon();
	integer counter_mon = 0, state = 0;

	forever begin

		 @(posedge m_vif.sig_clock) begin : proc_simpleadder_monitor_after


			if(m_vif.sig_en_i) begin
				//counter_mon=0;
				state 			= 1;
				sa_tx.ina 		= 2'b00;
				sa_tx.inb 		= 2'b00;
				sa_tx.out 		= 3'b000;

				/* recording time stamp */
				accept_tr(sa_tx, $time);

				/* start recording */
				void'( begin_tr(sa_tx, {get_type_name(),"_stream"}) );
			end

			if(state==1) begin
				sa_tx.ina 		= sa_tx.ina << 1;
				sa_tx.inb 		= sa_tx.inb << 1;

				sa_tx.ina[0] 	= m_vif.sig_ina;
				sa_tx.inb[0] 	= m_vif.sig_inb;

				state 			= 2;
			end else
			if(state==2) begin
				sa_tx.ina 		= sa_tx.ina << 1;
				sa_tx.inb 		= sa_tx.inb << 1;

				sa_tx.ina[0] 	= m_vif.sig_ina;
				sa_tx.inb[0] 	= m_vif.sig_inb;

				state 			= 0;

				//Predict the result
				//predictor() 																;
				sa_tx.out 		= cl_predict_set_values_handle(sa_tx.ina, sa_tx.inb, hPredict);

				//sa_tx_cg.do_copy(sa_tx); 		/* do_copy fail!!! */						
				sa_tx_cg		= sa_tx;

				//Coverage
				simpleadder_cg.sample();

				//Send the transaction to the analysis port
				mon_ap_after.write(sa_tx);
				
				/* end recording */
				end_tr(sa_tx);

			end // if(!m_vif.sig_en_i && state==1)

/*			`uvm_info("AFTER_MON: ", $sformatf("\ncounter_mon=%0d, \nm_vif.sig_en_i=%0d, \nm_vif.sig_ina=%0d, \nm_vif.sig_inb=%0d",
								counter_mon						,
								m_vif.sig_en_i					,
								m_vif.sig_ina					, 
								m_vif.sig_inb), UVM_LOW);
*/			
			counter_mon 	= counter_mon + 1;

		end // @(posedge m_vif.sig_clock)
	end // forever
endtask: do_mon

