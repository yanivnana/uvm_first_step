

class simpleadder_driver extends uvm_driver#(simpleadder_transaction)						;
	`uvm_component_utils(simpleadder_driver)

	simpleadder_transaction sa_tx 															;
	virtual simpleadder_if 	m_vif															;
	clk_data_config 		drv_config														;

	extern function 	 	new(string name, uvm_component parent)							;
	extern function void 	build_phase(uvm_phase phase)									;
	extern task 		 	run_phase(uvm_phase phase)										;
	extern virtual task 	do_drive()														;
endclass: simpleadder_driver



/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
function simpleadder_driver::new(string name, uvm_component parent)							;
	super.new(name, parent)																	;
endfunction: new


/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
function void simpleadder_driver::build_phase(uvm_phase phase)								;
	super.build_phase(phase)																;
	`uvm_info(get_type_name(), "build_phase", UVM_HIGH)										;

	if( !uvm_config_db#(clk_data_config)::get(this, "", "config", drv_config) )
		`uvm_error(get_type_name(), "Unable to get clk_data_config..")						;

	m_vif 				= drv_config.m_vif													;

endfunction: build_phase


/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
task simpleadder_driver::run_phase(uvm_phase phase)											;
	`uvm_info(get_type_name(), "run_phase", UVM_HIGH)										;

	forever begin

		seq_item_port.get_next_item(sa_tx)													;
		`uvm_info(get_type_name(), {"req item\n", sa_tx.sprint}, UVM_HIGH)					;
		do_drive()																			;
		seq_item_port.item_done()															;
	end // forever
endtask: run_phase



/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
task simpleadder_driver::do_drive()															;
	integer counter = 0																		;
	m_vif.sig_en_i <= 1'b0																	;
	m_vif.sig_ina  <= 0 																	;
	m_vif.sig_inb  <= 0																		;

	forever begin

		@(posedge m_vif.sig_clock)
		begin
			case(counter)
				0 : 
				begin
					m_vif.sig_en_i <= 1'b1													;
					m_vif.sig_ina  <= sa_tx.ina[1]											;
					m_vif.sig_inb  <= sa_tx.inb[1]											;
					/* recording time stamp */
					accept_tr(sa_tx, $time)													;

					/* start recording */
					void'( begin_tr(sa_tx, {get_type_name(),"_stream"}) )					;
				end

				1 : 
				begin
					m_vif.sig_en_i <= 1'b0													;
					m_vif.sig_ina  <= sa_tx.ina[0]											;
					m_vif.sig_inb  <= sa_tx.inb[0]											;
					/* end recording */
					end_tr(sa_tx)															;
				end

				default :
				begin
					m_vif.sig_en_i <= 1'b0													;
					m_vif.sig_ina  <= 0 													;
					m_vif.sig_inb  <= 0														;
				end
			endcase // counter

/*		`uvm_info("DRVR_IF: ", $sformatf("\ncounter=%0d, \nm_vif.sig_en_i=%0d, \nm_vif.sig_ina=%0d, \nm_vif.sig_inb=%0d",
						counter						,
						m_vif.sig_en_i				,
						m_vif.sig_ina				, 
						m_vif.sig_inb), UVM_LOW)											;
*/
		counter 		= counter + 1 														;

		if(counter==6) begin
			counter = 0																		;
			break																			;
		end
		end // @(posedge m_vif.sig_clock)
	end // forever
endtask: do_drive
