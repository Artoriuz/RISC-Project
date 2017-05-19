library verilog;
use verilog.vl_types.all;
entity microprocessador is
    port(
        clk             : in     vl_logic;
        execute         : in     vl_logic;
        reset           : in     vl_logic;
        externaldata    : in     vl_logic_vector(7 downto 0);
        finished        : out    vl_logic;
        saida           : out    vl_logic_vector(7 downto 0);
        carryflag       : out    vl_logic
    );
end microprocessador;
