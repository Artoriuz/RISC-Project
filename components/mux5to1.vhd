LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity mux5to1 is 
	port( 
		operation : in  std_logic_vector(2 downto 0);     
		in0, in1, in2, in3, in4 : in  std_logic_vector(7 downto 0);     
		out0 : out std_logic_vector(7 downto 0)
	);		   
end mux5to1;

architecture behavioral of mux5to1 is
begin
	with operation select
		out0 <= 
			in0 when "000",
			in1 when "001",
			in2 when "010",
			in3 when "011",
			in4 when "100",
			in0 when others;	
end behavioral;
