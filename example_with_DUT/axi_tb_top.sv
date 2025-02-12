//===============================================================
// File Name        : axi_tb_top
// Description      :
// Name             : vkuznetsov
// File Created     : 2024-12-07
// Copyright        :
//===============================================================
// NOTE: Please Don't Remove Any Comments or //--- Given Below
//===============================================================

module  axi_tb_top ();
//------------------------------------------
// Including & Importing Required UVM Libraries
//------------------------------------------
 import uvm_pkg::*;
`include "uvm_macros.svh"
 import AXI4_package::*;

//------------------------------------------
// Importing User Defined Packages
//------------------------------------------


//------------------------------------------
// Local Variables
//------------------------------------------
logic clk_i;
logic aresetn;
//------------------------------------------
// Event
//------------------------------------------

//------------------------------------------
// Clock Instantiation
//------------------------------------------

//------------------------------------------
// Interfaces Instantiation
//------------------------------------------
AXI4_if AXI4_if(.clk_i(clk_i), .aresetn(aresetn));

//------------------------------------------
// Interface containers
//------------------------------------------
wire       done;
//------------------------------------------
// DUT Wrapper Instantiation
//------------------------------------------
array_alu_axi4 u0 (
    .clk_i(clk_i),
    .aresetn(aresetn),
    // AXI4
    .awvalid(AXI4_if.awvalid),
    .awready(AXI4_if.awready),
    .awaddr(AXI4_if.awaddr),
    .wvalid(AXI4_if.wvalid),
    .wready(AXI4_if.wready),
    .wdata(AXI4_if.wdata),
    .bvalid(AXI4_if.bvalid),
    .bresp(AXI4_if.bresp),
    .bready(AXI4_if.bready),
    .arvalid(AXI4_if.arvalid),
    .arready(AXI4_if.arready),
    .arid(AXI4_if.arid),
    .araddr(AXI4_if.araddr),
    .rvalid(AXI4_if.rvalid),
    .rready(AXI4_if.rready),
    .rid(AXI4_if.rid),
    .rdata(AXI4_if.rdata),
    .rresp(AXI4_if.rresp),
    // Control-status
    .op(AXI4_if.op),
    .start(AXI4_if.start),
    .done(done)
);
//------------------------------------------
// Assertions & Timing Checks
//------------------------------------------

//------------------------------------------
// Interface - Virtual Interface Config_db Setup
//------------------------------------------


initial begin
    //------------------------------------------
    // Default Configurations
    //------------------------------------------
    uvm_top.set_report_verbosity_level_hier (UVM_LOW);
    uvm_config_db #(virtual AXI4_if #(DATA_WIDTH)) :: set(null, "uvm_test_top", "vif", AXI4_if);
    //------------------------------------------
    // Interface Containers Creation
    //------------------------------------------


    
    //------------------------------------------
    // Pass the Interface Containers
    //------------------------------------------
    // uvm_config_db #(virtual AXI_if :: set (null, "uvm_test_top", "AXI_if", AXI_if);

    //------------------------------------------
    // Run Test
    //------------------------------------------
    fork
        reset();
        run_test();
    join_none
    repeat(1000) @(posedge clk_i);
    reset();
end

// initial $monitor("clk_i = %b aresetn = %b", clk_i, aresetn);

//------------------------------------------
// Initialize the Reference Clock and Reset (if needed)
//------------------------------------------
parameter CLK_PERIOD = 10;

initial begin
    clk_i <= 0;
    forever begin
        #(CLK_PERIOD/2) clk_i <= ~clk_i;
    end
end

task reset();
    aresetn <= 0;
    #(100*CLK_PERIOD);
    aresetn <= 1;
endtask
//------------------------------------------
// Reference Clock Generation (if needed)
//------------------------------------------
//always begin
//end
endmodule : axi_tb_top