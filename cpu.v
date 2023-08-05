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
`include "modulos/muxes/mux_Hi_src.v"
`include "modulos/muxes/mux_Lo_src.v"

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

// Control wires with 1 bit
    wire PC_write;
    wire MEM_wr;
    wire IR_write;
    wire A_write;
    wire B_write;
    wire MDR_write;
    wire ALUReg_write;
    wire EPC_write;
    wire Hi_write;
    wire Lo_write;
    wire REG_write;
    wire less_than;
    wire DIV_on;
    wire MULT_on;
    wire div_srcA;
    wire div_srcB;
    wire shift_src;
    wire Hi_src;
    wire Lo_src;

// Control wires with 2 bit

    wire [1:0] reg_dst;
    wire [1:0] except;
    wire [1:0] MEM_toMDR;
    wire [1:0] shift_src;
    wire [1:0] BtoC;
    wire [1:0] ALU_srcA;

// Control wires witht 3 bit

    wire [2:0] IorD;
    wire [2:0] ALU_srcB;
    wire [2:0] ALU_OP;
    wire [2:0] PC_src;
    wire [2:0] regOP;

// Control wires with 4 bit

    wire [3:0] MEM_toreg;

// Instruction wires

    wire[5:0] OPCODE; 
    wire[4:0] RS; 
    wire[4:0] RT; 
    wire[5:0] FUNCT;  
    wire[15:0] IMMEDIATE; 
    wire[25:0] OFFSET;

// Data wires

    wire [31:0] PC_in;
    wire [31:0] PC_out;
    wire [31:0] MEM_address;
    wire [31:0] MEM_out;
    wire [31:0] combC_out;
    wire [31:0] BREG_to_A;
    wire [31:0] BREG_to_B;
    wire [31:0] A_out;
    wire [31:0] B_out;
    wire [31:0] SXTND8TO32_MEM_out;
    wire [31:0] SXTND8TO32_EXC_out;
    wire [31:0] SXTND16TO32_IMMEDIATE_out;
    wire [31:0] SXTND16TO32_MEM_out;
    wire [31:0] ALU_A_in;
    wire [31:0] ALU_srcB_out;
    wire [31:0] ALU_out;
    wire [31:0] SL2_IMMEDIATE_out;
    wire [31:0] SL16_out;
    wire [31:0] SJ_out;
    wire [31:0] _out;
    wire [31:0] MDR_in;
    wire [31:0] MDR_out;
    wire [31:0] ALUReg_out;
    wire [31:0] MDR_out;
    wire [31:0] Hi_in;
    wire [31:0] Hi_out;
    wire [31:0] Lo_in;
    wire [31:0] Lo_out;
    wire [31:0] N;
    wire [31:0] REGSHIFT_out;
    wire [31:0] except_out;
    wire [31:0] DIV_min;
    wire [31:0] DIV_max;
    wire [31:0] MULT_min;
    wire [31:0] MULT_max;
    wire [31:0] C_out;
    wire [31:0] EPC_out;
    wire [31:0] PC_src_out;

// Data wires with less than 32 bits

    wire [4:0] REG_write_in;

// Flag wires    

    wire OV;
    wire ZR;
    wire NEG;
    wire EQ;
    wire LT;
    wire GT;

// Registradores
    Registrador PC(
      clk,
      reset,
      PC_write,
      PC_in,
      PC_out
    );

    Registrador A(
      clk,
      reset,
      A_write,
      BREG_to_A,
      A_out
    );

    Registrador B(
      clk,
      reset,
      B_write,
      BREG_to_B,
      B_out
    );

    Registrador ALUReg(
      clk,
      reset,
      ALUReg_write,
      ALU_out,
      ALUReg_out
    );

    Registrador EPC(
      clk,
      reset,
      EPC_write,
      ALU_out,
      EPC_out
    );

    Registrador MDR(
      clk,
      reset,
      MDR_write,
      MDR_in,
      MDR_out
    );

    Registrador Hi(
      clk,
      reset,
      Hi_write,
      Hi_in,
      Hi_out
    );

    Registrador Lo(
      clk,
      reset,
      Lo_write,
      Lo_in,
      Lo_out
    );

// Muxes

    mux_alu_srcA M_ALU_SRCA(
      PC_out,
      A_out,
      MDR_out,
      ALU_srcA,
      ALU_A_in
    );

    mux_alu_srcB M_ALU_SRCB(
      B_out,
      SXTND16TO32_IMMEDIATE_out,
      SL2_IMMEDIATE_out,
      A_out,
      ALU_srcB,
      ALU_srcB_out  
    );

    mux_div_srcA M_DIV_SRCA(

    );

    mux_div_srcB M_DIV_SRCB(

    );

    mux_except M_EXCEPT(
      except,
      except_out
    );

    mux_iord M_IORD(
      PC_out,
      ALUReg_out,
      except_out,
      A_out,
      B_out,
      IorD,
      MEM_address
    );

    mux_mem_tomdr M_MEM_TOMDR(
      MEM_out,
      SXTND16TO32_MEM_out,
      SXTND8TO32_MEM_out,
      MEM_toMDR,
      MDR_in
    );

    mux_mem_toreg M_MEM_TOREG(
      ALUReg_out,
      MDR_out,
      Hi_out,
      Lo_out,
      REGSHIFT_out,
      SL16_out,
      MEM_toreg,
      BREG_write_data
    );

    mux_pc_src M_PC_SRC(
      ALU_out,
      ALUReg_out,
      SJ_out,
      SXTND8TO32_EXC_out,
      EPC_out,
      PC_src,
      PC_src_out
    );

    mux_reg_dst M_REG_DST(
      RT,
      IMMEDIATE,
      reg_dst,
      BREG_write_reg
    );

    mux_shift_src M_SHIFT_SRC(
      IMMEDIATE,
      B_out,
      shift_src,
      N
    );

    mux_Hi_src M_HI_SRC(
      DIV_max,
      MULT_max,
      Hi_src,
      Hi_in
    );

    mux_Lo_src M_LO_SRC(
      DIV_min,
      MULT_min,
      Lo_src,
      Lo_in
    );

// Shifts

    shift_left2 SL2_IMMEDIATE(
      SXTND16TO32_IMMEDIATE_out,
      SL2_IMMEDIATE_out
    );

    shift_left16 SL16(
      IMMEDIATE,
      SL16_out
    );

    OFFSET = {RS,RT,IMMEDIATE}
    shift_jump SJ(
      OFFSET,
      PC_out,
      SJ_out
    );

// Sign Extends 

    sign_extend8to32  SXTND8TO32_EXC(
      MEM_out,
      SXTND8TO32_EXC_out
    );

    sign_extend8to32  SXTND8TO32_MEM(
      MEM_out,  // In th sign_extend just  one byte is taked
      SXTND8TO32_MEM_out
    );

    sign_extend16to32 SXTND16TO32_IMMEDIATE(
      IMMEDIATE,
      SXTND16TO32_IMMEDIATE_out
    );

    sign_extend16to32 SXTND16TO32_MEM(
      MEM_out[15:0], // Two bytes of MEM
      SXTND16TO32_MEM_out
    );

// Memory

    Memoria MEM(
      MEM_address,
      clk,
      MEM_wr,
      combC_out,
      MEM_out
    );

// IR 

    Instr_Reg IR(
      clk,
      reset,
      IR_write,
      MEM_out,
      OPCODE,
      RS,
      RT,
      IMMEDIATE
    );

// BReg

    Banco_reg BREG(
      clk,
      reset,
      REG_write,
      RS,
      RT,
      BREG_write_reg,
      BREG_write_data,
      BREG_to_A,
      BREG_to_B
    );

// ULA

    ula32 ALU(
      ALU_A_in,
      ALU_srcB_out,
      ALU_OP,
      ALU_out,
      OV,
      NEG,
      ZR,
      EQ,
      GT,
      LT
    );

// ShiftReg 
    RegDesloc REGSHIFT(
      clk,
      reset,
      REGOP,
      N,
      ALU_srcB_out,
      REGSHIFT_out  
    );

// CombC   

    combc C(
      B_out,
      MEM_out,
      BtoC,
      C_out
    );

// Divider

    divider DIV(
      clk,
      reset,
      DIV_on,
      //
      //
      Dzero,
      DIV_min,
      DIV_max
    );
    
// Multiplier

    multiplier MULT(
      clk,
      reset,
      MULT_on,
      A_out,
      B_out,
      MULT_min,
      MULT_max
    );

// Unidade de Controle

    FUNCT = IMMEDIATE[5:0];
    control_unit CTRL(
      clk,
      reset,
      OV,
      ZR,
      NEG,
      EQ,
      GT,
      LT,
      OPCODE,
      FUNCT,
      PC_write,
      MEM_wr,
      IR_write,
      A_write,
      B_write,
      MDR_write,
      ALUReg_write,
      EPC_write,
      Hi_write,
      Lo_write,
      REG_write,
      less_than,
      DIV_on,
      MULT_on,
      div_srcA,
      div_srcB,
      shift_src,
      Hi_src;
      Lo_src;
      reg_dst,
      except,
      MEM_toMDR,
      shift_src,
      BtoC,
      ALU_srcA,
      IorD,
      ALU_srcB,
      ALU_OP,
      PC_src,
      regOP,
      MEM_toreg
    );

endmodule