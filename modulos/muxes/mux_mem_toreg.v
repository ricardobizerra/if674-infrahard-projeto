module mux_mem_toreg (
    input wire [31:0] AluOut,
    input wire [31:0] MDRout,
    input wire [31:0] Hiout,
    input wire [31:0] Loout,
    input wire [31:0] shiftRegOut,
    input wire [31:0] offsetShiftLeft16,
    input wire [3:0] sel,
    output reg [31:0] out
);

always @* begin
    case (sel)
        4'b0000: out = AluOut;
        4'b0001: out = MDRout;
        4'b0010: out = Hiout;
        4'b0011: out = Loout;
        4'b0100: out = 32'b00000000000000000000000011100011; // 227
        4'b0101: out = 32'b00000000000000000000000000000000;   // 0
        4'b0110: out = 32'b00000000000000000000000000000001;   // 1
        4'b0111: out = shiftRegOut;
        4'b1000: out = offsetShiftLeft16ShiftLeft16;
    endcase
end
endmodule
