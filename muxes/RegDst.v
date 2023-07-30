module RegDst (
    input [4:0] rt,
    input [15:0] rd,
    input [1:0] sel,
    output reg [4:0] 
);

always @(sel) begin
    case (sel)
        2'b00: out = rt;
        2'b01: out = rd[15:11];
        2'b10: out = 5'b11101; // reg $29
        2'b11: out = 5'b11111; // reg $31
    endcase
end
endmodule
