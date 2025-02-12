//===============================================================
// Name             : vkuznetsov
// File Created     : 2024-12-07
//===============================================================
// NOTE: Please Don't Remove Any Comments or //--- Given Below
//===============================================================

`ifndef INC_AXI4_BASE_SEQUENCE_SV
`define INC_AXI4_BASE_SEQUENCE_SV

class axi4_base_sequence extends uvm_sequence #(axi4_sequence_item);

    AXI4_agent_cfg cfg; // agents configuration object

    //------------------------------------------
    // Methods
    extern function     new (string name = "axi4_base_sequence");
    extern virtual task pre_body ();
    extern virtual task post_body ();
    //------------------------------------------

    //------------------------------------------
    // UVM Factory Registration
    `uvm_object_utils (axi4_base_sequence)
    //------------------------------------------

endclass: axi4_base_sequence

//------------------------------------------
// Methods

function axi4_base_sequence::new (string name = "axi4_base_sequence");
    super.new (name);
endfunction: new

task axi4_base_sequence::pre_body ();
    super.pre_body ();

    if (starting_phase != null) starting_phase.raise_objection(this);

    // get the configuration object of the current agent 
    if (!uvm_config_db #(AXI4_agent_cfg) :: get (null, "uvm_test_top.agent", "cfg", cfg)) begin
        if (cfg == null) `uvm_fatal(get_type_name(), $sformatf("%s.cfg == null", get_full_name()) );
    end
    else
        `uvm_fatal(get_type_name(), "AXI4_agent_cfg config_db lookup failed")

endtask: pre_body

task axi4_base_sequence::post_body ();
    super.post_body ();

    if (starting_phase != null) starting_phase.drop_objection(this);

endtask: post_body

//------------------------------------------

`endif //INC_AXI4_BASE_SEQUENCE_SV