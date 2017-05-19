library verilog;
use verilog.vl_types.all;
entity memtest_vlg_check_tst is
    port(
        out0            : in     vl_logic_vector(7 downto 0);
        sampler_rx      : in     vl_logic
    );
end memtest_vlg_check_tst;
