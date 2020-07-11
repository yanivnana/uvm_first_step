


class simpleadder_agent extends uvm_agent;
	`uvm_component_utils(simpleadder_agent)

	uvm_analysis_port#(simpleadder_transaction) agent_ap_before;
	uvm_analysis_port#(simpleadder_transaction) agent_ap_after;

	uvm_active_passive_enum 	m_is_active = UVM_ACTIVE;
	simpleadder_config 			agent_config;
	simpleadder_sequencer		sa_seqr;
	simpleadder_driver			sa_drvr;
	simpleadder_monitor_before	sa_mon_before;
	simpleadder_monitor_after	sa_mon_after;

	extern function 						new(string name, uvm_component parent);
	extern function void 					build_phase(uvm_phase phase);
	extern function void 					connect_phase(uvm_phase phase);
	extern function uvm_active_passive_enum get_is_active();
endclass: simpleadder_agent


function simpleadder_agent::new(string name, uvm_component parent);
	super.new(name, parent);
	agent_ap_before	= new( 	.name("agent_ap_before"), 
							.parent(this) );
	agent_ap_after	= new( 	.name("agent_ap_after"), 
							.parent(this) );

endfunction: new


function void simpleadder_agent::build_phase(uvm_phase phase);
	clk_data_config				m_config;

	super.build_phase(phase);
	`uvm_info( get_type_name(), "In build phase", UVM_HIGH);

	sa_mon_before	= simpleadder_monitor_before::type_id::create(	.name("sa_mon_before"), 
																	.parent(this) );
	sa_mon_after	= simpleadder_monitor_after::type_id::create(	.name("sa_mon_after") , 
																	.parent(this) );
	if( get_is_active() == UVM_ACTIVE )
	begin
		`uvm_info( "ERROR", "In build phase.. UVM_ACTIVE", UVM_LOW);
		sa_seqr			= simpleadder_sequencer::type_id::create(	.name("sa_seqr")	  ,
																	.parent(this) );
		sa_drvr			= simpleadder_driver::type_id::create(		.name("sa_drvr")	  , 
																	.parent(this) );
	end

	/* load agent_config from uvm_config_db */
	if( !uvm_config_db#(simpleadder_config)::get(this, "", "config", agent_config) )
		`uvm_error(get_type_name(), "Unable to get simpleadder_config..");

	m_config				= new("m_config");
	m_config.m_vif			= agent_config.m_vif;
	m_config.is_active_sa 	= agent_config.is_active_sa;

	uvm_config_db#(clk_data_config)::set(	this			, 
											"sa_mon_before"	, 
											"config"		, 
											m_config);

	uvm_config_db#(clk_data_config)::set(	this			, 
											"sa_mon_after"	, 
											"config"		, 
											m_config);

	if( get_is_active() == UVM_ACTIVE ) begin
		uvm_config_db#(clk_data_config)::set(	this			, 
												"sa_seqr"		, 
												"config"		, 
												m_config);

		uvm_config_db#(clk_data_config)::set(	this			, 
												"sa_drvr"		, 
												"config"		, 
												m_config);
	end

endfunction: build_phase


function void simpleadder_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	if(agent_config.m_vif == null)
		`uvm_fatal(get_type_name(), "agent_config.m_vif virtual interface is not set..");

	sa_mon_before.m_vif 				= agent_config.m_vif;
	sa_mon_after.m_vif 					= agent_config.m_vif;
	sa_mon_before.mon_ap_before.connect(agent_ap_before);
	sa_mon_after.mon_ap_after.connect(agent_ap_after);
	
	if( get_is_active() == UVM_ACTIVE ) begin
		sa_drvr.m_vif 						= agent_config.m_vif;
		sa_drvr.seq_item_port.connect(sa_seqr.seq_item_export);
	end
endfunction: connect_phase



function uvm_active_passive_enum simpleadder_agent::get_is_active();

	if(m_is_active == -1)
		m_is_active 	= agent_config.is_active_sa;

	return uvm_active_passive_enum'(m_is_active);
endfunction:get_is_active
