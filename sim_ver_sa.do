quit -sim


set curr_path [pwd]
append curr_path "/work"
.main clear

catch "vdel -lib $curr_path -verbose -all" err_msg
catch {llength $err_msg} err_len
if $err_len {
	echo $err_msg
}


do compile_sa.do
vsim -gui -classdebug -OVMdebug -uvmcontrol=all simpleadder_tb_top  +define+UVM_TESTNAME=$TEST +uvm_set_action=*,ILLEGALNAME,UVM_WARNING,UVM_NO_ACTION
do wave_dut.do
run -all
do wave_transactions.do
