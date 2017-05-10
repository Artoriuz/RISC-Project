library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.ALL;

entity microprocessador is 
	port(
		clk, execute, reset : in std_logic;
		instruction, address : in std_logic_vector(7 downto 0);
		finished : out std_logic;
		saida : out std_logic_vector(7 downto 0);
		carryflag : out std_logic
	);
end entity microprocessador;
		
architecture Behavioral of microprocessador is 

signal instruction_proc : std_logic_vector(7 downto 0);
signal mux0select_proc : std_logic_vector(2 downto 0);
signal mux1select_proc, mux2select_proc : std_logic_vector(1 downto 0);
signal alucontrol_proc : std_logic_vector(3 downto 0);
signal regload_proc : std_logic_vector(6 downto 0);

begin
--Para usar na placa na primeira etada, lembrar de trocar "reset" por "not reset", e "clk" para "not clk".
controlador0 : controlador port map (clk, reset, execute, instruction_proc, finished, mux0select_proc, mux1select_proc, mux2select_proc, regload_proc, alucontrol_proc);
datapath0 : datapath port map (clk, instruction, address, instruction_proc, saida, carryflag, mux0select_proc, mux1select_proc, mux2select_proc, regload_proc, reset, alucontrol_proc);

end architecture Behavioral;