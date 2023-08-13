module multiplier(
    input wire clk,
    input wire reset,
    input wire mult_on,
    input wire [31:0] A,
    input wire [31:0] B,
    output wire [31:0] min,
    output wire [31:0] max
);

    reg signed [63:0] produto;
    reg [31:0] B_negativo;
    reg B_sig = 0; 
    integer contador;
    reg [2:0] state = 0; // State machine state
    wire mult_done;

    assign mult_done = (state == 3);

    always @(posedge clk or posedge reset) 
    begin
        if (reset == 1)
        begin
            produto = 64'b0;
            B_negativo = 32'b0;
            contador = 0;
            B_sig = 0;
            state = 0;
        end
        else
        begin
            case (state)
                0: begin // Idle state
                    if (mult_on)
                        state = 1;
                end
                1: begin // Multiplication state
                    B_negativo = (~B + 32'd1);
                    B_sig = 1'b0;
                    produto = 64'b0;
                    contador = 0;
                    state = 2;
                end
                2: begin // Main multiplication loop
                    if (contador < 32)
                    begin
                        if ({A[contador], B_sig} == 2'b10)
                            produto[63:32] = produto[63:32] + B_negativo;
                        else if ({A[contador], B_sig} == 2'b01)
                            produto[63:32] = produto[63:32] + B;

                        produto = produto >>> 1;
                        B_sig = A[contador];
                        contador = contador + 1;
                    end
                    else
                        state = 3;
                end
                3: begin // Finalization state
                    if (B == 32'h8000_0000)
                        produto = (~produto + 32'd1);
                    
                    state = 0; // Return to idle state
                end
                default: state = 0;
            endcase
        end
    end

    assign max = produto[63:32];
    assign min = produto[31:0];
    
endmodule
