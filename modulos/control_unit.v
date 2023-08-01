module control_unit(
    input wire clk,
    input wire reset,
// Flag wires
    input wire OV,
    input wire NEG,
    input wire ZR,
    input wire EQ,
    input wire GT,
    input wire LT,
// Determinat of instruction
    input wire [5:0] OPCODE,
    input wire [5:0] FUNCT,
// Control wires with 1 bit
    output wire PC_write,
    output wire branch,
    output wire MEM_wr,
    output wire IR_write,
    output wire A_write,
    output wire B_write,
    output wire MDR_write,
    output wire ALUReg_write,
    output wire EPC_write,
    output wire Hi_write,
    output wire Lo_write,
    output wire REG_write,
    output wire less_than,
    output wire div,
    output wire mult,
    output wire overflow,
    output wire dzero,
    output wire div_srcA,
    output wire div_srcB,
    output wire shift_src,
// Control wires with 2 bit   
    output wire [1:0] reg_dst,
    output wire [1:0] except,
    output wire [1:0] MEM_toMDR,
    output wire [1:0] shift_src,
    output wire [1:0] BtoC,
    output wire [1:0] ALU_srcA,
// Control wires with 3 bit    
    output wire [2:0] IorD,
    output wire [2:0] ALU_srcB,
    output wire [2:0] ALU_OP,
    output wire [2:0] PC_src,
    output wire [2:0] regOP,
// Control wire with 4 bit    
    output wire [3:0] MEM_toreg,
// Control wire for reset instruction
    output reg reset_out    
);

// Variables
reg [2:0] COUNTER;

always @(posedge clk) begin
    
end
    
endmodule