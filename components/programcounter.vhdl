library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity programcounter is
    Port( 
		clk : in  std_logic;
        in0 : in  std_logic_vector (7 downto 0);
        operation : in  std_logic_vector (1 downto 0);
        out0 : out  std_logic_vector (7 downto 0)
        );
end programcounter;

architecture Behavioral of programcounter is
	signal current: std_logic_vector (7 downto 0) := X"00";
begin
	process (clk)
	begin
		if rising_edge(clk) then
			case operation is
				when "00" => -- Não faz nada
					current <= current;
				when "01" => -- Incremento 
					current <= std_logic_vector(unsigned(current) + 1);
				when "10" => -- Seta de um valor externo
					current <= in0;
				when "11" => -- Reset
					current <= X"00"; --X para mandar em hexadecimal 
			end case;
		end if;
	end process;
	out0 <= current;
end Behavioral;

