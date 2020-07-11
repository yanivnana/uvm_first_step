`ifndef CLKNDATA_CONFIG_SV
`define CLKNDATA_CONFIG_SV

class clkndata_config extends uvm_object;

  // Do not register config class with the factory

  virtual clkndata_if      vif;
                  
  uvm_active_passive_enum  is_active = UVM_ACTIVE;
  bit                      coverage_enable;       
  bit                      checks_enable;         

  extern function new(string name = "");

endclass : clkndata_config 


function clkndata_config::new(string name = "");
  super.new(name);
endfunction : new


`endif // CLKNDATA_CONFIG_SV

