LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity register8 is port(
	in0 : in std_logic_vector(7 downto 0);
	ld : in std_logic; 
	clk : in std_logic;
	clr : in std_logic;
	out0 : out std_logic_vector(7 downto 0)
);
end register8;

architecture description of register8 is
begin
    process(clk, clr)
    begin
        if clr = '1' then
			out0 <= "00000000";
        elsif rising_edge(clk) then
            if ld = '1' then
			out0 <= in0;
            end if;
        end if;
    end process;
end description;
