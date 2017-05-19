library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity memtest is
    Port( 
			clk : in std_logic;
			operation : in std_logic_vector (1 downto 0);
			clear : in std_logic;
			out0 : out std_logic_vector (7 downto 0)
        );
end memtest;

architecture Behavioral of memtest is 
signal address : std_logic_vector(7 downto 0);

begin 

contador0 : programcounter port map (clk, "00000000", operation, clear, address);
progmem0 : progmem port map (address, clk, "00000000", '0', out0);

end architecture Behavioral;