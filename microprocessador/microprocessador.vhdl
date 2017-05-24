library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.ALL;

entity microprocessador is 
	port(
		clk, execute, reset : in std_logic;
		externaldata : in std_logic_vector(7 downto 0);
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
signal regload_proc : std_logic_vector(7 downto 0);
signal datamem_write_enable_proc : std_logic;
signal pcounter_control_proc : std_logic_vector(1 downto 0);
signal externaldata_proc : std_logic_vector (7 downto 0);
signal zero_sign_proc : std_logic;
signal prev_instruction : std_logic_vector(7 downto 0);
signal clk_dp_proc : std_logic;

begin
controlador0 : controlador port map (clk_dp_proc, not reset, execute, instruction_proc, finished, mux0select_proc, mux1select_proc, mux2select_proc, regload_proc, alucontrol_proc, datamem_write_enable_proc, pcounter_control_proc, zero_sign_proc, prev_instruction);
datapath0 : datapath port map (clk, instruction_proc, saida, carryflag, mux0select_proc, mux1select_proc, mux2select_proc, regload_proc, not reset, alucontrol_proc, datamem_write_enable_proc, pcounter_control_proc, externaldata_proc, zero_sign_proc, prev_instruction, clk_dp_proc);

end architecture Behavioral;