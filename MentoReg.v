module MentoReg (
    input [31:0] AluOut,
    input [31:0] MDRout,
    input [31:0] Hi,
    input [31:0] Lo,
    input [31:0] shiftRegOut,
    input [31:0] instructionShiftLeft16,
    input [3:0] sel,
    output reg [31:0] out
);

always @* begin
    case (sel)
        4'b0000: out = AluOut;
        4'b0001: out = MDRout;
        4'b0010: out = Hi;
        4'b0011: out = Lo;
        4'b0100: out = 227;
        4'b0101: out = 0;
        4'b0110: out = 1;
        4'b0111: out = shiftRegOut;
        4'b1000: out = instructionShiftLeft16;
    endcase
end
endmodule
