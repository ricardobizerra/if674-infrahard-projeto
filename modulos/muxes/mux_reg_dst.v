module mux_reg_dst (
    input [4:0] instr20_16,
    input [15:0] instr15_00,
    input [1:0] sel,
    output reg [4:0] 
);

always @(sel) begin
    case (sel)
        2'b00: out = instr20_16;
        2'b01: out = instr15_00[15:11];
        2'b10: out = 5'b11101; // reg $29
        2'b11: out = 5'b11111; // reg $31
    endcase
end
endmodule
