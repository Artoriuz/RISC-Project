LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity programcounter is 
    port(
        In0 : in std_logic_vector (7 downto 0); --Essa vai sair da memória e entrar no contador
        In1 : in std_logic_vector (7 downto 0); --Essa vai sair do contador e entrar nele mesmo (lógica do slideshow)
        Clk : in std_logic; --Clock
        Control : in std_logic; --Chega pelo controlador
        Out0 : in std_logic_vector (7 downto 0) --Essa volta pra ele mesmo por algum motivo
    );
end entity programcounter;

architecture Behavioral of programcounter is
    signal Temp: std_logic_vector(2047 downto 0);
    begin
    Temp (2047 downto 0) <= '0';
    if rising_edge(Clk) && Control = '1' then
        Temp <= Temp + '1';
    else
        Temp <= Temp;
    end if;
end Behavioral;



