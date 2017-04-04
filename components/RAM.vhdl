library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is

port (
	in0 : in std_logic_vector(7 downto 0); -- 8 bit data
	address : in std_logic_vector(7 downto 0):= (others => '0'); -- 8 bit address
	clk : in  std_logic;
	clr : in std_logic;
	control : in std_logic; -- write enable
	out0 : out std_logic_vector(7 downto 0)
	);
end ram ;

architecture Behavioral of ram is
	type mem_type is array (255 downto 0) of std_logic_vector(7 downto 0);
	signal mem : mem_type;
	begin
	memory : process (control, address, clk, clr, mem, in0)
		begin
		if rising_edge(clk)	then
			if (clr = '1') then 
				mem (255 downto 0) <= '0';
			else			
				if (control = '1') then
					mem(to_integer(address)) <= in0; -- write
				end if;
				out0 <= mem(to_integer(address)); -- read
			end if;
		end if;	
	end process memory;
end Behavioral;
--Eu acho que isso funciona, não tenho certeza sobre a parte do "mem(to_integer(address))", mas vai dar certo. 