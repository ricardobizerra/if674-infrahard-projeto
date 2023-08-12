module sign_extend8to32_mem(
    input wire [7:0]in,
    output wire [31:0]out
);

    assign out = {{24{in[7]}},in};

endmodule