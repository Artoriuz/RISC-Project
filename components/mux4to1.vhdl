LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux4to1 IS PORT( 
			SEL : IN  STD_LOGIC_VECTOR (1 downto 0);     
			IN0 : IN  STD_LOGIC_VECTOR (7 downto 0);     
            IN1 : IN  STD_LOGIC_VECTOR (7 downto 0);
		    IN2 : IN  STD_LOGIC_VECTOR (7 downto 0);
		    IN3 : IN  STD_LOGIC_VECTOR (7 downto 0);
		    OUT0 : OUT STD_LOGIC_VECTOR (7 downto 0)
);		   
END mux4to1;

ARCHITECTURE behavioral OF mux4to1 is
BEGIN
	WITH SEL SELECT
		X <= IN0 WHEN "00",
			IN1 WHEN "01",
			IN2 WHEN "10",
			IN3 WHEN "11",
			'0'  WHEN OTHERS;
END behavioral;