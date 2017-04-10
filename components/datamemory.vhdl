library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity datamemory is

port (
	in0 : in std_logic_vector(7 downto 0); -- 8 bit data
	address : in std_logic_vector(7 downto 0):= (others => '0'); -- 8 bit address
	clk : in  std_logic;
	clr : in std_logic;
	control : in std_logic; -- write enable
	out0 : out std_logic_vector(7 downto 0)
	);
end datamemory ;

architecture Behavioral of datamemory is
	type mem_type is array (31 downto 0) of std_logic_vector(7 downto 0);
	signal mem : mem_type;
	begin
	memory : process (control, address, clk, clr, mem, in0)
		begin
		if rising_edge(clk)	then
			if (clr = '1') then 
				mem (31 downto 0)(7 downto 0) <= (others => (others=>'0')); 
			else			
				if (control = '1') then
					mem(conv_integer(std_logic_vector(address))) <= in0; -- write
				end if;
				out0 <= mem(conv_integer(std_logic_vector(address))); -- read
			end if;
		end if;	
	end process memory;
end Behavioral;
-- Isso é literalmente a mesma coisa da RAM só que com 32x8 em vez de 256x8. 