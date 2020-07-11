
`ifndef __SIMPLEADDER_TRANSACTION_SVH__
`define __SIMPLEADDER_TRANSACTION_SVH__


/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
class simpleadder_transaction extends uvm_sequence_item 									;
    `uvm_object_utils(simpleadder_transaction)

	rand bit[1:0] ina 																		;
	rand bit[1:0] inb 																		;
	     bit[2:0] out 																		;

	extern 			function 		new(string name = "") 									;
	extern 			function string convert2string											;
	extern 			function void 	do_copy(uvm_object rhs)									;
	extern			function bit 	do_compare(uvm_object rhs, uvm_comparer comparer)		;
	extern	virtual function void 	do_print(uvm_printer printer)							;
	extern	virtual function void 	do_record(uvm_recorder recorder)						;
	extern	virtual function void 	do_pack(uvm_packer packer)								;
	extern	virtual function void 	do_unpack(uvm_packer packer)							;

/*	`uvm_object_utils_begin(simpleadder_transaction)
		`uvm_field_int(ina, UVM_ALL_ON)
		`uvm_field_int(inb, UVM_ALL_ON)
		`uvm_field_int(out, UVM_ALL_ON)
	`uvm_object_utils_end													*/
endclass: simpleadder_transaction


/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
function simpleadder_transaction::new(string name = "") 									;
	super.new(name) 																		;
endfunction: new


/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
function void simpleadder_transaction::do_copy(uvm_object rhs)								;
  	simpleadder_transaction 	_rhs														;

  	if( !$cast(_rhs, rhs) )
  		`uvm_error("do_copy", "$cast failed, check type compatability..")					;
  	super.do_copy(rhs)																		;

  	ina  		= _rhs.ina 																	;
  	inb 		= _rhs.inb 																	;
  	out 		= _rhs.out 																	;
endfunction: do_copy
    
/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
function bit simpleadder_transaction::do_compare(uvm_object rhs, uvm_comparer comparer)		;
  simpleadder_transaction 		_rhs														;
  bit status 	= 1																			;

  if(!$cast(_rhs, rhs))
	 `uvm_fatal("do_compare", "cast failed, check type compatability...")					;

  status 	&= (ina  == _rhs.ina)															;
  status 	&= (inb  == _rhs.inb)															;
  status 	&= (out  == _rhs.out)															;
  return status 																			;
endfunction: do_compare


/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
function string simpleadder_transaction::convert2string										;
	return $sformatf("ina=%d, inb=%d, out=%d", ina, inb, out)								;
endfunction


/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
function void simpleadder_transaction::do_print(uvm_printer printer)						;
	super.do_print(printer)																	;
	
	//printer.print_generic("op", "bus_op_t", $size(bus_op_t), op.name())					;
	printer.print_int( "int", ina, $size(ina) )												;
	printer.print_int( "int", inb, $size(inb) )												;
	printer.print_int( "int", out, $size(out) )												;
endfunction: do_print

/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
function void simpleadder_transaction::do_record(uvm_recorder recorder)						;
	if (!is_recording_enabled())
 		return 																				;

	super.do_record(recorder)																;
	//`uvm_record_field( "ina", ina )														;
	//`uvm_record_field( "inb", inb )														;
	//`uvm_record_field( "out", out )														;
	`uvm_record_int( "int", ina, $bits(ina) )												;
	`uvm_record_int( "int", inb, $bits(inb) )												;
	`uvm_record_int( "int", out, $bits(out) )												;

endfunction: do_record


/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
function void simpleadder_transaction::do_pack (uvm_packer packer)							;
	super.do_pack(packer)																	;
	`uvm_pack_int(ina)																		;
	`uvm_pack_int(inb)																		;
	`uvm_pack_int(out)																		;
endfunction: do_pack


/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
function void simpleadder_transaction::do_unpack (uvm_packer packer)						;
	super.do_unpack(packer)																	;
	`uvm_unpack_int(ina)																	;
	`uvm_unpack_int(inb)																	;
	`uvm_unpack_int(out)																	;
endfunction: do_unpack

`endif /* __SIMPLEADDER_TRANSACTION_SVH__ */
