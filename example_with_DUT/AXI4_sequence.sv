//===============================================================
// Name             : vkuznetsov
// File Created     : 2024-12-07
//===============================================================
// NOTE: Please Don't Remove Any Comments or //--- Given Below
//===============================================================

`ifndef INC_AXI4_SEQUENCE_SV
`define INC_AXI4_SEQUENCE_SV

class AXI4_sequence extends uvm_sequence #(AXI4_sequence_item);

    AXI4_sequence_item req;
    AXI4_agent_cfg     cfg;
    //------------------------------------------
    // Methods
    extern function              new  (string name = "AXI4_sequence");
    extern virtual task          body ();
    extern virtual task          pre_body();
    extern virtual function void analyze_r(AXI4_sequence_item req); 
    extern virtual function void analyze_b(AXI4_sequence_item req);
    extern virtual task          proc_c();
    extern virtual task          do_b();
    extern virtual task          do_r();
    //------------------------------------------
    virtual AXI4_if #(DATA_WIDTH) vif;
    //------------------------------------------
    // UVM Factory Registration
    `uvm_object_utils (AXI4_sequence)
    //------------------------------------------
    

    AXI4_sequence_item q_aw   [$];
    AXI4_sequence_item q_w    [$];
    AXI4_sequence_item q_b    [$];
    AXI4_sequence_item q_r    [$];
    AXI4_sequence_item q_ar[8][$];

    int unsigned a_reg [4], b_reg [4], c_reg [4];
    op_t op; 

endclass: AXI4_sequence


//------------------------------------------
// Methods
function AXI4_sequence::new (string name = "AXI4_sequence");
	super.new (name);
endfunction: new

task AXI4_sequence :: pre_body();
  super.pre_body();
  if (!uvm_config_db #(AXI4_agent_cfg) :: get (null, "uvm_test_top.agent", "cfg", cfg)) begin
    `uvm_error(get_type_name(), "cfg object is not found in config_db!");
  end
endtask: pre_body

function void AXI4_sequence :: analyze_r(AXI4_sequence_item req);
  case(req.araddr)
    A0     : if( req.rdata !== this.a_reg [0] ) begin
                `uvm_error(get_type_name(), $sformatf("Invalid A0 value! Real: %h, Expected: %h",
                    req.rdata, this.a_reg [0]));
             end
    A1     : if( req.rdata !== this.a_reg [1] ) begin
                `uvm_error(get_type_name(), $sformatf("Invalid A1 value! Real: %h, Expected: %h",
                    req.rdata, this.a_reg [1]));
             end
    A2     : if( req.rdata !== this.a_reg [2] ) begin
                `uvm_error(get_type_name(), $sformatf("Invalid A2 value! Real: %h, Expected: %h",
                    req.rdata, this.a_reg [2]));
             end
    A3     : if( req.rdata !== this.a_reg [3] ) begin
                `uvm_error(get_type_name(), $sformatf("Invalid A3 value! Real: %h, Expected: %h",
                    req.rdata, this.a_reg [3]));
             end
    B0     : if( req.rdata !== this.b_reg [0] ) begin
                `uvm_error(get_type_name(), $sformatf("Invalid B0 value! Real: %h, Expected: %h",
                    req.rdata, this.b_reg [0]));
             end
    B1     : if( req.rdata !== this.b_reg [1] ) begin
                `uvm_error(get_type_name(), $sformatf("Invalid B1 value! Real: %h, Expected: %h",
                    req.rdata, this.b_reg [1]));
             end
    B2     : if( req.rdata !== this.b_reg [2] ) begin
                `uvm_error(get_type_name(), $sformatf("Invalid B2 value! Real: %h, Expected: %h",
                    req.rdata, this.b_reg [2]));
             end
    B3     : if( req.rdata !== this.b_reg [3] ) begin
                `uvm_error(get_type_name(), $sformatf("Invalid B3 value! Real: %h, Expected: %h",
                    req.rdata, this.b_reg [3]));
             end
    C0     : if( req.rdata !== this.c_reg [0] ) begin
                `uvm_error(get_type_name(), $sformatf("Invalid C0 value! Real: %h, Expected: %h",
                    req.rdata, this.c_reg [0]));
             end
    C1     : if( req.rdata !== this.c_reg [1] ) begin
                `uvm_error(get_type_name(), $sformatf("Invalid C1 value! Real: %h, Expected: %h",
                    req.rdata, this.c_reg [1]));
             end
    C2     : if( req.rdata !== this.c_reg [2] ) begin
                `uvm_error(get_type_name(), $sformatf("Invalid C2 value! Real: %h, Expected: %h",
                    req.rdata, this.c_reg [2]));
             end
    C3     : if( req.rdata !== this.c_reg [3] ) begin
                `uvm_error(get_type_name(), $sformatf("Invalid C3 value! Real: %h, Expected: %h",
                    req.rdata, this.c_reg [3]));
             end
    default: ;
  endcase
endfunction: analyze_r

function void AXI4_sequence :: analyze_b(AXI4_sequence_item req);
  case(req.awaddr)
    A0     : this.a_reg [0] = req.wdata;
    A1     : this.a_reg [1] = req.wdata;
    A2     : this.a_reg [2] = req.wdata;
    A3     : this.a_reg [3] = req.wdata;
    B0     : this.b_reg [0] = req.wdata;
    B1     : this.b_reg [1] = req.wdata;
    B2     : this.b_reg [2] = req.wdata;
    B3     : this.b_reg [3] = req.wdata;
    C0     : this.c_reg [0] = req.wdata;
    C1     : this.c_reg [1] = req.wdata;
    C2     : this.c_reg [2] = req.wdata;
    C3     : this.c_reg [3] = req.wdata;
    default: ;
  endcase
endfunction: analyze_b

task AXI4_sequence :: proc_c();
    case(req.channel)
        AW: q_aw          .push_back(req);
        W : q_w           .push_back(req);
        B : q_b           .push_back(req);
        AR: q_ar[req.arid].push_back(req);
        R : q_r           .push_back(req);
    endcase
    if(req.start == 1) begin 
        case(req.op)
            ADD: foreach (c_reg[i]) begin
                c_reg[i] = a_reg[i] + b_reg[i];
            end
            SUB:foreach (c_reg[i]) begin
                c_reg[i] = a_reg[i] - b_reg[i];
            end
            MUL:foreach (c_reg[i]) begin
                c_reg[i] = a_reg[i] * b_reg[i];
            end
        endcase
    end
endtask: proc_c

task AXI4_sequence :: do_b();
  AXI4_sequence_item p, p_aw, p_w;
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

task AXI4_sequence :: do_r();
  AXI4_sequence_item p, p_ar;
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

task AXI4_sequence::body ();

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

`endif //INC_AXI4_SEQUENCE_SV