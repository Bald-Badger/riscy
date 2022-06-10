module proc_dual_axil(
    input   logic               clk,
    input   logic               resetn,
    input   logic               go,

    /*
    * AXI lite master interface
    */
    output  logic   [31:0]      m00_axil_awaddr,
    output  logic   [2:0]       m00_axil_awprot,
    output  logic               m00_axil_awvalid,
    input   logic               m00_axil_awready,
    output  logic   [31:0]      m00_axil_wdata,
    output  logic   [3:0]       m00_axil_wstrb,
    output  logic               m00_axil_wvalid,
    input   logic               m00_axil_wready,
    input   logic   [1:0]       m00_axil_bresp,
    input   logic               m00_axil_bvalid,
    output  logic               m00_axil_bready,
    output  logic   [31:0]      m00_axil_araddr,
    output  logic   [2:0]       m00_axil_arprot,
    output  logic               m00_axil_arvalid,
    input   logic               m00_axil_arready,
    input   logic   [31:0]      m00_axil_rdata,
    input   logic   [1:0]       m00_axil_rresp,
    input   logic               m00_axil_rvalid,
    output  logic               m00_axil_rready,

    /*
    * AXI lite master interface
    */
    output  logic   [31:0]      m01_axil_awaddr,
    output  logic   [2:0]       m01_axil_awprot,
    output  logic               m01_axil_awvalid,
    input   logic               m01_axil_awready,
    output  logic   [31:0]      m01_axil_wdata,
    output  logic   [3:0]       m01_axil_wstrb,
    output  logic               m01_axil_wvalid,
    input   logic               m01_axil_wready,
    input   logic   [1:0]       m01_axil_bresp,
    input   logic               m01_axil_bvalid,
    output  logic               m01_axil_bready,
    output  logic   [31:0]      m01_axil_araddr,
    output  logic   [2:0]       m01_axil_arprot,
    output  logic               m01_axil_arvalid,
    input   logic               m01_axil_arready,
    input   logic   [31:0]      m01_axil_rdata,
    input   logic   [1:0]       m01_axil_rresp,
    input   logic               m01_axil_rvalid,
    output  logic               m01_axil_rready
);


    axil_interface instr_bus ();
    axil_interface data_bus ();

    proc proc (
        .clk                    (clk),
        .rst_n                  (resetn),
        .go                     (go),
        .data_bus               (data_bus.axil_master),
        .instr_bus              (instr_bus.axil_master)
    );

    always_comb begin : data_interface_linking
        m00_axil_awaddr             = data_bus.axil_awaddr;
        m00_axil_awprot             = data_bus.axil_awprot;
        m00_axil_awvalid            = data_bus.axil_awvalid;
        data_bus.axil_awready       = m00_axil_awready;
        m00_axil_wdata              = data_bus.axil_wdata;
        m00_axil_wstrb              = data_bus.axil_wstrb;
        m00_axil_wvalid             = data_bus.axil_wvalid;
        data_bus.axil_wready        = m00_axil_wready;
        data_bus.axil_bresp         = m00_axil_bresp;
        data_bus.axil_bvalid        = m00_axil_bvalid;
        m00_axil_bready             = data_bus.axil_bready;
        m00_axil_araddr             = data_bus.axil_araddr;
        m00_axil_arprot             = data_bus.axil_arprot;
        m00_axil_arvalid            = data_bus.axil_arvalid;
        data_bus.axil_arready       = m00_axil_arready;
        data_bus.axil_rdata         = m00_axil_rdata;
        data_bus.axil_rresp         = m00_axil_rresp;
        data_bus.axil_rvalid        = m00_axil_rvalid;
        m00_axil_rready             = data_bus.axil_rready;
    end

    always_comb begin : instr_interface_linking
        m01_axil_awaddr             = instr_bus.axil_awaddr;
        m01_axil_awprot             = instr_bus.axil_awprot;
        m01_axil_awvalid            = instr_bus.axil_awvalid;
        instr_bus.axil_awready      = m01_axil_awready;
        m01_axil_wdata              = instr_bus.axil_wdata;
        m01_axil_wstrb              = instr_bus.axil_wstrb;
        m01_axil_wvalid             = instr_bus.axil_wvalid;
        instr_bus.axil_wready       = m01_axil_wready;
        instr_bus.axil_bresp        = m01_axil_bresp;
        instr_bus.axil_bvalid       = m01_axil_bvalid;
        m01_axil_bready             = instr_bus.axil_bready;
        m01_axil_araddr             = instr_bus.axil_araddr;
        m01_axil_arprot             = instr_bus.axil_arprot;
        m01_axil_arvalid            = instr_bus.axil_arvalid;
        instr_bus.axil_arready      = m01_axil_arready;
        instr_bus.axil_rdata        = m01_axil_rdata;
        instr_bus.axil_rresp        = m01_axil_rresp;
        instr_bus.axil_rvalid       = m01_axil_rvalid;
        m01_axil_rready             = instr_bus.axil_rready;
    end

endmodule
