// Importação de todas as unidades 

// unidades dadas

`include "components_given/Banco_reg.vhd"
`include "components_given/Instr_Reg.vhd"
`include "components_given/Memoria.vhd"
`include "components_given/RegDesloc.vhd"
`include "components_given/Registrador.vhd"
`include "components_given/ula32.vhd"

// muxes

`include "modulos/muxes/mux_alu_srcA.v"
`include "modulos/muxes/mux_alu_srcB.v"
`include "modulos/muxes/mux_div_srcA.v"
`include "modulos/muxes/mux_div_srcB.v"
`include "modulos/muxes/mux_except.v"
`include "modulos/muxes/mux_iord.v"
`include "modulos/muxes/mux_mem_tomdr.v"
`include "modulos/muxes/mux_mem_toreg.v"
`include "modulos/muxes/mux_pc_src.v"
`include "modulos/muxes/mux_reg_dst.v"
`include "modulos/muxes/mux_shift_src.v"

// resto das unidades

`include "modulos/combc.v"
`include "modulos/control_unit.v"
`include "modulos/divider.v"
`include "modulos/multiplier.v"
`include "modulos/reg_src.v"
`include "modulos/shift_jump.v"
`include "modulos/shift_left2.v"
`include "modulos/shift_left16.v"
`include "modulos/sign_extend8to32.v"
`include "modulos/sign_extend16to32.v"


module cpu (
    input wire clk,
    input wire reset
);

// Control wires 1 bit
    wire PC_write;
    wire branch;
    wire mem_read;
    wire mem_write;
    wire IR_write;
    wire reg_write;
    wire less_than;
    wire div;
    wire mult;
    wire overflow;
    wire dzero;
    wire div_srcA;
    wire div_srcB;
    wire shift_src;
    wire EPC_write;
    wire hi_write;
    wire lo_write;

// Control wires 2 bit

    wire [1:0] reg_dst;
    wire [1:0] except;
    wire [1:0] mem_toMDR;
    wire [1:0] shift_src;
    wire [1:0] BtoC;
    wire [1:0] alu_srcA;

// Control wires 3 bit

    wire [2:0] IorD;
    wire [2:0] alu_srcB;
    wire [2:0] aluOP;
    wire [2:0] PC_src;
    wire [2:0] regOP;

// Control wires 4 bit

    wire [3:0] mem_toreg;

// Instruction wires

    wire[5:0] instr31_26; // funct
    wire[4:0] instr25_21; // rs
    wire[4:0] instr20_16; // rt
    wire[15:0] instr15_0; // address/immediate
    wire[25:0] instr25_0; // offset

// Data wires

    wire [31:0] PC_in;
    wire [31:0] PC_out;

// Flag wires    

    wire zr;
    wire n;
    wire o;
    wire eq;
    wire lt;
    wire gt;

// Registradores
    Registrador PC(
      clk,
      reset,
      PC_write,
      PC_in
      PC_out
    );

    Registrador A(
      clk,
      reset,
      
    );

    Registrador B(
      clk,
      reset,
      
    );

    Registrador AluOut(
      clk,
      reset,
      
    );

    Registrador EPC(
      clk,
      reset,
      
    );

    Registrador MDR(
      clk,
      reset,
      
    );

    Registrador Hi(
      clk,
      reset,
      
    );

    Registrador Lo(
      clk,
      reset,
      
    );

// Memoria

    Memoria MEM(
        
    );

// Muxes



endmodule