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
    output wire DIV_on,
    output wire MULT_on,
    output wire overflow,
    output wire dzero,
    output wire div_srcA,
    output wire div_srcB,
    output wire shift_src,
    output wire Hi_src,
    output wire Lo_src,
// Control wires with 2 bit   
    output wire [1:0] reg_dst,
    output wire [1:0] except,
    output wire [1:0] MEM_toMDR,
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

    reg [6:0] STATE; 
    reg [6:0] COUNTER;

// Parameters

// Main States Parameters
    // initial states

    parameter ST_reset = 6'd0;
    parameter ST_fetch0 = 6'd1;
    parameter ST_fetch1 = 6'd2;
    parameter ST_decode = 6'd3;

// Opcodes Parameters
    // R instructions
    parameter R_OPCODE    = 6'h0;
    parameter FUNCT_ADD   = 6'h20;
    parameter FUNCT_AND   = 6'h24;
    parameter FUNCT_DIV   = 6'h1a;
    parameter FUNCT_MULT  = 6'h18;
    parameter FUNCT_JR    = 6'h8;
    parameter FUNCT_MFHI  = 6'h10;
    parameter FUNCT_MFLO  = 6'h12;
    parameter FUNCT_SLL   = 6'h0;
    parameter FUNCT_SLLV  = 6'h4;
    parameter FUNCT_SLT   = 6'h2a;
    parameter FUNCT_SRA   = 6'h3;
    parameter FUNCT_SRAV  = 6'h7;
    parameter FUNCT_SRL   = 6'h2;
    parameter FUNCT_SUB   = 6'h22;
    parameter FUNCT_BREAK = 6'hd;
    parameter FUNCT_RTE   = 6'h13;
    parameter FUNCT_DIVM  = 6'h5;

    // I instructions
    parameter ADDI   = 6'h8;
    parameter ADDIU  = 6'h9;
    parameter BEQ    = 6'h4;
    parameter BNE    = 6'h5;
    parameter BLE    = 6'h6;
    parameter BGT    = 6'h7;
    parameter ADDM   = 6'h1;
    parameter LB     = 6'h20;
    parameter LH     = 6'h21;
    parameter LUI    = 6'hf;
    parameter LW     = 6'h23;
    parameter SB     = 6'h28;
    parameter SH     = 6'h29;
    parameter SLTI   = 6'ha;
    parameter SW     = 6'h2b;

    // J instructions
    parameter J = 6'h2; 
    parameter JAL = 6'h3; 

initial begin
    // Initial reset 
    reset = 1'b1;
end

always @(posedge clk) begin
    if (reset == 1'b1) begin
        STATE = ST_fetch0;
        // Setting ALL signals to zero
        PC_write     = 1'b0;
        branch       = 1'b0;
        MEM_wr       = 1'b0;
        IR_write     = 1'b0;
        A_write      = 1'b0;
        B_write      = 1'b0;
        MDR_write    = 1'b0;
        ALUReg_write = 1'b0;
        EPC_write    = 1'b0;
        Hi_write     = 1'b0;
        Lo_write     = 1'b0;
        REG_write    = 1'b0;
        less_than    = 1'b0;
        DIV_on       = 1'b0;
        MULT_on      = 1'b0;
        overflow     = 1'b0;
        dzero        = 1'b0;
        div_srcA     = 1'b0;
        div_srcB     = 1'b0;
        shift_src    = 1'b0;
        Hi_src       = 1'b0;
        Lo_src       = 1'b0;
        reg_dst      = 2'b00;
        except       = 2'b00; 
        MEM_toMDR    = 2'b00;
        shift_src    = 2'b00;
        BtoC         = 2'b00;
        ALU_srcA     = 2'b00;
        IorD         = 3'b000;
        ALU_srcB     = 3'b000;
        ALU_OP       = 3'b000;
        PC_src       = 3'b000;
        regOP        = 3'b000;
        MEM_toreg    = 4'b0000;
        // Setting couter for next operation
        COUNTER = 7'b0000000;
        // reseting the stack top

    end 
    else begin
        case (STATE)
            if(COUNTER == 7'bb0000000 || COUNTER == 7'bb0000001) begin
                ST_fetch0:begin
                    PC_write     = 1'b0;
                    branch       = 1'b0;
                    MEM_wr       = 1'b0;
                    IR_write     = 1'b0;
                    A_write      = 1'b0;
                    B_write      = 1'b0;
                    MDR_write    = 1'b0;
                    MEM_wr       = 1'b1;  ///
                    ALUReg_write = 1'b0;
                    EPC_write    = 1'b0;
                    Hi_write     = 1'b0;
                    Lo_write     = 1'b0;
                    REG_write    = 1'b0;
                    less_than    = 1'b0;
                    DIV_on       = 1'b0;
                    MULT_on      = 1'b0;
                    overflow     = 1'b0;
                    dzero        = 1'b0;
                    div_srcA     = 1'b0;
                    div_srcB     = 1'b0;
                    shift_src    = 1'b0;
                    Hi_src       = 1'b0;
                    Lo_src       = 1'b0;
                    reg_dst      = 2'b00;
                    except       = 2'b00; 
                    MEM_toMDR    = 2'b00;
                    shift_src    = 2'b00;
                    BtoC         = 2'b00;
                    ALU_srcA     = 2'b00;  ///
                    IorD         = 3'b001; ///
                    ALU_srcB     = 3'b001; ///
                    ALU_OP       = 3'b001; ///
                    PC_src       = 3'b000;
                    regOP        = 3'b000;
                    MEM_toreg    = 4'b0000;
                    STATE = ST_fetch1;
                    COUNTER = COUNTER + 1;
                end

                ST_fetch1:begin
                    STATE = ST_decode;      
                    PC_write     = 1'b1;    ///
                    branch       = 1'b0;
                    MEM_wr       = 1'b0;
                    IR_write     = 1'b1;    ///
                    A_write      = 1'b0;
                    B_write      = 1'b0;
                    MDR_write    = 1'b0;
                    MEM_wr       = 1'b1;
                    ALUReg_write = 1'b0;
                    EPC_write    = 1'b0;
                    Hi_write     = 1'b0;
                    Lo_write     = 1'b0;
                    REG_write    = 1'b0;
                    less_than    = 1'b0;
                    DIV_on       = 1'b0;
                    MULT_on      = 1'b0;
                    overflow     = 1'b0;
                    dzero        = 1'b0;
                    div_srcA     = 1'b0;
                    div_srcB     = 1'b0;
                    shift_src    = 1'b0;
                    Hi_src       = 1'b0;
                    Lo_src       = 1'b0;
                    reg_dst      = 2'b00;
                    except       = 2'b00; 
                    MEM_toMDR    = 2'b00;
                    shift_src    = 2'b00;
                    BtoC         = 2'b00;
                    ALU_srcA     = 2'b00;
                    IorD         = 3'b001;
                    ALU_srcB     = 3'b001;
                    ALU_OP       = 3'b001;
                    PC_src       = 3'b000; ///
                    regOP        = 3'b000;
                    MEM_toreg    = 4'b0000;
                    COUNTER = COUNTER + 1;
                end

                ST_decode:begin
                    ALU_srcA = 2'b00;
                    ALU_srcB = 3'b011;
                    ALU_OP = 3'b001;
 
                    PC_write     = 1'b1;
                    branch       = 1'b0;
                    MEM_wr       = 1'b0;
                    IR_write     = 1'b1;
                    A_write      = 1'b0;
                    B_write      = 1'b0;
                    MDR_write    = 1'b0;
                    MEM_wr       = 1'b1;
                    ALUReg_write = 1'b0;
                    EPC_write    = 1'b0;
                    Hi_write     = 1'b0;
                    Lo_write     = 1'b0;
                    REG_write    = 1'b0;
                    less_than    = 1'b0;
                    DIV_on       = 1'b0;
                    MULT_on      = 1'b0;
                    overflow     = 1'b0;
                    dzero        = 1'b0;
                    div_srcA     = 1'b0;
                    div_srcB     = 1'b0;
                    shift_src    = 1'b0;
                    Hi_src       = 1'b0;
                    Lo_src       = 1'b0;
                    reg_dst      = 2'b00;
                    except       = 2'b00; 
                    MEM_toMDR    = 2'b00;
                    shift_src    = 2'b00;
                    BtoC         = 2'b00;
                    ALU_srcA     = 2'b00;  ///
                    IorD         = 3'b001; 
                    ALU_srcB     = 3'b011; ///
                    ALU_OP       = 3'b001; ///
                    PC_src       = 3'b000;
                    regOP        = 3'b000;
                    MEM_toreg    = 4'b0000;
                    COUNTER = COUNTER + 1;
                end
            end

            // INSTRUCTIONS STATES
            else if(COUNTER == 7'b0000011) begin
                case(OPCODE)
                    ADD: begin
                        STATE = ST_ADD
                    end
                endcase
            end
        endcase
    end
end
    
endmodule