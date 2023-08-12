module shift_jump(
    input wire[25:0] data_in,
    input wire[31:0] PC,
    output wire[31:0] data_out
);

    assign data_in_shift = data_in << 2;
    assign data_out = {PC[31:28], data_in_shift};
    
endmodule