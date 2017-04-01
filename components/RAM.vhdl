LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_bit.all;

entity ram is 
	port(
		address : in std_logic_vector(7 downto 0);
		clk : in std_logic;
		memwr : in std_logic;
		in0 : std_logic_vector(7 downto 0);
		