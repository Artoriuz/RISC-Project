LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity register1 is 
    port(
	   in0 : in std_logic;
	   ld, clk, clr : in std_logic; 
	   out0 : out std_logic
    );
end register1;

architecture description of register1 is
begin
	process(clk, clr, ld)
		begin
			if clr = '1' then
				out0 <= '0';
			elsif rising_edge(clk) then
				if ld = '1' then
					out0 <= in0;
				end if;
			end if;
	end process;
end description;
