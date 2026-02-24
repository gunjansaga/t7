module tb;

logic clk=0,rst;
logic [5:0] sec,min;

digital_clock dut(.*);

always #5 clk=!clk;

// Transition bins → KEY for Cadence coverage
covergroup clk_cg @(posedge clk);
    sec_cp : coverpoint sec {
        bins rollover = (59 => 0);
    }
endgroup

clk_cg cg=new();

initial begin
    $shm_open("waves.shm");
    $shm_probe("AS");

    rst=1;
    repeat(2) @(posedge clk);
    rst=0;

    repeat(130) begin
        @(posedge clk);
        cg.sample();
    end

    $display("Coverage=%0.2f%%",cg.get_inst_coverage());
    $finish;
end

endmodule
