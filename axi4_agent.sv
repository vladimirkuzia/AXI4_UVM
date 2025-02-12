//===============================================================
// Name             : vkuznetsov
// File Created     : 2024-12-07
//===============================================================
// NOTE: Please Don't Remove Any Comments or //--- Given Below
//===============================================================

`ifndef AXI4_AGENT_SV
`define AXI4_AGENT_SV

typedef uvm_sequencer #(axi4_sequence_item) td_axi4_sequencer;

class axi4_agent extends uvm_agent;

  typedef axi4_agent_cfg           tb_axi4_cfg;
  typedef axi4_monitor_base        td_axi4_monitor;
  typedef axi4_driver_base         td_axi4_driver;
  typedef axi4_sequence_item       td_axi4_sequence_item;

  // agent variables
  virtual axi4_if #(DATA_WIDTH)                            vif; 

  tb_axi4_cfg                                              cfg;
  td_axi4_monitor                                          mon;
  td_axi4_driver                                           drv;
  td_axi4_sequencer                                        seqr;

`uvm_component_utils_begin(axi4_agent)
    `uvm_field_object(mon,  UVM_ALL_ON)
    `uvm_field_object(drv,  UVM_ALL_ON)
`uvm_component_utils_end

  
  uvm_analysis_port #(td_axi4_sequence_item) analysis_port;
 
  extern         function      new(string name = "AXI_agent", uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  
endclass: axi4_agent

//------------------------------------------------------------------------//
// function: new
// constructor
function axi4_agent :: new(string name = "AXI_agent", uvm_component parent);
  super.new(name, parent);
  
endfunction: new

//------------------------------------------------------------------------//
// task: build_phase
// build phase is called by UVM flow.
function void axi4_agent :: build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db #(tb_axi4_cfg) :: get (this, "", "cfg", cfg)) begin
    `uvm_error(get_type_name(), "cfg object is not found in config_db!");
  end

  if (vif == null) `uvm_fatal(get_type_name(), $sformatf("%s interface not set!", this.get_full_name() ) )

  mon      = td_axi4_monitor :: type_id :: create("mon", this);
  mon.vif  = vif; // pass interface into the monitor

  drv      = td_axi4_driver :: type_id :: create("drv", this);
  drv.cfg  = cfg;
  
  drv.vif  = vif; // pass interface into the driver

  seqr     = td_axi4_sequencer :: type_id :: create ("seqr", this);

endfunction: build_phase

//------------------------------------------------------------------//
// task: connect_phase
// connect phase is called by UVM flow. Connects monitor to agents analysis 
// port so monitored transactions can be connected to a scoreboard. 
function void axi4_agent :: connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  this.analysis_port = mon.analysis_port; // bring the monitor analysis port up to the user
  drv.seq_item_port.connect(seqr.seq_item_export); // connect sequencer to driver
endfunction: connect_phase

`endif //axi4_AGENT_SV