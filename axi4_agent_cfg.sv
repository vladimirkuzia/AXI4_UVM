//===============================================================
// Name             : vkuznetsov
// File Created     : 2024-12-07
//===============================================================
// NOTE: Please Don't Remove Any Comments or //--- Given Below
//===============================================================

`ifndef AXI4_AGENT_CFG_SV
`define AXI4_AGENT_CFG_SV

class axi4_agent_cfg extends uvm_object;

    //------------------------------------------
    // Variables
    virtual axi4_if vif;
    rand int unsigned m_pkt_amount = 100;
    rand int unsigned m_delay_min  = 0;
    rand int unsigned m_delay_max  = 10;
    
    rand uvm_active_passive_enum is_active  = UVM_ACTIVE;   // Mode agent UVM_ACTIVE or UVM_PASSIVE
    //------------------------------------------
    extern function      new (string name = "AXI_agent_cfg");
    extern function void post_randomize ();
    //------------------------------------------
    // UVM Factory Registraion
    `uvm_object_utils_begin (axi4_agent_cfg)
        // -----------------
        // Add field configurations
        // -----------------
        `uvm_field_int(m_pkt_amount,          UVM_ALL_ON)
        `uvm_field_int(m_delay_min,           UVM_ALL_ON)
        `uvm_field_int(m_delay_max,           UVM_ALL_ON)
        // -----------------
    `uvm_object_utils_end
    // //------------------------------------------

    //------------------------------------------
    // Agent Monitor Knobs
    //------------------------------------------

    //------------------------------------------
    // Agent Driver Knobs
    //------------------------------------------

    //------------------------------------------
    // Constraints
    //------------------------------------------

    constraint master_pkt_amount_c {
        soft m_pkt_amount inside {[50:300]};
    }

    constraint master_delay_min_c {
        soft m_delay_min inside {[0:4]};
    }

    constraint master_delay_max_c {
        soft m_delay_max inside {[5:10]};
    }

endclass: axi4_agent_cfg

//------------------------------------------
// Methods
//------------------------------------------
function axi4_agent_cfg :: new (string name = "AXI_agent_cfg");
    super.new (name);

    // -----------------
    // Get configuration
    // -----------------


    // -----------------
    // Construct children
    // ------------------


    // ------------------
    // Configure children
    // ------------------
endfunction: new

function void axi4_agent_cfg :: post_randomize ();
    string str;
    str = {str, $sformatf("\n==================================================\n")};
    str = {str, $sformatf("master_pkt_amount : %0d\n",
        m_pkt_amount)};
    str = {str, $sformatf("master_delay_min  : %0d\n",
        m_delay_min)};
    str = {str, $sformatf("master_delay_max  : %0d\n",
        m_delay_max)};
    str = {str, $sformatf("\n==================================================\n")};
    `uvm_info (get_type_name(), str, UVM_LOW)
endfunction : post_randomize

`endif //AXI_AGENT_CFG_SV