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


  // registradores
    Registrador PC(

    );

    Registrador A(

    );

    Registrador B(

    );





endmodule