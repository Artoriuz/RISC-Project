library verilog;
use verilog.vl_types.all;
entity memtest_vlg_sample_tst is
    port(
        clear           : in     vl_logic;
        clk             : in     vl_logic;
        operation       : in     vl_logic_vector(1 downto 0);
        sampler_tx      : out    vl_logic
    );
end memtest_vlg_sample_tst;
