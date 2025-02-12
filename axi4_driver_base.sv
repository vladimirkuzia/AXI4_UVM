//===============================================================
// Name             : vkuznetsov
// File Created     : 2024-12-07
//===============================================================
// NOTE: Please Don't Remove Any Comments or //--- Given Below
//===============================================================

`ifndef AXI4_DRIVER_BASE_SV
`define AXI4_DRIVER_BASE_SV

class axi4_driver_base extends uvm_driver #(axi4_sequence_item);
  `uvm_component_utils(axi4_driver_base)

  int depth_get_port = 4;

  virtual axi4_if #(DATA_WIDTH)      vif;
  
  typedef axi4_sequence_item         td_axi4_sequence_item;
  td_axi4_sequence_item              q_aw, q_w, q_ar, p_aw, p_w, p_ar;

  axi4_agent_cfg                     cfg;
  
  logic [6:0]                        transaction_cnt;
  bit                                flag;

  extern         function      new(string name, uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task          run_phase(uvm_phase phase);
  extern virtual task          drive_master(axi4_sequence_item req);
  extern virtual task          do_delay();
  extern virtual task          reset_master();
  extern virtual task          do_aw(axi4_sequence_item req);
  extern virtual task          do_w(axi4_sequence_item req);
  extern virtual task          do_ar(axi4_sequence_item req);
  extern virtual task          do_b();
  extern virtual task          do_r();
endclass: axi4_driver_base
  
//------------------------------------------------------------------------//
function axi4_driver_base :: new(string name, uvm_component parent);
  super.new(name, parent);
endfunction: new

//------------------------------------------------------------------------//
function void axi4_driver_base :: build_phase(uvm_phase phase);
  super.build_phase(phase);    
endfunction: build_phase

task axi4_driver_base :: drive_master(axi4_sequence_item req);
  fork
    case(req.channel)
      AW : begin 
        q_aw = req;
        do_aw(q_aw);
      end
      W  : begin
        q_w = req;
        do_w(q_w);
      end
      AR : begin
        q_ar = req;
        do_ar(q_ar);
      end
      R : begin
        do_r();
      end
      B : begin
        do_b();
      end
      default ;
    endcase
  join  
endtask: drive_master

//------------------------------------------------------------------------//
// task: run_phase
// run phase is called by UVM flow. Driver is active during this phase.
task axi4_driver_base :: run_phase(uvm_phase phase);
  super.run_phase(phase);
    reset_master();;
    wait(vif.aresetn);
    q_aw = new();
    q_w = new();
    q_ar = new();
    forever begin
      fork
        forever begin
          seq_item_port.get(req);
          // req.print();
          drive_master(req);
          req.rsp_b = 1;
          seq_item_port.put(req);
            `uvm_info(get_type_name(), "After put call", UVM_LOW);
        end 
      join_none
      wait(!vif.aresetn);
      disable fork;
      reset_master();
      wait(vif.aresetn);
    end
endtask: run_phase

task axi4_driver_base :: do_delay();
  int delay;
  void'(std::randomize(delay) with {delay inside {[cfg.m_delay_min:cfg.m_delay_max]};});
  repeat(delay) @(posedge vif.clk_i);
endtask: do_delay

task axi4_driver_base :: reset_master();
  vif.awvalid <= 0;
  vif.wvalid  <= 0;
  vif.bready  <= 0;
  vif.arvalid <= 0;
  vif.rready  <= 0;
endtask: reset_master

task axi4_driver_base :: do_aw( axi4_sequence_item req);
  do_delay();
  vif.channel_cur  = "AW";
  vif.op      <= req.op;
  vif.start   <= 0;
  vif.awvalid <= 1;
  vif.awaddr  <= req.awaddr;
  do begin 
    @(posedge vif.clk_i);
  end
  while( !vif.awready );
  vif.awvalid <= 0;
endtask: do_aw

task axi4_driver_base :: do_w( axi4_sequence_item req);
  do_delay();
  vif.channel_cur  = "W";
  vif.op     <= req.op;
  vif.start  <= 0;
  vif.wvalid <= 1;
  vif.wdata  <= req.wdata;
  do begin 
    @(posedge vif.clk_i);
  end
  while( !vif.wready );
  vif.wvalid <= 0;
endtask: do_w

task axi4_driver_base :: do_ar( axi4_sequence_item req);
  do_delay();
  vif.channel_cur  = "AR";
  vif.op      <= req.op;
  vif.start   <= 0;
  vif.arvalid <= 1;
  vif.araddr  <= req.araddr;
  vif.arid    <= req.arid;
  do begin 
    @(posedge vif.clk_i);
  end
  while( !vif.arready );
  vif.arvalid <= 0;
endtask: do_ar

task axi4_driver_base :: do_b();
  do_delay();
  vif.bready <= 1;
  vif.channel_cur  = "B";
  vif.start   <= 1;
  do begin 
    @(posedge vif.clk_i);
  end
  while( !vif.bvalid );
  vif.bready <= 0;
  // This block for check in axi4_sequence(use get_response), if you want do check in axi4_scorebord delete this 
  //////////////////////////////////////////////////////////////
  req.bresp = vif.bresp;
  //////////////////////////////////////////////////////////////
endtask: do_b

task axi4_driver_base :: do_r();
  do_delay();
  vif.rready <= 1;
  vif.channel_cur  = "R";
  vif.start   <= 1;
  do begin 
    @(posedge vif.clk_i);
  end
  while( !vif.rvalid );
  vif.rready <= 0;
  // This block for check in axi4_sequence(use get_response), if you want do check in axi4_scorebord delete this 
  //////////////////////////////////////////////////////////////
  req.rdata     = vif.rdata; 
  req.rresp     = vif.rresp;
  req.rid       = vif.rid;
  //////////////////////////////////////////////////////////////
endtask: do_r
`endif //axi4_DRIVER_BASE_SV