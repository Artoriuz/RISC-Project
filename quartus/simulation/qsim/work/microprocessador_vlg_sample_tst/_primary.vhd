library verilog;
use verilog.vl_types.all;
entity microprocessador_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        execute         : in     vl_logic;
        externaldata    : in     vl_logic_vector(7 downto 0);
        reset           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end microprocessador_vlg_sample_tst;
