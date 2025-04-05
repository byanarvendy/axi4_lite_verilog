module axi4_lite_interconnect (
    input               iCLK, iRST,

    /* master interface */
        /* write address channel */
        input               m_AWVALID,
        input       [2:0]   m_AWPROT,
        input       [31:0]  m_AWADDR,
        output              m_AWREADY,

        /* write data channel */
        input               m_WVALID,
        input       [3:0]   m_WSTRB,
        input       [31:0]  m_WDATA,

        output              m_WREADY,

        /* write request channel */
        input               m_BREADY,
        output              m_BVALID,
        output      [1:0]   m_BRESP,

        /* read address channel */
        input               m_ARVALID,
        input       [2:0]   m_ARPROT,
        input       [31:0]  m_ARADDR,
        output              m_ARREADY,

        /* read data channel */
        input               m_RREADY,
        output              m_RVALID,
        output      [1:0]   m_RRESP,
        output      [31:0]  m_RDATA,

    /* slave 0 interfcae -> ROM */
        /* write address channel */
        input               s0_AWREADY,
        output              s0_AWVALID,
        output      [2:0]   s0_AWPROT,
        output      [31:0]  s0_AWADDR,

        /* write data channel */
        input               s0_WREADY,
        output              s0_WVALID,
        output      [3:0]   s0_WSTRB,
        output      [31:0]  s0_WDATA,

        /* write response channel */
        input               s0_BVALID,
        input       [1:0]   s0_BRESP,
        output              s0_BREADY,

        /* read address channel */
        input               s0_ARREADY,
        output              s0_ARVALID,
        output      [2:0]   s0_ARPROT,
        output      [31:0]  s0_ARADDR,

        /* read data channel */
        input               s0_RVALID,
        input       [1:0]   s0_RRESP,
        input       [31:0]  s0_RDATA,
        output              s0_RREADY,

    /* slvae 1 interfcae -> RAM */
        /* write address channel */
        input               s1_AWREADY,
        output              s1_AWVALID,
        output      [2:0]   s1_AWPROT,
        output      [31:0]  s1_AWADDR,

        /* write data channel */
        input               s1_WREADY,
        output              s1_WVALID,
        output      [3:0]   s1_WSTRB,
        output      [31:0]  s1_WDATA,

        /* write response channel */
        input               s1_BVALID,
        input       [1:0]   s1_BRESP,
        output              s1_BREADY,

        /* read address channel */
        input               s1_ARREADY,
        output              s1_ARVALID,
        output      [2:0]   s1_ARPROT,
        output      [31:0]  s1_ARADDR,

        /* read data channel */
        input               s1_RVALID,
        input       [1:0]   s1_RRESP,
        input       [31:0]  s1_RDATA,
        output              s1_RREADY
);

    integer i = 0;

    /* transaction tracking */
    reg     active_sel;
    reg     transaction_active;
    wire    transaction_start   = m_AWVALID || m_ARVALID;
    wire    transaction_end     = (m_BREADY && !m_AWVALID) || (m_RREADY && !m_ARVALID);

    always @(posedge iCLK or negedge iRST) begin
        if (!iRST) begin
            transaction_active      <= 1'b0;
            active_sel              <= 1'bx;
        end else begin
            if (transaction_start) begin
                transaction_active  <= 1'b1;
            end
            if (!transaction_active) begin
                active_sel          <= (m_AWADDR != 32'h00000000) ? (m_AWADDR[31] ? 1'b1 : 1'b0) :      /* ROM */
                                       (m_ARADDR != 32'h00000000) ? (m_ARADDR[31] ? 1'b1 : 1'b0) :      /* RAM */
                                       1'bx;
            end
            if (transaction_end) begin
                transaction_active  <= 1'b0;
            end

        end
    end

    /* write address channel */
    assign m_AWREADY    = (active_sel === 1'b0) ? s0_AWREADY       : 
                          (active_sel === 1'b1) ? s1_AWREADY       :
                          1'bx;  

    assign s0_AWVALID   = (active_sel === 1'b0) ? m_AWVALID        : 1'b0;
    assign s1_AWVALID   = (active_sel === 1'b1) ? m_AWVALID        : 1'b0;

    assign s0_AWPROT    = (active_sel === 1'b0) ? m_AWPROT         : 1'b0;
    assign s1_AWPROT    = (active_sel === 1'b1) ? m_AWPROT         : 1'b0;

    assign s0_AWADDR    = (active_sel === 1'b0) ? m_AWADDR[30:0]   : 1'b0;
    assign s1_AWADDR    = (active_sel === 1'b1) ? m_AWADDR[30:0]   : 1'b0;


    /* write data channel */
    assign m_WREADY     = (active_sel === 1'b0) ? s0_WREADY        : 
                          (active_sel === 1'b1) ? s1_WREADY        :
                          1'bx;  

    assign s0_WVALID    = (active_sel === 1'b0) ? m_WVALID         : 1'b0;
    assign s1_WVALID    = (active_sel === 1'b1) ? m_WVALID         : 1'b0;

    assign s0_WSTRB     = (active_sel === 1'b0) ? m_WSTRB          : 1'b0;
    assign s1_WSTRB     = (active_sel === 1'b1) ? m_WSTRB          : 1'b0;

    assign s0_WDATA     = (active_sel === 1'b0) ? m_WDATA          : 32'h0;
    assign s1_WDATA     = (active_sel === 1'b1) ? m_WDATA          : 32'h0;


    /* write response channel */
    assign m_BVALID     = (active_sel === 1'b0) ? s0_BVALID        : 
                          (active_sel === 1'b1) ? s1_BVALID        :
                          1'bx;  

    assign m_BRESP      = (active_sel === 1'b0) ? s0_BRESP         : 
                          (active_sel === 1'b1) ? s1_BRESP         :
                          2'b00;  

    assign s0_BREADY    = (active_sel === 1'b0) ? m_BREADY         : 1'b0;
    assign s1_BREADY    = (active_sel === 1'b1) ? m_BREADY         : 1'b0; 


    /* read address channel */
    assign m_ARREADY    = (active_sel === 1'b0) ? s0_ARREADY       : 
                          (active_sel === 1'b1) ? s1_ARREADY       :
                          1'bx;  

    assign s0_ARVALID   = (active_sel === 1'b0) ? m_ARVALID        : 1'b0;
    assign s1_ARVALID   = (active_sel === 1'b1) ? m_ARVALID        : 1'b0;

    assign s0_ARPROT    = (active_sel === 1'b0) ? m_ARPROT         : 1'b0;
    assign s1_ARPROT    = (active_sel === 1'b1) ? m_ARPROT         : 1'b0;

    assign s0_ARADDR    = (active_sel === 1'b0) ? m_ARADDR[30:0]   : 1'b0;
    assign s1_ARADDR    = (active_sel === 1'b1) ? m_ARADDR[30:0]   : 1'b0;


    /* read data channel */
    assign m_RVALID     = (active_sel === 1'b0) ? s0_RVALID        : 
                          (active_sel === 1'b1) ? s1_RVALID        :
                          1'bx;  

    assign m_RRESP      = (active_sel === 1'b0) ? s0_RRESP         : 
                          (active_sel === 1'b1) ? s1_RRESP         :
                          2'b0; 

    assign m_RDATA      = (active_sel == 1'b0) ? s0_RDATA : s1_RDATA;

    assign s0_RREADY    = (active_sel === 1'b0) ? m_RREADY         : 1'b0;
    assign s1_RREADY    = (active_sel === 1'b1) ? m_RREADY         : 1'b0;


endmodule