
/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
class simpleadder_config extends uvm_object  												;
	`uvm_object_utils(simpleadder_config)

	//Interface declaration
	virtual simpleadder_if 	m_vif															;
	uvm_active_passive_enum is_active_sa 			= UVM_ACTIVE 							;
	bit 					checks_enable_sa												;
	bit 					coverage_enable_sa												;

	extern function new(string name = "")													;
	extern function string convert2string 													;
endclass: simpleadder_config



/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
function simpleadder_config::new(string name = "")											;
	super.new(.name(""))																	;
endfunction: new


/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
  function string simpleadder_config::convert2string 										;
    return $sformatf("is_active_sa=%0d, \
    				 checks_enable_sa=%b, \
    				 coverage_enable_sa=%s"			, 
    				 is_active_sa					, 
    				 checks_enable_sa				, 
    				 coverage_enable_sa)													;
  endfunction


/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
class clk_data_config extends uvm_object 	 												;
	`uvm_object_utils(clk_data_config)

	//Interface declaration
	virtual simpleadder_if 	m_vif															;
	
	uvm_active_passive_enum is_active_sa = UVM_ACTIVE 										;

	extern function new(string name="")														;

endclass: clk_data_config



/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
function clk_data_config::new(string name="")												;
	super.new( .name(get_type_name()) )														;
endfunction: new


/*******************************************************************************************/
/*																						   */
/*																						   */
/*******************************************************************************************/
/*
function string clk_data_config::convert2string 											;
return $sformatf("is_active_sa=%0d, \
				 checks_enable_sa=%b, \
				 coverage_enable_sa=%s" , 
				 is_active_sa			, 
				 checks_enable_sa		, 
				 coverage_enable_sa)														;
endfunction
*/