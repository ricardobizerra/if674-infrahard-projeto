`timescale 1ns/1ps
`include "sign_extend16to32.v"

module sign_extend16to32_tb();
    
    reg [15:0] in_TB;
    wire [31:0] out_TB;

    sign_extend16to32 DUT(.in(in_TB), .out(out_TB));

    initial
		begin
		
			$dumpfile("sign_extend16to32_tb.vcd");
			$dumpvars(0,sign_extend16to32_tb);
		
			in_TB=1010110101101010; 
            #10 in_TB=0010110101101010;
			#15 in_TB=1110110101101010;
            #20 in_TB=1110110111101010;

            #100 $finish;
		end
endmodule

// instruções para geração de ondas: 
// iverilog -o (file name)_tb.vvp (file name)_tb.v 
// vvp (file name)_tb.vvp
// gtkwave (file name)_tb.vcd (opcional pois pode-se usar a extensão)