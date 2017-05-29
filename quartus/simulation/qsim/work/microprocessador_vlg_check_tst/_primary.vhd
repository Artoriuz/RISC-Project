library verilog;
use verilog.vl_types.all;
entity microprocessador_vlg_check_tst is
    port(
        carryflag       : in     vl_logic;
        finished        : in     vl_logic;
        saida           : in     vl_logic_vector(7 downto 0);
        zero_sign       : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end microprocessador_vlg_check_tst;
