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
    output reg PC_write,
    output reg branch,
    output reg MEM_wr,
    output reg IR_write,
    output reg A_write,
    output reg B_write,
    output reg MDR_write,
    output reg ALUReg_write,
    output reg EPC_write,
    output reg Hi_write,
    output reg Lo_write,
    output reg REG_write,
    output reg less_than,
    output reg DIV_on,
    output reg MULT_on,
    output reg div_srcA,
    output reg div_srcB,
    output reg shift_src,
    output reg Hi_src,
    output reg Lo_src,
// Control wires with 2 bit   
    output reg [1:0] reg_dst,
    output reg [1:0] except,
    output reg [1:0] MEM_toMDR,
    output reg [1:0] BtoC,
    output reg [1:0] ALU_srcA,
// Control wiress with 3 bit    
    output reg [2:0] IorD,
    output reg [2:0] ALU_srcB,
    output reg [2:0] ALU_OP,
    output reg [2:0] PC_src,
    output reg [2:0] regOP,
// Control wire with 4 bit    
    output reg [3:0] MEM_toreg,
// Control wire for reset instruction
    output reg reset_out    
);

// Variables

    reg [6:0] STATE; 
    reg [6:0] COUNTER;
    reg [5:0] SHIFT_MODE;

// Parameters

// Main States Parameters
    // initial states

    parameter ST_reset       = 7'd0;
    parameter ST_fetch0      = 7'd1;
    parameter ST_fetch1      = 7'd2;
    parameter ST_decode      = 7'd3;
    parameter ST_decode2     = 7'd15;

    // exceptions states

    parameter ST_noopcode    = 7'd4;
    parameter ST_overflow    = 7'd5;
    parameter ST_divzr       = 7'd6;
    parameter ST_except      = 7'd7;

    // R instructions

    parameter ST_add         = 7'd8;
    parameter ST_sub         = 7'd9;
    parameter ST_and         = 7'd10;
    parameter ST_BREG_write  = 7'd11;
    parameter ST_BREG_write2 = 7'd12;
    parameter ST_BREG_write3 = 7'd34;
    parameter ST_BREG_write4 = 7'd52;
    parameter ST_BREG_write5 = 7'd53;
    parameter ST_SLT         = 7'd41;
    parameter ST_SLTI        = 7'd42;
    parameter ST_SLL_SLLV    = 7'd43;
    parameter ST_SRA_SRAV    = 7'd44;
    parameter ST_SRL         = 7'd45;
    parameter ST_ShiftS      = 7'd46;
    parameter ST_ShiftImmediate = 7'd47;
    parameter ST_ShiftVariable  = 7'd48;
    parameter ST_Rte            = 7'd49;


    // I instructions

    parameter ST_addi        = 7'd13;
    parameter ST_addiu       = 7'd14;
    parameter ST_lui         = 7'd22;
    parameter ST_beq         = 7'd23;
    parameter ST_bne         = 7'd24;
    parameter ST_ble         = 7'd25;
    parameter ST_bgt         = 7'd26; 
    parameter ST_load_adress = 7'd27; 
    parameter ST_MEM_read    = 7'd28;
    parameter ST_MEM_to      = 7'd29;  
    parameter ST_MEM_to_MDR1 = 7'd30;  
    parameter ST_MEM_to_MDR2 = 7'd31;  
    parameter ST_MEM_to_MDR3 = 7'd32; 
    parameter ST_REG_write   = 7'd33; 
    parameter ST_store1      = 7'd34;
    parameter ST_store2      = 7'd35;
    parameter ST_store3      = 7'd36;

    // J instructions

    parameter ST_jump        = 7'd37;
    parameter ST_jal         = 7'd38;
    parameter ST_adress_store= 7'd39;
    parameter  ST_jr         = 7'd40;
    parameter ST_addm = 7'd49;
    parameter ST_addm2 = 7'd50;
    parameter ST_addm3 = 7'd51; 
    parameter ST_MEM_read_addm = 7'd52;

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


always @(posedge clk) begin
    PC_write     = 1'b0;
    branch       = 1'b0;
    MEM_wr       = 1'b0;
    IR_write     = 1'b0;
    A_write      = 1'b0;
    B_write      = 1'b0;
    MDR_write    = 1'b0;
    ALUReg_write = 1'b0;
    EPC_write    = 1'b0;
    REG_write    = 1'b0;
    Hi_write     = 1'b0;
    Lo_write     = 1'b0;
    less_than    = 1'b0;
    shift_src    = 1'b0;
    DIV_on       = 1'b0;
    MULT_on      = 1'b0;
    div_srcA     = 1'b0;
    div_srcB     = 1'b0;
    Hi_src       = 1'b0;
    Lo_src       = 1'b0;
    except       = 2'b00; 
    MEM_toMDR    = 2'b00;
    BtoC         = 2'b00;
    ALU_srcA     = 2'b00;
    reg_dst      = 2'b00; 
    IorD         = 3'b000;
    ALU_srcB     = 3'b000;
    ALU_OP       = 3'b000;
    PC_src       = 3'b000;
    regOP        = 3'b000;
    MEM_toreg    = 4'b0000;
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
        less_than    = 1'b0;
        DIV_on       = 1'b0;
        MULT_on      = 1'b0;
        div_srcA     = 1'b0;
        div_srcB     = 1'b0;
        shift_src    = 1'b0;
        Hi_src       = 1'b0;
        Lo_src       = 1'b0;
        except       = 2'b00; 
        MEM_toMDR    = 2'b00;
        BtoC         = 2'b00;
        ALU_srcA     = 2'b00;
        IorD         = 3'b000;
        ALU_srcB     = 3'b000;
        ALU_OP       = 3'b000;
        PC_src       = 3'b000;
        regOP        = 3'b000;
        // Setting couter for next operation
        COUNTER = 7'b0000000;
        // reseting the stack top
        reg_dst      = 2'b10; 
        REG_write    = 1'b1;
        MEM_toreg    = 4'b0100;
        reset_out    = 1'b0;
    end 
    else begin
        case (STATE)

            ST_fetch0: begin
                PC_write     = 1'b0;
                branch       = 1'b0;
                IR_write     = 1'b0;
                A_write      = 1'b0;
                B_write      = 1'b0;
                MDR_write    = 1'b0;
                MEM_wr       = 1'b0;  ///
                ALUReg_write = 1'b0;
                EPC_write    = 1'b0;
                Hi_write     = 1'b0;
                Lo_write     = 1'b0;
                REG_write    = 1'b0;
                less_than    = 1'b0;
                DIV_on       = 1'b0;
                MULT_on      = 1'b0;
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
                IorD         = 3'b000; ///
                ALU_srcB     = 3'b001; ///
                ALU_OP       = 3'b001; ///
                PC_src       = 3'b000;
                regOP        = 3'b000;
                MEM_toreg    = 4'b0000;
                COUNTER = COUNTER + 1;
                if (COUNTER == 7'd2) begin  
                    STATE = ST_fetch1;
                end
                else begin
                    STATE = ST_fetch0;
                end
            end
            ST_fetch1:begin // COUNTER = 3
                STATE = ST_decode;      
                PC_write     = 1'b1;    ///
                branch       = 1'b0;
                MEM_wr       = 1'b0;
                IR_write     = 1'b1;    ///
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
                ALU_srcB     = 3'b001;
                ALU_OP       = 3'b001;
                PC_src       = 3'b000; ///
                regOP        = 3'b000;
                MEM_toreg    = 4'b0000;
                COUNTER      = COUNTER + 1;
            end
            ST_decode:begin   // COUNTER = 4  
                STATE        = ST_decode2;   
                PC_write     = 1'b0;
                branch       = 1'b0;
                MEM_wr       = 1'b0;
                IR_write     = 1'b0;
                A_write      = 1'b1; ///
                B_write      = 1'b1; ///
                MDR_write    = 1'b0;
                ALUReg_write = 1'b0;
                EPC_write    = 1'b0;
                Hi_write     = 1'b0;
                Lo_write     = 1'b0;
                REG_write    = 1'b0;
                less_than    = 1'b0;
                DIV_on       = 1'b0;
                MULT_on      = 1'b0;
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
                IorD         = 3'b000; 
                ALU_srcB     = 3'b001; ///
                ALU_OP       = 3'b001; ///
                PC_src       = 3'b000;
                regOP        = 3'b000;
                MEM_toreg    = 4'b0000;
                COUNTER = COUNTER + 1;
            end

            ST_add:begin
                STATE = ST_BREG_write;
                ALU_srcA = 2'b01;
                ALU_srcB = 3'b000;
                ALU_OP = 3'b001;
                ALUReg_write = 1'b1;
                COUNTER = COUNTER + 1;  // COUNTER = 1
            end

            ST_and:begin
                STATE = ST_BREG_write;
                ALU_srcA = 2'b01;
                ALU_srcB = 3'b000;
                ALU_OP = 3'b011;
                ALUReg_write = 1'b1;
                COUNTER = COUNTER + 1;  // COUNTER = 1
            end

            ST_sub:begin
                STATE = ST_BREG_write;
                ALU_srcA = 2'b01;
                ALU_srcB = 3'b000;
                ALU_OP = 3'b010;
                ALUReg_write = 1'b1;
                COUNTER = COUNTER + 1;  // COUNTER = 1
            end

            ST_addm:begin
                STATE = ST_MEM_read_addm;
                ALU_srcA = 2'b01;
                ALU_srcB = 3'b010;
                ALU_OP = 3'b001;
                ALUReg_write = 1;
                COUNTER = COUNTER + 1; // COUNTER = 1
            end 

            ST_MEM_read_addm:begin
                IorD = 3'b001;
                MEM_wr = 0;
                COUNTER = COUNTER + 1;
                if (COUNTER == 7'd3) begin
                    STATE = ST_addm2;
                end else begin
                    STATE = ST_MEM_read_addm;
                end

            end

            ST_addm2:begin
                STATE = ST_addm3;
                MEM_toMDR = 2'b00;
                MDR_write = 1;
                COUNTER = COUNTER + 1;
            end

            ST_addm3:begin
                STATE = ST_BREG_write2;
                ALU_srcA = 2'b10;
                ALU_srcB = 3'b000;
                ALU_OP = 3'b001;
                ALUReg_write = 1;
                COUNTER = COUNTER + 1;
            end

            ST_load_adress: begin  //Estado para calcular o endereço do valor a ser carregado. 
                STATE = ST_MEM_read; 
                ALU_srcA = 2'b01;
                ALU_srcB = 3'b010;
                ALU_OP   = 3'b001;
                ALUReg_write = 1;
                COUNTER  = COUNTER + 1; // COUNTER = 1
                if (OPCODE == SW) begin
                    STATE = ST_store1;
                end else begin
                    STATE = ST_MEM_read;
                end

            end

            ST_MEM_read: begin //Lendo o valor a ser carregado. 
                IorD = 3'b001;
                MEM_wr = 0;
                COUNTER = COUNTER + 1;
                if (COUNTER == 7'd3) begin
                    if (OPCODE == LW) begin
                    STATE = ST_MEM_to_MDR1; 
                    end else if (OPCODE == LH) begin
                        STATE = ST_MEM_to_MDR2;
                    end else if (OPCODE == LB) begin
                        STATE = ST_MEM_to_MDR3;
                    end else if (OPCODE == SH) begin
                        STATE = ST_store2;
                    end else if (OPCODE == SB)begin
                        STATE = ST_store3;
                    end else if (OPCODE == ADDM) begin
                        STATE = ST_addm2;
                    end
                end else begin // COUNTER = 2
                    STATE = ST_MEM_read;
                end
            end

            ST_MEM_to_MDR1: begin //selecionando o valor que irá entra na registrador temporário.
                STATE = ST_REG_write;
                MEM_toMDR = 2'b00;
                MDR_write = 1;
            end

            ST_MEM_to_MDR2: begin //selecionando o valor que irá entra na registrador temporário.
                STATE = ST_REG_write;
                MEM_toMDR = 2'b01;
                MDR_write = 1;
            end

            ST_MEM_to_MDR3: begin //selecionando o valor que irá entra na registrador temporário.
                STATE = ST_REG_write;
                MEM_toMDR = 2'b10;
                MDR_write = 1;
            end

            ST_REG_write: begin //Escrevendo no banco de registradores.
                STATE = ST_fetch0;
                COUNTER = 7'b0000000;
                MEM_toreg = 4'b0001;
                reg_dst = 2'b00;
                REG_write = 1;
                COUNTER = 7'd0;
            end

            ST_store1: begin //Armazenando na memoria.
                STATE = ST_fetch0;
                COUNTER = 7'b0000000;
                BtoC = 2'b00;
                IorD = 3'b001;
                MEM_wr = 1;
                COUNTER = 7'd0;
            end

            ST_store2: begin //Armazenando na memoria.
                STATE = ST_fetch0;
                COUNTER = 7'b0000000;
                BtoC = 2'b01;
                IorD = 3'b001;
                MEM_wr = 1;
                COUNTER = 7'd0;
            end

            ST_store3: begin //Armazenando na memoria.
                STATE = ST_fetch0;
                COUNTER = 7'b0000000;
                BtoC = 2'b10;
                IorD = 3'b001;
                MEM_wr = 1;
                COUNTER = 7'd0;
            end

            ST_jump: begin
                STATE = ST_fetch0;
                COUNTER = 7'b0000000;
                PC_write = 1;
                branch = 1;
                PC_src = 3'b010;
            end

            ST_jal: begin //calculando endereço 
                STATE = ST_adress_store;
                ALU_srcA = 2'b00;
                ALU_OP = 3'b000;
                ALUReg_write = 1'b1;
                COUNTER = COUNTER + 1;
            end

            ST_adress_store: begin //armazenando endereço 
                STATE = ST_fetch0;
                COUNTER = 7'b0000000;
                MEM_toreg = 4'b0000;
                reg_dst = 2'b11;
                REG_write = 1;
                PC_src = 3'b010;
                PC_write = 1;
                branch = 1;
                COUNTER = 7'd0;
            end

            ST_jr: begin
                STATE = ST_fetch0;
                COUNTER = 7'b0000000;
                ALU_srcA = 2'b01;
                ALU_OP = 3'b000;
                PC_src = 3'b000;
                branch = 1;
                PC_write = 1;
                COUNTER = 7'd0;
            end

            ST_beq: begin
                STATE = ST_fetch0;
                COUNTER = 7'b0000000;
                ALU_srcA = 2'b01;
                ALU_srcB = 3'b000;
                if (EQ == 1) begin
                    ALU_OP = 3'b111;
                    PC_src = 3'b001;
                    PC_write = 1;
                end
            end

            ST_bne: begin
                STATE = ST_fetch0;
                COUNTER = 7'b0000000;
                ALU_srcA = 2'b01;
                ALU_srcB = 3'b000;
                if (EQ == 0) begin
                    ALU_OP = 3'b111;
                    PC_src = 3'b001;
                    PC_write = 1;
                end
            end

            ST_bgt: begin
                STATE = ST_fetch0;
                COUNTER = 7'b0000000;
                ALU_srcA = 2'b01;
                ALU_srcB = 3'b000;
                if (GT == 1) begin
                    ALU_OP = 3'b111;
                    PC_src = 3'b001;
                    PC_write = 1;
                end
            end

            ST_ble: begin
                STATE = ST_fetch0;
                COUNTER = 7'b0000000;
                ALU_srcA = 2'b01;
                ALU_srcB = 3'b000;
                if (GT == 0) begin
                    ALU_OP = 3'b111;
                    PC_src = 3'b001;
                    PC_write = 1;
                end
            end


            ST_BREG_write:begin
                if (OV) begin 
                    STATE = ST_overflow;
                    COUNTER = COUNTER + 1;  // COUNTER = 2
                end
                else begin
                    STATE = ST_fetch0;
                    COUNTER = 7'b0000000;
                    REG_write = 1'b1;
                    reg_dst = 2'b01;
                    MEM_toreg = 4'b0000;
                end
            end

            ST_BREG_write2:begin
                if(OV) begin
                    STATE = ST_overflow;    // COUNTER = 2
                    COUNTER = COUNTER + 1;
                end
                else begin
                        STATE = ST_fetch0;
                        COUNTER = 7'b0000000;
                        REG_write = 1'b1;
                        MEM_toreg = 4'b0000;
                        reg_dst = 2'b00;
                    end
            end

            ST_SLT:begin
                STATE = ST_BREG_write4;
                ALU_srcA = 2'b01;
                ALU_srcB = 3'b000;
            end

            ST_SLTI:begin
                STATE = ST_BREG_write5;
                ALU_srcA = 2'b01;
                ALU_srcB = 3'b010;
            end

            ST_ShiftImmediate:begin
                STATE = SHIFT_MODE;
                ALU_srcB = 3'b000;
                shift_src = 1'b0;
                regOP = 3'b001;
            end

            ST_ShiftVariable:begin
                STATE = SHIFT_MODE;
                ALU_srcB = 3'b100;
                shift_src = 1'b1;
                regOP = 3'b001;
            end

            ST_SLL_SLLV:begin
                STATE = ST_ShiftS;
                regOP = 3'b010;
            end

            ST_SRL:begin
                STATE = ST_ShiftS;
                regOP = 3'b011;
            end

            ST_SRA_SRAV:begin
                STATE = ST_ShiftS;
                regOP = 3'b100;
            end

            ST_ShiftS:begin
                STATE = ST_fetch0;
                MEM_toreg = 4'b0111;
                reg_dst = 2'b01;
                REG_write = 1'b1;
                COUNTER = 0;
            end

            ST_BREG_write3:begin
                STATE = ST_fetch0;
                COUNTER = 7'b0000000;
                REG_write = 1'b1;
                MEM_toreg = 4'b0000;
                reg_dst = 2'b01;
           end

            ST_BREG_write4:begin
                if (LT == 1) begin
                    STATE = ST_fetch0;
                    ALU_OP = 3'b111;
                    MEM_toreg = 4'b0110;
                    reg_dst = 2'b01;
                    REG_write = 1'b1;
                end
                else begin
                    STATE = ST_fetch0;
                    ALU_OP = 3'b111;
                    MEM_toreg = 4'b0101;
                    reg_dst = 2'b01;
                    REG_write = 1'b1;
                end

                COUNTER = 0; 
            end

            ST_BREG_write5:begin
                if (LT == 1) begin
                    STATE = ST_fetch0;
                    ALU_OP = 3'b111;
                    MEM_toreg = 4'b0110;
                    reg_dst = 2'b00;
                    REG_write = 1'b1;
                end
                else begin
                    STATE = ST_fetch0;
                    ALU_OP = 3'b111;
                    MEM_toreg = 4'b0101;
                    reg_dst = 2'b00;
                    REG_write = 1'b1;
                end

                COUNTER = 0;
            end

            ST_Rte:begin
                STATE = ST_fetch0;
                COUNTER = 7'b0000000;
                PC_src = 3'b100;
                PC_write = 1;
            end 

            ST_noopcode:begin
                except = 2'b00;
                IorD = 3'b010;
                MEM_wr = 1'b0;
                ALU_srcA = 2'b00;
                ALU_srcB = 3'b001;
                ALU_OP = 3'b010;
                COUNTER = COUNTER + 1;
                if (COUNTER == 7'd1) begin
                    STATE = ST_except;
                end
                else begin // COUNTER = 0
                    STATE = ST_noopcode;
                end
            end

            ST_overflow:begin
                except = 2'b01;
                IorD = 3'b010;
                MEM_wr = 1'b0;
                ALU_srcA = 2'b00;
                ALU_srcB = 3'b001;
                ALU_OP = 3'b010;
                COUNTER = COUNTER + 1;  
                if (COUNTER == 7'd4) begin
                    STATE = ST_except;
                end
                else begin  //COUNTER = 3
                    STATE = ST_overflow;
                end
            end

            ST_divzr:begin
                except = 2'b10;
                IorD = 3'b010;
                MEM_wr = 1'b0;
                ALU_srcA = 2'b00;
                ALU_srcB = 3'b001;
                ALU_OP = 3'b010;
                COUNTER = COUNTER + 1;
                if (COUNTER == 7'b0001000) begin
                    STATE = ST_except;
                end
                else begin
                    STATE = ST_divzr;
                end
            end

            ST_except:begin
                STATE = ST_fetch0;
                EPC_write = 1'b1;
                PC_src  = 3'b011;
                PC_write = 1'b1;
                COUNTER = 7'b0000000;
            end

            ST_addi:begin
                STATE = ST_BREG_write2; 
                ALU_srcA = 2'b01;
                ALU_srcB = 3'b010;
                ALU_OP = 3'b001;
                ALUReg_write = 1'b1;
                COUNTER = COUNTER + 1;
            end

            ST_addiu:begin
                STATE = ST_BREG_write3;
                ALU_srcA = 2'b01;
                ALU_srcB = 3'b010;
                ALU_OP = 3'b001;
                ALUReg_write = 1'b1;
                COUNTER = COUNTER + 1;
            end

            ST_lui:begin
              STATE = ST_fetch0;
              COUNTER = 7'b0000000;
              MEM_toreg = 4'b1000;
              reg_dst = 2'b00;
              REG_write = 1'b1;
            end

        // INSTRUCTIONS STATES
        ST_decode2: begin
            case(OPCODE)
                // R instructions
                R_OPCODE:begin
                    case(FUNCT)
                        FUNCT_ADD:begin
                            STATE = ST_add;
                            COUNTER = 7'b0000000;
                        end

                        FUNCT_AND:begin
                            STATE = ST_and;
                            COUNTER = 7'b0000000;
                        end

                        FUNCT_DIV:begin

                        end

                        FUNCT_MULT:begin
                            
                        end

                        FUNCT_JR:begin
                            STATE = ST_jr;
                            COUNTER = 7'b0000000;
                        end

                        FUNCT_MFHI:begin
                            
                        end

                        FUNCT_MFLO:begin
                            
                        end

                        FUNCT_SLL:begin
                            STATE = ST_ShiftImmediate;
                            SHIFT_MODE = ST_SLL_SLLV;
                            COUNTER = 7'b0000000;
                        end

                        FUNCT_SLLV:begin
                            STATE = ST_ShiftVariable;
                            SHIFT_MODE = ST_SLL_SLLV;
                            COUNTER = 7'b0000000;
                        end

                        FUNCT_SLT:begin
                            STATE = ST_SLT;
                        end

                        FUNCT_SRA:begin
                            STATE = ST_ShiftImmediate;
                            SHIFT_MODE = ST_SRA_SRAV;
                            COUNTER = 7'b0000000;
                        end

                        FUNCT_SRAV:begin
                            STATE = ST_ShiftVariable;
                            SHIFT_MODE = ST_SRA_SRAV;
                            COUNTER = 7'b0000000;
                        end

                        FUNCT_SRL:begin
                            STATE = ST_ShiftImmediate;
                            SHIFT_MODE = ST_SRL;
                            COUNTER = 7'b0000000;
                        end

                        FUNCT_SUB:begin
                            STATE = ST_sub;
                            COUNTER = 7'b0000000;
                        end

                        FUNCT_BREAK:begin
                            
                        end

                        FUNCT_RTE:begin
                            STATE = ST_Rte;
                            COUNTER = 7'b0000000;
                        end

                        FUNCT_DIVM:begin
                            
                        end
                    endcase 
                end
                // I instructions 
                ADDI:begin
                    STATE = ST_addi;
                    COUNTER = 7'b0000000;
                end

                ADDIU:begin
                    STATE = ST_addiu;
                    COUNTER = 7'b0000000;
                end

                BEQ:begin
                    STATE = ST_beq;
                    COUNTER = COUNTER + 1;
                end

                BNE:begin
                    STATE = ST_beq;
                    COUNTER = COUNTER + 1;
                end

                BLE:begin
                    STATE = ST_beq;
                    COUNTER = COUNTER + 1;
                end

                BGT:begin
                    STATE = ST_beq;
                    COUNTER = COUNTER + 1;
                end

                ADDM:begin
                    STATE = ST_addm;
                    COUNTER = 7'b0000000;
                end

                LB:begin
                   STATE = ST_load_adress;
                   COUNTER = 7'b0000000; 
                end

                LH:begin
                    STATE = ST_load_adress;
                    COUNTER = 7'b0000000;
                end

                LUI:begin
                    STATE = ST_lui;
                    COUNTER = 7'b0000000;
                end

                LW:begin
                    STATE = ST_load_adress;
                    COUNTER = 7'b0000000;
                end

                SB:begin
                    STATE = ST_load_adress;
                    COUNTER = 7'b0000000;
                end

                SH:begin
                    STATE = ST_load_adress;
                    COUNTER = 7'b0000000;
                end

                SLTI:begin
                    STATE = ST_SLTI;
                    COUNTER = COUNTER + 1;
                end

                SW:begin
                    STATE = ST_load_adress;
                    COUNTER = 7'b0000000;
                end

                // J instructions
                J:begin
                    STATE = ST_jump;
                    COUNTER = 7'b0000000;
                end

                JAL:begin
                    STATE = ST_jal;
                    COUNTER = 7'b0000000;           
                end

                // NO OPCODE EXCEPTION
                default:begin
                    STATE = ST_noopcode;
                    COUNTER = 7'b0000000; 
                end
            endcase
        end
        endcase
    end
end
endmodule
