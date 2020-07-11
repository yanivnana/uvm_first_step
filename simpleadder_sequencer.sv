

/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
class simpleadder_sequence extends uvm_sequence#(simpleadder_transaction) 					;
	`uvm_object_utils(simpleadder_sequence)

	extern function 		new(string name = "") 											;
	extern task 			body() 															;

endclass: simpleadder_sequence


typedef uvm_sequencer#(simpleadder_transaction) simpleadder_sequencer 						;



/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
function simpleadder_sequence::new(string name = "") 										;
	super.new(name) 																		;
endfunction: new


/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
/*function void simpleadder_sequence::build_phase(uvm_phase phase) 							;
	super.build_phase(phase)																;
	`uvm_info(get_type_name(), "build_phase", UVM_HIGH)										;

	if( !uvm_config_db#(clk_data_config)::get(this, "", "config", sqncr_config) )
		`uvm_error(get_type_name(), "Unable to get clk_data_config..")						;

endfunction: build_phase
*/
/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
task simpleadder_sequence::body() 															;
	simpleadder_transaction sa_tx 															;

	if (starting_phase != null)
    	starting_phase.raise_objection(this)												;


	repeat(15) begin
		sa_tx = simpleadder_transaction::type_id::create(.name("sa_tx")	,
														 .contxt(get_full_name()) )			;

		start_item(sa_tx) 				/* handshake with driver::get function */			;

		/* recording time stamp */
//		accept_tr(sa_tx, $time)																;

		/* start recording */
//		void'( begin_tr(sa_tx, {get_type_name(),"_stream"}) )								;

		if( !sa_tx.randomize() ) 															
			`uvm_error("", "failed to randomize...")										;

		/* end recording */
//		end_tr(sa_tx)																		;

		//`uvm_info("sa_sequence", sa_tx.sprint(), UVM_LOW)									;
		finish_item(sa_tx) 				/* handshake with driver::get function */			;

		// eng_tr - terminate recording 
	end
	if (starting_phase != null)
		starting_phase.drop_objection(this)													;
endtask: body


