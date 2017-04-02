LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_bit.all;

entity ram is 
	port(
		in0 : in std_logic_vector(7 downto 0);
		clk : in std_logic;
		address : in std_logic_vector(7 downto 0);
		out0 : out std_logic_vector(7 downto 0)
	);
	--This is completely incomplete. 