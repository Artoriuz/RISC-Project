LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY register8 IS PORT(
    IN0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    LD : IN STD_LOGIC; 
    CLR : IN STD_LOGIC;
    CLK : IN STD_LOGIC;
    OUT0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END register8;

ARCHITECTURE description OF register8 IS

BEGIN
    process(CLK, CLR)
    begin
        if CLR = '1' then
            OUT0 <= x"00000000";
        elsif rising_edge(CLK) then
            if LD = '1' then
                OUT0 <= IN0;
            end if;
        end if;
    end process;
END description;
