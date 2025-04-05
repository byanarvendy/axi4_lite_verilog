module memory (
    input               iCLK, CE, RD, WR,
    input       [31:0]  iADDR,
    input       [31:0]  iWDATA,
    output reg  [31:0]  oDATA
);

    reg [31:0] mem [0:255];

    always @(posedge iCLK) begin
        if (WR) begin
            mem[iADDR] <= iWDATA;
            // $display("iADDR: 0x%x, mem[iADDR]: 0x%x", iADDR, mem[iADDR]);
        end

        if (CE && RD) begin
            oDATA = mem[iADDR];
        end else begin
            oDATA = 32'h00000000;
        end
    end

    initial begin
        $readmemh("mem/memory_rom_init.hex", mem, 0, 255);
    end
endmodule
