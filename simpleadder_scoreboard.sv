

//`uvm_analysis_imp_decl(_before)
//`uvm_analysis_imp_decl(_after)
/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
class simpleadder_scoreboard extends uvm_scoreboard 										;
	`uvm_component_utils(simpleadder_scoreboard)

	uvm_analysis_export #(simpleadder_transaction) sb_export_before 						;
	uvm_analysis_export #(simpleadder_transaction) sb_export_after 							;

	uvm_tlm_analysis_fifo #(simpleadder_transaction) before_fifo 							;
	uvm_tlm_analysis_fifo #(simpleadder_transaction) after_fifo 							;

	simpleadder_transaction transaction_before 												;
	simpleadder_transaction transaction_after 												;

	extern 			function 	 	new(string name, uvm_component parent) 					;
	extern 			function void 	build_phase(uvm_phase phase) 							;
	extern 			function void 	connect_phase(uvm_phase phase)							;
	extern 			task 		 	run()													;
	extern virtual 	function void 	compare()												;

endclass: simpleadder_scoreboard



/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
function simpleadder_scoreboard::new(string name, uvm_component parent) 					;
	super.new(name, parent) 																;

	transaction_before	= new("transaction_before") 										;
	transaction_after	= new("transaction_after" )											;
endfunction: new


/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
function void simpleadder_scoreboard::build_phase(uvm_phase phase) 							;
	super.build_phase(phase)																;

	sb_export_before	= new("sb_export_before", this)										;
	sb_export_after		= new("sb_export_after" , this)										;

	before_fifo			= new("before_fifo", this)											;
	after_fifo			= new("after_fifo" , this)											;
endfunction: build_phase


/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
function void simpleadder_scoreboard::connect_phase(uvm_phase phase)						;
	sb_export_before.connect(before_fifo.analysis_export)									;
	sb_export_after.connect(after_fifo.analysis_export)										;
endfunction: connect_phase


/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
task simpleadder_scoreboard::run()															;
	forever begin
		before_fifo.get(transaction_before)													;
		after_fifo.get(transaction_after)													;
		
		compare()																			;
	end
endtask: run


/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
function void simpleadder_scoreboard::compare()												;
	if(transaction_before.out == transaction_after.out) begin
		`uvm_info("compare", $sformatf("Test: before=%0d, after=%0d, result OK!"	,
										transaction_before.out						,
										transaction_after.out), UVM_LOW)					;
	end else begin
		`uvm_info("compare", $sformatf("Test: before=%0d, after=%0d, result Fail!"	,
										transaction_before.out						,
										transaction_after.out), UVM_LOW)					;
	end
endfunction: compare
