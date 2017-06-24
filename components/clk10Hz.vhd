library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clk10Hz is
	Port (
		clk_in : in  std_logic;
		reset  : in  std_logic;
		clk_out: out std_logic
	);
end clk10Hz;

architecture Behavioral of clk10Hz is
signal temporal : std_logic;
--signal counter : integer range 0 to 2699999 := 0; --valor pra ser usado na placa pra um clock resultante de 10hz
signal counter : integer range 0 to 1 := 0; --valor pra simulacao
begin
	freq_div: process (reset, clk_in) 
	begin
		if (reset = '1') then
			temporal <= '0';
			counter <= 0;
		elsif rising_edge(clk_in) then
			--if (counter = 2699999) then --valor pra ser usado na placa pra um clock resultante de 10hz
	      if (counter = 1) then --valor pra simulacao
				temporal <= NOT(temporal);
				counter <= 0;
			else
				counter <= counter + 1;
				temporal <= temporal;
			end if;
		end if;
	end process;
clk_out <= temporal;
end Behavioral;