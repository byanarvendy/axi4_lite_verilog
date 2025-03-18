module axi4_lite_slave (
    input               iCLK, iRST,

    /* write address channel */
    input               s_AWVALID,
    input       [2:0]   s_AWPROT,
    input       [31:0]  s_AWADDR,
    output  reg         s_AWREADY,

    /* write data channel */
    input               s_WVALID,
    input       [3:0]   s_WSTRB,
    input       [31:0]  s_WDATA,
    output  reg         s_WREADY,

    /* write response channel */
    input               s_BREADY,
    output  reg         s_BVALID,
    output  reg [1:0]   s_BRESP,

    /* read address channel */
    input               s_ARVALID,
    input       [2:0]   s_ARPROT,
    input       [31:0]  s_ARADDR,
    output  reg         s_ARREADY,

    /* read data channel */
    input               s_RREADY,
    output  reg         s_RVALID,
    output  reg [31:0]  s_RDATA,
    output  reg [1:0]   s_RRESP
);

    reg [31:0] mem [0:255];
    initial begin
        $readmemh("mem/memory_rom_init.hex", mem, 0, 255);
    end

    reg [31:0] read_addr;

    /* write transaction */
    always @(posedge iCLK or negedge iRST) begin
        if (!iRST) begin
            s_AWREADY   <= 1'b0;
            s_WREADY    <= 1'b0;
            s_BVALID    <= 1'b0;
            s_BRESP     <= 2'b00;
        end else begin
            s_AWREADY   <= 1'b0;
            s_WREADY    <= 1'b0;

            if (s_AWVALID && !s_AWREADY) begin
                s_AWREADY   <= 1'b1;
            end
            if (s_WVALID && !s_WREADY) begin
                s_WREADY    <= 1'b1;
            end

            if (s_AWREADY && s_WREADY && s_AWVALID && s_WVALID) begin
                mem[s_AWADDR] <= s_WDATA;
                s_BRESP     <= 2'b00;
                s_BVALID    <= 1'b1;
            end

            if (s_BVALID && s_BREADY) begin
                s_BVALID    <= 1'b0;
            end
        end
    end

    /* read transaction */
    always @(posedge iCLK or negedge iRST) begin
        if (!iRST) begin
            s_ARREADY   <= 1'b0;
            s_RVALID    <= 1'b0;
            s_RRESP     <= 2'b00;
            s_RDATA     <= 32'b0;
            read_addr   <= 32'b0;
        end else begin
            s_ARREADY   <= 1'b0;
            s_RVALID    <= 1'b0;

            if (s_ARVALID && !s_ARREADY) begin
                s_ARREADY   <= 1'b1;
                read_addr   <= s_ARADDR;
            end

            if (s_ARREADY && !s_RVALID) begin
                s_RVALID    <= 1'b1;
                s_RDATA     <= mem[read_addr];
                s_RRESP     <= 2'b00; // OKAY response
            end

            if (s_RVALID && s_RREADY) begin
                s_RVALID    <= 1'b0;
            end
        end
    end

endmodule