LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity register8 is port(
	In0 : in std_logic_vector(7 downto 0);
	Ld : in std_logic; 
	Clk : in std_logic;
	Clk : in std_logic;
	Out0 : out std_logic_vector(7 downto 0)
);
end register8;

architecture description of register8 is

begin
    process(Clk, Clr)
    begin
        if Clr = '1' then
			Out0 <= "00000000";
        elsif rising_edge(Clk) then
            if Ld = '1' then
				Out0 <= In0;
            end if;
        end if;
    end process;
<<<<<<< HEAD
end description;
=======
end description;
>>>>>>> 7ae28f3e1e324121b9ef80808201ef0e0864ed19
