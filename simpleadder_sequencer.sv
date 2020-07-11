

class simpleadder_sequence extends uvm_sequence#(simpleadder_transaction);
	`uvm_object_utils(simpleadder_sequence)

	extern function 		new(string name = "");
	extern task 			body();

endclass: simpleadder_sequence


typedef uvm_sequencer#(simpleadder_transaction) simpleadder_sequencer;



function simpleadder_sequence::new(string name = "");
	super.new(name);
endfunction: new


task simpleadder_sequence::body();
	simpleadder_transaction sa_tx;

	if (starting_phase != null)
    	starting_phase.raise_objection(this);


	repeat(15) begin
		sa_tx = simpleadder_transaction::type_id::create(.name("sa_tx")	,
														 .contxt(get_full_name()) );

		start_item(sa_tx); 				/* handshake with driver::get function */			

		if( !sa_tx.randomize() ) 															
			`uvm_error("", "failed to randomize...");


		//`uvm_info("sa_sequence", sa_tx.sprint(), UVM_LOW);
		finish_item(sa_tx);				/* handshake with driver::get function */			

	end
	if (starting_phase != null)
		starting_phase.drop_objection(this);
endtask: body


