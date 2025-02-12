//===============================================================
// Name             : vkuznetsov
// File Created     : 2024-12-07
//===============================================================
// NOTE: Please Don't Remove Any Comments or //--- Given Below
//===============================================================

`ifndef AXI4_SEQUENCE_ITEM
`define AXI4_SEQUENCE_ITEM

// class: AXI_sequence_item
class axi4_sequence_item extends uvm_sequence_item;

  rand axi4_channel_t                  channel;
  rand bit  [DATA_WIDTH-1:0]           awaddr;
  rand bit  [DATA_WIDTH-1:0]           wdata;
       bit  [2:0]                      bresp;
  rand bit  [2:0]                      arid;
  rand bit  [DATA_WIDTH-1:0]           araddr;
  rand bit  [2:0]                      rid;
       bit  [2:0]                      rresp;
       bit  [DATA_WIDTH-1:0]           rdata;
       bit                             start;                
  rand op_t                            op;
       bit                             rsp_b;
  
  `uvm_object_utils_begin (axi4_sequence_item)
    `uvm_field_enum(axi4_channel_t,           channel,     UVM_ALL_ON)
    `uvm_field_int(                           awaddr,      UVM_ALL_ON)
    `uvm_field_int(                           wdata,       UVM_ALL_ON) 
    `uvm_field_int(                           bresp,       UVM_ALL_ON)
    `uvm_field_int(                           arid,        UVM_ALL_ON)
    `uvm_field_int(                           araddr,      UVM_ALL_ON)
    `uvm_field_int(                           rid,         UVM_ALL_ON) 
    `uvm_field_int(                           rresp,       UVM_ALL_ON)
    `uvm_field_int(                           rdata,       UVM_ALL_ON)
    `uvm_field_int(                           start,       UVM_ALL_ON)
    `uvm_field_enum(op_t,                     op,          UVM_ALL_ON)
    `uvm_field_int(                           rsp_b,       UVM_ALL_ON)
  `uvm_object_utils_end

  extern function new(string name = "axi4_sequence_item");
  extern virtual function string convert2string();

  constraint channel_c {
    soft channel inside {AW, W, B, AR, R};
  }

  constraint op_c {
    soft op inside {ADD, SUB, MUL};
  }

  constraint awwaddr_c {
    soft awaddr inside {32'hC, 32'h10, 32'h14, 32'h18, 32'h1c, 32'h20, 32'h24, 32'h28, 32'h2C, 32'h30, 32'h34, 32'h38, 32'h24};      
  }

  constraint araddr_c {
    soft araddr inside {32'hC, 32'h10, 32'h14, 32'h18, 32'h1c, 32'h20, 32'h24, 32'h28, 32'h2C, 32'h30, 32'h34, 32'h38, 32'h24};      
  }

endclass: axi4_sequence_item

//------------------------------------------------------------------------//
// function: new
// constructor
function axi4_sequence_item :: new(string name = "axi4_sequence_item");
  super.new(name);
endfunction: new

//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
// function: convert2string
// for custom displaying class content
function string axi4_sequence_item :: convert2string();
  string str;
  // convert2string = "TBD";
  str = {str, $sformatf("channel: %0d\n",channel)};
  str = {str, $sformatf("awaddr : %8h\n",awaddr)};
  str = {str, $sformatf("wdata  : %8h\n",wdata)};
  str = {str, $sformatf("bresp  : %3d\n",bresp)};
  str = {str, $sformatf("arid   : %3d\n",arid)};
  str = {str, $sformatf("araddr : %8h\n",araddr)};
  str = {str, $sformatf("rid    : %3d\n",rid)};
  str = {str, $sformatf("rresp  : %3d\n",rresp)};
  str = {str, $sformatf("rdata  : %8h\n",rdata)};
  str = {str, $sformatf("start  : %3d\n",start)};
  str = {str, $sformatf("op     : %3d\n",op)};
    `uvm_info (get_type_name(), str, UVM_LOW)
  // return str;

endfunction

`endif //AXI4_SEQUENCE_ITEM
