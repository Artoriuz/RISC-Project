library verilog;
use verilog.vl_types.all;
entity microprocessador_vlg_sample_tst is
    port(
        address         : in     vl_logic_vector(7 downto 0);
        clk             : in     vl_logic;
        execute         : in     vl_logic;
        instruction     : in     vl_logic_vector(7 downto 0);
        reset           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end microprocessador_vlg_sample_tst;
