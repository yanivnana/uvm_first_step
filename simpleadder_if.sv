

`ifndef __SIMPLEADDER_IF_SV__
`define __SIMPLEADDER_IF_SV__


interface simpleadder_if;
	logic		sig_clock;
	logic		sig_ina;
	logic		sig_inb;
	logic		sig_en_i;

	logic		sig_out;
	logic		sig_en_o;
endinterface: simpleadder_if


`endif /* __SIMPLEADDER_IF_SV__ */

