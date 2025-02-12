//===============================================================
// Name             : vkuznetsov
// File Created     : 2024-12-07
//===============================================================
// NOTE: Please Don't Remove Any Comments or //--- Given Below
//===============================================================

`ifndef AXI4_MONITOR_BASE_SV
`define AXI4_MONITOR_BASE_SV

class axi4_monitor_base extends uvm_monitor;
  `uvm_component_utils(axi4_monitor_base)
  
  typedef axi4_sequence_item         td_axi4_sequence_item;
  td_axi4_sequence_item              req;
  
  virtual axi4_if    #(DATA_WIDTH)                          vif;
  uvm_analysis_port  #(td_axi4_sequence_item)               analysis_port;

  
  extern         function      new(string name, uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task          run_phase(uvm_phase phase);
  extern virtual task          monitor_master();
endclass: axi4_monitor_base
  
//------------------------------------------------------------------------//
// function: new
// constructor
function axi4_monitor_base :: new(string name, uvm_component parent);
  super.new(name, parent);
endfunction: new

//------------------------------------------------------------------------//
// function: build_phase
// build phase is called by UVM flow.
function void axi4_monitor_base :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  analysis_port = new("analysis_port", this);
endfunction: build_phase

//------------------------------------------------------------------------//
// task: run_phase
// run phase is called by UVM flow. Monitor is active during this phase. 
task axi4_monitor_base :: monitor_master();
  fork
    forever begin
      do begin 
        @(posedge vif.clk_i);
      end
      while (!(vif.awvalid && vif.awready));
      req.channel    = AW;
      req.awaddr     = vif.awaddr;  
    end

    forever begin
      do begin
        @(posedge vif.clk_i);
      end
      while (!(vif.wvalid && vif.wready));
      req.channel   = W;
      req.wdata     = vif.wdata; 
    end

    forever begin
      do begin
        @(posedge vif.clk_i);
      end
      while (!(vif.arvalid && vif.arready));
      req.channel    = AR;
      req.araddr     = vif.araddr;
      req.arid       = vif.arid;
    end

    forever begin
      do begin 
        @(posedge vif.clk_i);
      end
      while (!(vif.bvalid && vif.bready));
      req.channel   = B;
      req.bresp     = vif.bresp;
    end

    forever begin
      do begin
        @(posedge vif.clk_i);
      end
      while (!(vif.rvalid && vif.rready));
      req.channel   = R;
      req.rresp     = vif.rresp;
      req.rid       = vif.rid;
      req.rdata     = vif.rdata;
    end
  join
endtask: monitor_master

task axi4_monitor_base :: run_phase(uvm_phase phase);
  super.run_phase (phase);
  forever begin
    wait(vif.aresetn);
    fork 
      forever begin 
        req = new;
        monitor_master();
        analysis_port.write (req);
      end
    join_none
    wait(!vif.aresetn);
    disable fork;
  end
endtask : run_phase
`endif //AXI4_MONITOR_BASE_SV