

class simpleadder_env extends uvm_env;
	`uvm_component_utils(simpleadder_env)

	simpleadder_config 	 	env_config;
	simpleadder_agent 		sa_agent;
	simpleadder_scoreboard 	sa_sb;

	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass: simpleadder_env


function simpleadder_env::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction: new


function void simpleadder_env::build_phase(uvm_phase phase);
	simpleadder_config		m_config;

	super.build_phase(phase);
	`uvm_info( get_type_name(), "In build phase", UVM_HIGH);


	sa_agent	= simpleadder_agent::type_id::create(	.name("sa_agent") , 
														.parent(this) );
	sa_sb		= simpleadder_scoreboard::type_id::create(	.name("sa_sb"), 
															.parent(this) );

	/* load env_config from uvm_config_db */
	if( !uvm_config_db#(simpleadder_config)::get(this, "", "config", env_config) )
		`uvm_error(get_type_name(), "Unable to get simpleadder_config..");

	m_config				= new("m_config");
	m_config.copy(env_config);

	uvm_config_db#(simpleadder_config)::set(this			, 
											"*.*sa_agent"	, 
											"config"		, 
											m_config);



endfunction: build_phase


function void simpleadder_env::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	sa_agent.agent_ap_before.connect(sa_sb.sb_export_before);
	sa_agent.agent_ap_after.connect(sa_sb.sb_export_after);
endfunction: connect_phase
