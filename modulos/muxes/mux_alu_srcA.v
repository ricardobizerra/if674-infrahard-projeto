module mux_alu_srcA (
    input wire [31:0]PC,
    input wire [31:0]A,
    input wire [31:0]MDRout,
    input wire [1:0] sel,
    output reg [31:0] out
);

always @* begin
    case (sel)
        2'b00: out = PC;
        2'b01: out = A;
        2'b10: out = MDRout;
    endcase
end
endmodule
