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

// Parameters

// Main States Parameters
    // initial states

    parameter ST_reset       = 7'd0;
    parameter ST_fetch0      = 7'd1;
    parameter ST_fetch1      = 7'd2;
    parameter ST_decode      = 7'd3;

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

    // I instructions

    parameter ST_addi        = 7'd12;


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
    reset_out = 1'b1;
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
        shift_src    = 2'b00;
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
                MEM_wr       = 1'b0;
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
                if (COUNTER == 7'b0000010) begin
                    STATE = ST_fetch1;
                end
                else begin
                    STATE = ST_fetch0;
                end
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
                COUNTER      = COUNTER + 1;
            end
            ST_decode:begin
                PC_write     = 1'b1;
                branch       = 1'b0;
                MEM_wr       = 1'b0;
                IR_write     = 1'b1;
                A_write      = 1'b1; ///
                B_write      = 1'b1; ///
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

            ST_add:begin
                STATE = ST_BREG_write;
                ALU_srcA = 2'b01;
                ALU_srcB = 3'b000;
                ALU_OP = 3'b001;
                ALUReg_write = 1'b1
                COUNTER = COUNTER + 1;
            end

            ST_and:begin
                STATE = ST_BREG_write;
                ALU_srcA = 2'b01;
                ALU_srcB = 3'b000;
                ALU_OP = 3'b010;
                ALUReg_write = 1'b1;
                COUNTER = COUNTER + 1;
            end

            ST_sub:begin
                STATE = ST_BREG_write;
                ALU_srcA = 2'b01;
                ALU_srcB = 3'b000;
                ALU_OP = 3'b011;
                ALUReg_write = 1'b1;
                COUNTER = COUNTER + 1;
            end

            ST_BREG_write:begin
                if (OV) begin
                    STATE = ST_overflow;
                    COUNTER = COUNTER + 1;
                end
                else begin
                    STATE = ST_fetch0;
                    REG_write = 1'b1;
                    reg_dst = 2'b01;
                    MEM_toreg = 4'b0000;
                    COUNTER = 7'b0000000;
                end
            end

            ST_BREG_write2:begin
                if(OV) begin
                    STATE = ST_overflow;
                    COUNTER = COUNTER + 1;
                end
                else begin
                    STATE = ST_fetch0;
                    REG_write = 1'b1;
                    MEM_toreg = 4'b0000;
                    reg_dst = 2'b00;
                end
            end

            ST_noopcode:begin
                except = 2'b00;
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
                if (COUNTER == 7'b0001000) begin
                    STATE = ST_except;
                end
                else begin
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

            default:begin
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
            end
        endcase
        // INSTRUCTIONS STATES
        if(COUNTER == 7'b0000011) begin
            case(OPCODE)
                // R instructions
                R_OPCODE:begin
                    case(FUNCT)
                        FUNCT_ADD:begin
                            STATE = ST_add;
                            COUNTER = COUNTER + 1;
                        end

                        FUNCT_AND:begin
                            STATE = ST_and;
                            COUNTER = COUNTER + 1;
                        end

                        FUNCT_DIV:begin

                        end

                        FUNCT_MULT:begin
                            
                        end

                        FUNCT_JR:begin

                        end

                        FUNCT_MFHI:begin
                            
                        end

                        FUNCT_MFLO:begin
                            
                        end

                        FUNCT_SLL:begin
                            
                        end

                        FUNCT_SLLV:begin
                            
                        end

                        FUNCT_SLT:begin
                            
                        end

                        FUNCT_SRA:begin
                            
                        end

                        FUNCT_SRAV:begin
                            
                        end

                        FUNCT_SRL:begin
                            
                        end

                        FUNCT_SUB:begin
                            STATE = ST_sub;
                            COUNTER = COUNTER + 1;
                        end

                        FUNCT_BREAK:begin
                            
                        end

                        FUNCT_RTE:begin
                            
                        end

                        FUNCT_DIVM:begin
                            
                        end
                    endcase 
                end
                // I instructions 
                ADDI:begin
                    STATE = ST_addi;
                    COUNTER = COUNTER + 1;
                end

                ADDIU:begin
                    
                end

                BEQ:begin
                    
                end

                BNE:begin
                    
                end

                BLE:begin
                    
                end

                BGT:begin
                    
                end

                ADDM:begin
                    
                end

                LB:begin
                    
                end

                LH:begin
                    
                end

                LUI:begin

                end

                LW:begin

                end

                SB:begin
                    
                end

                SH:begin
                    
                end

                SLTI:begin

                end

                SW:begin

                end

                // J instructions
                J:begin
                    
                end

                JAL:begin

                end
                // NO OPCODE EXCEPTION
                default:begin
                    STATE = ST_noopcode;
                end
            endcase
        end
    end
end
endmodule