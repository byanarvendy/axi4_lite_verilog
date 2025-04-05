`timescale 1ps/1ps

`include "rtl/axi4_lite_master.v"
`include "rtl/axi4_lite_slave.v"
`include "rtl/axi4_lite_interconnect.v"
`include "mem/memory.v"

module axi4_lite_interconnect_tb;
    reg         iCLK;
    reg         iRST;

    /* master interfaces */
    reg        iWRITE_START;
    reg        iREAD_START;
    reg [3:0]  iWRITE_STRB;
    reg [31:0] iWRITE_ADDR;
    reg [31:0] iWRITE_DATA;
    reg [31:0] iREAD_ADDR;

    wire        m_AWVALID;
    wire        m_AWREADY;
    wire [2:0]  m_AWPROT;
    wire [31:0] m_AWADDR;
    wire        m_WVALID;
    wire        m_WREADY;
    wire [3:0]  m_WSTRB;
    wire [31:0] m_WDATA;
    wire        m_BVALID;
    wire        m_BREADY;
    wire [1:0]  m_BRESP;
    wire        m_ARVALID;
    wire        m_ARREADY;
    wire [2:0]  m_ARPROT;
    wire [31:0] m_ARADDR;
    wire        m_RVALID;
    wire        m_RREADY;
    wire [1:0]  m_RRESP;
    wire [31:0] m_RDATA;


    /* slave 0 interfaces */
    wire        s0_AWVALID;
    wire        s0_AWREADY;
    wire [2:0]  s0_AWPROT;
    wire [31:0] s0_AWADDR;
    wire        s0_WVALID;
    wire        s0_WREADY;
    wire [3:0]  s0_WSTRB;
    wire [31:0] s0_WDATA;
    wire        s0_BVALID;
    wire        s0_BREADY;
    wire [1:0]  s0_BRESP;
    wire        s0_ARVALID;
    wire        s0_ARREADY;
    wire [2:0]  s0_ARPROT;
    wire [31:0] s0_ARADDR;
    wire        s0_RVALID;
    wire        s0_RREADY;
    wire [1:0]  s0_RRESP;
    wire [31:0] s0_RDATA;


    /* slave 1 interfaces */
    wire        s1_AWVALID;
    wire        s1_AWREADY;
    wire [2:0]  s1_AWPROT;
    wire [31:0] s1_AWADDR;
    wire        s1_WVALID;
    wire        s1_WREADY;
    wire [3:0]  s1_WSTRB;
    wire [31:0] s1_WDATA;
    wire        s1_BVALID;
    wire        s1_BREADY;
    wire [1:0]  s1_BRESP;
    wire        s1_ARVALID;
    wire        s1_ARREADY;
    wire [2:0]  s1_ARPROT;
    wire [31:0] s1_ARADDR;
    wire        s1_RVALID;
    wire        s1_RREADY;
    wire [1:0]  s1_RRESP;
    wire [31:0] s1_RDATA;

    /* memory interfaces */
    wire                CE_0, RD_0, WR_0;
    wire    [31:0]      READ_0, WRITE_0, ADDR_0;

    wire                CE_1, RD_1, WR_1;
    wire    [31:0]      READ_1, WRITE_1, ADDR_1;


    axi4_lite_interconnect uut (
        .iCLK(iCLK), .iRST(iRST),

        /* master */
        .m_AWVALID(m_AWVALID), .m_AWREADY(m_AWREADY), .m_AWPROT(m_AWPROT), .m_AWADDR(m_AWADDR),
        .m_WVALID(m_WVALID), .m_WREADY(m_WREADY), .m_WSTRB(m_WSTRB), .m_WDATA(m_WDATA),
        .m_BVALID(m_BVALID), .m_BREADY(m_BREADY), .m_BRESP(m_BRESP),
        .m_ARVALID(m_ARVALID), .m_ARREADY(m_ARREADY), .m_ARPROT(m_ARPROT), .m_ARADDR(m_ARADDR),
        .m_RVALID(m_RVALID), .m_RREADY(m_RREADY), .m_RRESP(m_RRESP), .m_RDATA(m_RDATA),

        /* slave 0 */
        .s0_AWVALID(s0_AWVALID), .s0_AWREADY(s0_AWREADY), .s0_AWPROT(s0_AWPROT), .s0_AWADDR(s0_AWADDR),
        .s0_WVALID(s0_WVALID), .s0_WREADY(s0_WREADY), .s0_WSTRB(s0_WSTRB), .s0_WDATA(s0_WDATA),
        .s0_BVALID(s0_BVALID), .s0_BREADY(s0_BREADY), .s0_BRESP(s0_BRESP),
        .s0_ARVALID(s0_ARVALID), .s0_ARREADY(s0_ARREADY), .s0_ARPROT(s0_ARPROT), .s0_ARADDR(s0_ARADDR), 
        .s0_RVALID(s0_RVALID), .s0_RREADY(s0_RREADY), .s0_RRESP(s0_RRESP), .s0_RDATA(s0_RDATA),

        /* slave 1 */
        .s1_AWVALID(s1_AWVALID), .s1_AWREADY(s1_AWREADY), .s1_AWPROT(s1_AWPROT), .s1_AWADDR(s1_AWADDR),
        .s1_WVALID(s1_WVALID), .s1_WREADY(s1_WREADY), .s1_WSTRB(s1_WSTRB), .s1_WDATA(s1_WDATA),
        .s1_BVALID(s1_BVALID), .s1_BREADY(s1_BREADY), .s1_BRESP(s1_BRESP),
        .s1_ARVALID(s1_ARVALID), .s1_ARREADY(s1_ARREADY), .s1_ARPROT(s1_ARPROT), .s1_ARADDR(s1_ARADDR),
        .s1_RVALID(s1_RVALID), .s1_RREADY(s1_RREADY), .s1_RRESP(s1_RRESP), .s1_RDATA(s1_RDATA)
    );

    axi4_lite_master master (
        .iCLK(iCLK), .iRST(iRST),

        /* interfaces */
        .iWRITE_START(iWRITE_START), .iREAD_START(iREAD_START), 
        .iWRITE_STRB(iWRITE_STRB), .iWRITE_ADDR(iWRITE_ADDR), 
        .iWRITE_DATA(iWRITE_DATA), .iREAD_ADDR(iREAD_ADDR),
        
        /* write */
        .m_AWREADY(m_AWREADY), .m_AWVALID(m_AWVALID), 
        .m_AWPROT(m_AWPROT), .m_AWADDR(m_AWADDR),
        .m_WREADY(m_WREADY), .m_WVALID(m_WVALID), 
        .m_WSTRB(m_WSTRB), .m_WDATA(m_WDATA),
        .m_BVALID(m_BVALID), .m_BRESP(m_BRESP), .m_BREADY(m_BREADY),

        /* read */
        .m_ARREADY(m_ARREADY), .m_ARVALID(m_ARVALID), 
        .m_ARPROT(m_ARPROT), .m_ARADDR(m_ARADDR),
        .m_RVALID(m_RVALID), .m_RREADY(m_RREADY), 
        .m_RRESP(m_RRESP), .m_RDATA(m_RDATA)
    );
    
    axi4_lite_slave slave0 (
        .iCLK(iCLK), .iRST(iRST),

        /* interfaces */
        .iREAD_DATA(READ_0),
        .iCE(CE_0), .iRD(RD_0), .iWR(WR_0),
        .oADDR(ADDR_0), .oWRITE_DATA(WRITE_0),

        /* write */
        .s_AWVALID(s0_AWVALID), .s_AWPROT(s0_AWPROT), 
        .s_AWADDR(s0_AWADDR), .s_AWREADY(s0_AWREADY),
        .s_WVALID(s0_WVALID), .s_WSTRB(s0_WSTRB), 
        .s_WDATA(s0_WDATA), .s_WREADY(s0_WREADY),
        .s_BREADY(s0_BREADY), .s_BVALID(s0_BVALID), 
        .s_BRESP(s0_BRESP),

        /* read */
        .s_ARVALID(s0_ARVALID), .s_ARPROT(s0_ARPROT), 
        .s_ARADDR(s0_ARADDR), .s_ARREADY(s0_ARREADY),
        .s_RREADY(s0_RREADY), .s_RVALID(s0_RVALID), 
        .s_RDATA(s0_RDATA), .s_RRESP(s0_RRESP)
    );

    memory mem0(
        .iCLK(iCLK),
        .CE(CE_0), .RD(RD_0), .WR(WR_0),
        .iADDR(ADDR_0), .iWDATA(WRITE_0),
        .oDATA(READ_0)	
    );

    axi4_lite_slave slave1 (
        .iCLK(iCLK), .iRST(iRST),

        /* interfaces */
        .iREAD_DATA(READ_1),
        .iCE(CE_1), .iRD(RD_1), .iWR(WR_1),
        .oADDR(ADDR_1), .oWRITE_DATA(WRITE_1),

        /* write */
        .s_AWVALID(s1_AWVALID), .s_AWPROT(s1_AWPROT), 
        .s_AWADDR(s1_AWADDR), .s_AWREADY(s1_AWREADY),
        .s_WVALID(s1_WVALID), .s_WSTRB(s1_WSTRB), 
        .s_WDATA(s1_WDATA), .s_WREADY(s1_WREADY),
        .s_BREADY(s1_BREADY), .s_BVALID(s1_BVALID), 
        .s_BRESP(s1_BRESP),

        /* read */
        .s_ARVALID(s1_ARVALID), .s_ARPROT(s1_ARPROT), 
        .s_ARADDR(s1_ARADDR), .s_ARREADY(s1_ARREADY),
        .s_RREADY(s1_RREADY), .s_RVALID(s1_RVALID), 
        .s_RDATA(s1_RDATA), .s_RRESP(s1_RRESP)
    );

    memory mem1(
        .iCLK(iCLK),
        .CE(CE_1), .RD(RD_1), .WR(WR_1),
        .iADDR(ADDR_1), .iWDATA(WRITE_1),
        .oDATA(READ_1)	
    );

    initial begin
        iCLK = 1;
        forever #5 iCLK = ~iCLK;
    end

    initial begin
        iRST = 0;
        #20 iRST = 1; 
    end

    initial begin
        $dumpfile("sim/axi4_lite_interconnect_tb.vcd");
        $dumpvars(0, axi4_lite_interconnect_tb);

        /* initialize */
        iRST          = 1'b0;
        iWRITE_START  = 1'b0;
        iREAD_START   = 1'b0;
        iWRITE_ADDR   = 32'h0;
        iWRITE_DATA   = 32'h0;
        iWRITE_STRB   = 4'b0;
        iREAD_ADDR    = 32'h0;

        #10; iRST = 1'b1;

            $display("Testing WRITE to ROM...");
            iWRITE_START    = 1'b1;
            iWRITE_ADDR     = 32'h0000_0010;
            iWRITE_DATA     = 32'h0000_1111;
            iWRITE_STRB     = 4'b1111;

        #20;
            iWRITE_START    = 1'b0;
            iWRITE_ADDR     = 32'h0;
            iWRITE_DATA     = 32'h0;

        #20;
            $display("Testing WRITE to RAM...");
            iWRITE_START    = 1'b1;
            iWRITE_ADDR     = 32'h8000_0011;
            iWRITE_DATA     = 32'h0000_0010;
            iWRITE_STRB     = 4'b1111;

        #20;
            iWRITE_START    = 1'b0;
            iWRITE_ADDR     = 32'h0;
            iWRITE_DATA     = 32'h0;

        #20;
            $display("Testing READ to RAM...");
            iREAD_START     = 1'b1;
            iREAD_ADDR      = 32'h8000_0010;

        #20;
            iREAD_START     = 1'b0;
            iREAD_ADDR      = 32'h0;

        #20;
            $display("Testing READ to ROM...");
            iREAD_START     = 1'b1;
            iREAD_ADDR      = 32'h0000_0005;

        #20;
            iREAD_START     = 1'b0;
            iREAD_ADDR      = 32'h0;
        
        #20;
            $display("Testing WRITE to RAM...");
            iWRITE_START    = 1'b1;
            iWRITE_ADDR     = 32'h8000_0011;
            iWRITE_DATA     = 32'h90;
            iWRITE_STRB     = 4'b1111;

        #20;
            iWRITE_START    = 1'b0;
            iWRITE_ADDR     = 32'h0;
            iWRITE_DATA     = 32'h0;

        #20;
            $display("Testing WRITE to ROM...");
            iWRITE_START    = 1'b1;
            iWRITE_ADDR     = 32'h0000_1011;
            iWRITE_DATA     = 32'h0000_1763;
            iWRITE_STRB     = 4'b1111;

        #20;
            iWRITE_START    = 1'b0;
            iWRITE_ADDR     = 32'h0;
            iWRITE_DATA     = 32'h0;

        #20;
            $display("Testing READ to RoM...");
            iREAD_START     = 1'b1;
            iREAD_ADDR      = 32'h0000_0015;

        #20;
            iREAD_START     = 1'b0;
            iREAD_ADDR      = 32'h0;

        #20;
            $display("Testing READ to RAM...");
            iREAD_START     = 1'b1;
            iREAD_ADDR      = 32'h8000_0040;

        #20;
            iREAD_START     = 1'b0;
            iREAD_ADDR      = 32'h0;

        #40;
        $display("Simulation complete.");
        $finish;
    end

endmodule