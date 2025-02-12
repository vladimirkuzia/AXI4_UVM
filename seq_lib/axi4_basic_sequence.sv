//===============================================================
// Name             : vkuznetsov
// File Created     : 2024-12-07
//===============================================================
// NOTE: Please Don't Remove Any Comments or //--- Given Below
//===============================================================

`ifndef INC_AXI4_BASIC_SEQUENCE_SV
`define INC_AXI4_BASIC_SEQUENCE_SV

class axi4_basic_sequence extends axi4_base_sequence;

    //------------------------------------------
    // Methods
    extern function     new  (string name = "axi4_basic_sequence");
    extern virtual task body ();
    extern virtual function void analyze_r(axi4_sequence_item req); 
    extern virtual function void analyze_b(axi4_sequence_item req);
    extern virtual task          proc_c();
    extern virtual task          do_b();
    extern virtual task          do_r();
    //------------------------------------------
    virtual AXI4_if #(DATA_WIDTH) vif;
    //------------------------------------------
    // UVM Factory Registration
    `uvm_object_utils (axi4_basic_sequence)
    //------------------------------------------

    axi4_sequence_item q_aw   [$];
    axi4_sequence_item q_w    [$];
    axi4_sequence_item q_b    [$];
    axi4_sequence_item q_r    [$];
    axi4_sequence_item q_ar[8][$];
 
endclass: AXI4_basic_sequence


//------------------------------------------
// Methods
function AXI4_basic_sequence::new (string name = "AXI4_basic_sequence");
	super.new (name);
endfunction: new

function void AXI4_basic_sequence :: analyze_r(axi4_basic_sequence req);
// Empty function for override
// This function is needed to check the data in your design, an example of writing can be found in the "Example"
endfunction: analyze_r

function void AXI4_basic_sequence :: analyze_b(axi4_sequence_item req);
// Empty function for override
// This function is needed to check the data in your design, an example of writing can be found in the "Example"
endfunction: analyze_b

task axi4_basic_sequence :: proc_c();
  case(req.channel)
    AW: q_aw          .push_back(req);
    W : q_w           .push_back(req);
    B : q_b           .push_back(req);
    AR: q_ar[req.arid].push_back(req);
    R : q_r           .push_back(req);
  endcase
endtask: proc_c

task axi4_basic_sequence :: do_b();
  axi4_sequence_item p, p_aw, p_w;
  wait( q_b.size() );
  p = q_b.pop_front();
  if( !(q_aw.size() && q_w.size()) ) begin
    `uvm_error(get_type_name(), "%t Unexpected write response!");
      // $stop();
  end
  else begin
    // Check if error
    if( p.bresp !== OKAY ) begin
      `uvm_error(get_type_name(), "%t Slave didn't return OKAY in write response!");
      // $stop();
    end
    // Remove transactions from write queues
    p_aw = q_aw.pop_front();
    p_w  = q_w.pop_front();
    // Form final transaction and analyze
    p_aw.wdata = p_w.wdata;
    analyze_b(p_aw);
  end
endtask: do_b

task axi4_basic_sequence :: do_r();
  axi4_sequence_item p, p_ar;
  wait( q_r.size() );
  p = q_r.pop_front();
  if( !(q_ar[p.rid].size()) ) begin
    `uvm_error(get_type_name(), "%t Unexpected read response with %3b ID!");
        // $stop();
  end
  else begin
    // Check if error
    if( p.rresp !== OKAY ) begin
      `uvm_error(get_type_name(), "%t Slave didn't return OKAY in read response!");
      // $stop();
    end
    // Remove transaction from read queue
    p_ar = q_ar[p.rid].pop_front();
    // Form final transaction and analyze
    p_ar.rdata = p.rdata;
    analyze_r(p_ar);
  end
endtask: do_r

task axi4_basic_sequence::body ();

    axi4_channel_t axi4_channel_t_e;

    super.body();
    for (int i = 0; i <= cfg.m_pkt_amount; i++) begin
        req  = new();
        wait_for_grant();
        if (! req.randomize() with {
            awaddr inside {32'hC, 32'h10, 32'h14, 32'h18, 32'h1c, 32'h20, 32'h24, 32'h28, 32'h2C, 32'h30, 32'h34, 32'h38, 32'h24};
            araddr inside {32'hC, 32'h10, 32'h14, 32'h18, 32'h1c, 32'h20, 32'h24, 32'h28, 32'h2C, 32'h30, 32'h34, 32'h38, 32'h24};
            channel == axi4_channel_t_e;
        }
        ) begin
            `uvm_error(get_type_name(), "Can't randomize packet!");
            $finish();
        end
        axi4_channel_t_e = axi4_channel_t_e.next();
        send_request(req);
            `uvm_info(get_type_name(), "Before wait_for_item_done call", UVM_LOW);
        get_response(req);
            `uvm_info(get_type_name(), "Get response", UVM_LOW);
        req.print();
        fork 
            proc_c();
            if (req.channel == R) do_r();
            if (req.channel == B) do_b();
        join
    end
endtask: body

//------------------------------------------

`endif //INC_AXI4_BASIC_SEQUENCE_SV