
module mem_access_tb();
    reg               clk,
    reg               mem_read_exe_mem,
    reg               mem_write_exe_mem,
    reg               mem_to_reg_exe_mem,
    reg       [31:0]  alu_out_exe_mem,
    reg       [31:0]  w_data_exe_mem,
    reg       [4:0]   write_reg_exe_mem,
    wire      [31:0]  r_data_mem_wb,
    wire      [31:0]  reg_out_mem_wb,
    wire              mem_to_reg_mem_wb,
    wire      [4:0]   write_reg_mem_wb 

mem_access mem_access_inst
(
    .clk(clk),
    .mem_read_exe_mem(mem_read_exe_mem),
    .mem_write_exe_mem(mem_write_exe_mem),
    .mem_to_reg_exe_mem(mem_to_reg_exe_mem),
    .alu_out_exe_mem(alu_out_exe_mem),
    .w_data_exe_mem(w_data_exe_mem),
    .write_reg_exe_mem(write_reg_exe_mem),
    .r_data_mem_wb(r_data_mem_wb),
    .reg_out_mem_wb(reg_out_mem_wb),
    .mem_to_reg_mem_wb(mem_to_reg_mem_wb),
    .write_reg_mem_wb(write_reg_mem_wb) 
);

initial 
begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial
begin
    // Test case 1: Write and read back data
    mem_write_exe_mem = 1;
    mem_read_exe_mem = 0;
    mem_to_reg_exe_mem = 0;
    alu_out_exe_mem = 32'h00000010; // Address to write to
    w_data_exe_mem = 32'hDEADBEEF;   // Data to write
    write_reg_exe_mem = 5'd1;        // Register to write to
    #10;

    mem_write_exe_mem = 0;
    mem_read_exe_mem = 1;
    mem_to_reg_exe_mem = 1;
    alu_out_exe_mem = 32'h00000010; // Address to read from
    #10;

    // Check if the data read matches the data written
    if (r_data_mem_wb !== 32'hDEADBEEF) begin
        $display("Test case 1 failed: Expected DEADBEEF, got %h", r_data_mem_wb);
    end else begin
        $display("Test case 1 passed");
    end

    // Test case 2: Read from an address that hasn't been written to
    mem_write_exe_mem = 0;
    mem_read_exe_mem = 1;
    mem_to_reg_exe_mem = 1;
    alu_out_exe_mem = 32'h00000020; // Address to read from
    #10;

    // Check if the data read is zero (assuming memory initializes to zero)
    if (r_data_mem_wb !== 32'h00000000) begin
        $display("Test case 2 failed: Expected 00000000, got %h", r_data_mem_wb);
    end else begin
        $display("Test case 2 passed");
    end

    $finish;
end

endmodule