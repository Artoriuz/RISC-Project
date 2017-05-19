library verilog;
use verilog.vl_types.all;
entity memtest is
    port(
        clk             : in     vl_logic;
        operation       : in     vl_logic_vector(1 downto 0);
        clear           : in     vl_logic;
        out0            : out    vl_logic_vector(7 downto 0)
    );
end memtest;
