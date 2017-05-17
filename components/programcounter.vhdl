library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity programcounter is
    Port( 
			clk : in std_logic;
			in0 : in std_logic_vector (7 downto 0);
			operation : in std_logic_vector (1 downto 0);
			clear : in std_logic;
			out0 : out std_logic_vector (7 downto 0)
        );
end programcounter;

architecture Behavioral of programcounter is
	signal current: std_logic_vector (7 downto 0); --:= "00000000";
begin
	process (clk, operation, clear, current)
	begin
		if (clear = '1') then 
			current <= "00000000";
		elsif rising_edge(clk) then
			case operation is
				when "00" => -- Nao faz nada
					current <= current;
				when "01" => -- Incremento 
					current <= std_logic_vector(unsigned(current) + 2);
				when "10" => -- Seta de um valor externo
					current <= in0;
				when "11" => -- Reset
					current <= std_logic_vector(unsigned(current) + 1);
			end case;
		end if;
	out0 <= current;
	end process;
end Behavioral;
--mandar operation "01" quando quiser incrememtar, sempre que chegar num estado final por exemplo 
