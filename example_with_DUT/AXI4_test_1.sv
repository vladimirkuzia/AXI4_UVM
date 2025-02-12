//===============================================================
// File Name        : AXI_test_1
// Description      :
// Package Name     : AXI_pkg
// Name             : vkuznetsov
// File Created     : 2024-12-07
// Copyright        :
//===============================================================
// NOTE: Please Don't Remove Any Comments or //--- Given Below
//===============================================================

`ifndef AXI4_TEST_1_SV
`define AXI4_TEST_1_SV

class AXI4_test_1 extends uvm_test;
    //------------------------------------------
    // Data Members
    //------------------------------------------

    // Sequence Instantiation
    AXI4_sequence      seq_1;
    axi4_agent_cfg     axi_agent_cfg;
    axi4_agent         agent;
    uvm_table_printer  printer;
    //------------------------------------------
    // Constraints
    //------------------------------------------

    //----------    --------------------------------
    // Methods
    //------------------------------------------
    virtual AXI4_if #(DATA_WIDTH)                            vif; 
    // -----------------
    // Standard UVM Methods
    // -----------------
    extern function              new (string name = "AXI4_test_1", uvm_component parent);
    extern virtual function void build_phase (uvm_phase phase);
    extern virtual task          main_phase (uvm_phase phase);
    extern virtual function void end_of_elaboration_phase (uvm_phase phase);

    // -----------------
    // UVM Factory Registration
    // -----------------
    `uvm_component_utils(AXI4_test_1)

endclass: AXI4_test_1


//---------------------------------------------------------------
// Function: new
// 
//---------------------------------------------------------------

function AXI4_test_1::new (string name = "AXI4_test_1", uvm_component parent);
    super.new (name, parent);
endfunction: new


//---------------------------------------------------------------
// Function: build_phase
// 
// Create and configure of testbench structure
//---------------------------------------------------------------

function void AXI4_test_1::build_phase (uvm_phase phase);
    super.build_phase (phase);
    if(!uvm_config_db #(virtual AXI4_if #(DATA_WIDTH)) :: get(null, "uvm_test_top", "vif", vif)) begin
        `uvm_error(get_type_name(), "vif object is not found in test!");
    end
    printer = new;
    // Constructor sequence
    seq_1 = AXI4_sequence :: type_id :: create ("seq_1", this);
    seq_1.vif = this.vif;

    // create agents
    axi_agent_cfg = axi4_agent_cfg :: type_id :: create ("axi4_agent_cfg");

    uvm_config_db #(axi4_agent_cfg) :: set (this, "agent*", "cfg", axi_agent_cfg);

    agent = axi4_agent :: type_id :: create ("agent", this);
    agent.vif = this.vif;
endfunction: build_phase

//---------------------------------------------------------------
// Task: main_phase
// 
// It is to ensure that all the components are ready to start the
// simulation
//---------------------------------------------------------------

task AXI4_test_1::main_phase (uvm_phase phase);
    super.main_phase (phase);
    `uvm_info(get_type_name(), "In main_phase...!!", UVM_DEBUG);

    phase.raise_objection (this);
    seq_1.start (agent.seqr);
    phase.drop_objection (this);
endtask: main_phase

function void AXI4_test_1 :: end_of_elaboration_phase (uvm_phase phase);
    uvm_factory factory = uvm_factory :: get();
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_type_name(),"base_test_in_elaboration_phase", UVM_DEBUG);
    `uvm_info(get_type_name(), $sformatf("\nPrinting the TEST topology : \n%s",this.sprint(printer)),UVM_LOW);
    factory.print();
endfunction : end_of_elaboration_phase

`endif //AXI4_TEST_1_SV
