//===============================================================
// Name             : vkuznetsov
// File Created     : 2024-12-07
//===============================================================
// NOTE: Please Don't Remove Any Comments or //--- Given Below
//===============================================================

interface axi4_if #(parameter DATA_WIDTH = 32)(input clk_i, aresetn);
  
    //РђРґСЂРµСЃ Р·Р°РїРёСЃРё
    logic           	   awvalid;
    logic             	   awready;
    logic [DATA_WIDTH-1:0] awaddr;
    //РћРїС‚РёРјР°Р»СЊРЅРѕ - awlen, РґР»СЏ РЅРµРѕРґРёРЅРѕС‡РЅС‹С… С‚СЂР°РЅР·Р°РєС†РёР№ 


    //Р”Р°РЅРЅС‹Рµ Р·Р°РїРёСЃРё
    logic           	   wvalid;
    logic           	   wready;
    logic [DATA_WIDTH-1:0] wdata;

    //РћС‚РІРµС‚ Р·Р°РїРёСЃРё РѕС‚ slave 
    logic 				   bvalid;
    logic [2:0] 		   bresp; 
    logic 				   bready;

    //РђРґСЂРµСЃ С‡С‚РµРЅРёСЏ
    logic                  arvalid;
    logic                  arready;
    logic [2:0]            arid;
    logic [DATA_WIDTH-1:0] araddr;
    //РћРїС‚РёРјР°Р»СЊРЅРѕ - arlen, РґР»СЏ РЅРµРѕРґРёРЅРѕС‡РЅС‹С… С‚СЂР°РЅР·Р°РєС†РёР№ 

    //Р”Р°РЅРЅС‹Рµ С‡С‚РµРЅРёСЏ
    logic                  rvalid;
    logic 				   rready;
    logic [2:0] 		   rid;
    logic [DATA_WIDTH-1:0] rdata;
    logic [2:0]			   rresp;

    //РЎРёРіРЅР°Р»С‹ РґР»СЏ РґРёР·Р°Р№РЅР° 
    logic [1:0]			   op;
    logic 				   start;

    string 				   channel_cur;

    property pAwvalidStable;
        @(posedge clk_i & aresetn) channel_cur == "AW" & awvalid |-> ##[0:$] awready;
    endproperty

    property pWvalidStable;
        @(posedge clk_i & aresetn) channel_cur == "W" & wvalid |-> ##[0:$] wready;
    endproperty

    property pBvalidStable;
        @(posedge clk_i & aresetn) channel_cur == "B" & bvalid |-> ##[0:$] bready;
    endproperty

    property pArvalidStable;
        @(posedge clk_i & aresetn) channel_cur == "AR" & arvalid |-> ##[0:$] arready;
    endproperty

    property pRvalidStable;
        @(posedge clk_i & aresetn) channel_cur == "R" & rvalid |-> ##[0:$] rready;
    endproperty

    assert property (pAwvalidStable);
    assert property (pWvalidStable);
    assert property (pBvalidStable);
    assert property (pArvalidStable);
    assert property (pRvalidStable);

endinterface