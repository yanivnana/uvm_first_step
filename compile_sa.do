
# ------ systemverilog verification testsbench for simpleadder_tb_top.v -------------------------------------------

set 	UVM_VERBOSITY 	UVM_LOW
set 	TEST 			simpleadder_test

#vlog -dpiheader predict.hpp predict_class.cpp 
vlog -L mtiUvm -work work -sv simpleadder_tb_top.sv -dpiheader predict.hpp predict_class.cpp  +define+UVM_VERBOSITY=$UVM_VERBOSITY +define+UVM_TESTNAME=$TEST

# +define+UVM_PHASE_TRACE


