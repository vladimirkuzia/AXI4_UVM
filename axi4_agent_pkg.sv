//===============================================================
// Name             : vkuznetsov
// File Created     : 2024-12-07
//===============================================================
// NOTE: Please Don't Remove Any Comments or //--- Given Below
//===============================================================

`ifndef AXI4_AGENT_PKG_SV
`define AXI4_AGENT_PKG_SV

// package: axi4_agent_pkg
package axi4_agent_pkg;

  typedef enum logic [31:0]{
    OP    = 32'h0,
    START = 32'h4,
    DONE  = 32'h8,
    A0    = 32'hC,
    A1    = 32'h10,
    A2    = 32'h14,
    A3    = 32'h18,
    B0    = 32'h1c,
    B1    = 32'h20,
    B2    = 32'h24,
    B3    = 32'h28,
    C0    = 32'h2C,
    C1    = 32'h30,
    C2    = 32'h34,
    C3    = 32'h38
  } array_alu_regs_t;

  typedef enum logic [1:0] {
    ADD = 2'b00,
    SUB = 2'b01,
    MUL = 2'b10
  } op_t;

  typedef enum logic [2:0] {
    OKAY   = 3'b000,
    SLVERR = 3'b010
  } resp_t;

  //5 РєР°РЅР°Р»РѕРІ : РђРґСЂРµСЃ Р·Р°РїРёСЃРё, РґР°РЅРЅС‹С… Р·Р°РїРёСЃРё, РѕС‚РІРµС‚Р° РЅР° Р·Р°РїРёСЃСЊ, Р°РґСЂРµСЃР° С‡С‚РµРЅРёСЏ, РґР°РЅРЅС‹С… С‡С‚РµРЅРёСЏ
  typedef enum {
        AW, W, B, AR, R
  } axi4_channel_t;

  parameter DATA_WIDTH = 32;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  `include "axi4_agent_cfg.sv"
  `include "axi4_sequence_item.sv"
  `include "axi4_sequence.sv"
  // `include "axi4_base_sequence.sv"
  // `include "axi4_basic_sequence.sv"
  `include "axi4_driver_base.sv"
  `include "axi4_monitor_base.sv"
  `include "axi4_agent.sv"
  `include "axi4_test_1.sv"

  `include "seq_lib/axi4_seq_lib.sv"
endpackage: axi4_agent_pkg

`endif //AXI4_AGENT_PKG_SV