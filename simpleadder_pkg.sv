

`ifndef __SIMPLEADDER_PKG_SV__
`define __SIMPLEADDER_PKG_SV__

`include "uvm_macros.svh"


package simpleadder_pkg;
	import uvm_pkg::*;
	`include "simpleadder_config.sv"
	`include "simpleadder_transaction.svh"
	`include "simpleadder_sequencer.sv"
	`include "simpleadder_monitor.sv"
	`include "simpleadder_driver.sv"
	`include "simpleadder_agent.sv"
	`include "simpleadder_scoreboard.sv"
	`include "simpleadder_env.sv"
	`include "simpleadder_test.sv"
endpackage: simpleadder_pkg


`endif /* __SIMPLEADDER_PKG_SV__ */
