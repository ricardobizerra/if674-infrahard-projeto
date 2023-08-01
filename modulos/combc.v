module combC(
    input wire [31:0] B,
    input wire [31:0] mem,
    input wire [1:0] sel,
    output reg[31:0] data_out
);

    always @* begin
        case (sel)
            2b'00: data_out = B; 
            2b'01: data_out = {mem[31:16],B[15:0]};
            2b'10: data_out =  {mem[31:8],B[7:0]}
        endcase    
    end
    
endmodule