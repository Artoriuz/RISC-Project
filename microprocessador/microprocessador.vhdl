library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity microprocessador is 
	port(
		clk, execute, reset : in std_logic;
		instruction, address : in std_logic_vector(7 downto 0);
		finished : out std_logic;
		saida : out std_logic_vector(7 downto 0)
	);
end entity microprocessador;
		
architecture Behavioral of microprocessador is 

component datapath is 
	port(
		clk : in std_logic;
		instruction, address : in std_logic_vector(7 downto 0);
		instructionout : out std_logic_vector(7 downto 0);
		saida : out std_logic_vector(7 downto 0);
		mux0select : in std_logic_vector(2 downto 0); 
		mux1select, mux2select : in std_logic_vector(1 downto 0);
		regload : in std_logic_vector(6 downto 0); -- ordem = Reg00 Reg01 Reg10 Reg11 Regout Regout Regcarryflag
		regclear : in std_logic_vector(6 downto 0); -- ordem = Reg00 Reg01 Reg10 Reg11 Regout Regout Regcarryflag
		alucontrol : in std_logic_vector(3 downto 0)
	);
end component;

component controlador is 
	port(
		clk, reset, execute : in std_logic;
		instruction : in std_logic_vector(7 downto 0);
		finished : out std_logic; 
		mux0select : out std_logic_vector(2 downto 0); 
		mux1select, mux2select : out std_logic_vector(1 downto 0);
		regload : out std_logic_vector(6 downto 0); -- ordem = Reg00 Reg01 Reg10 Reg11 Regin Regout Regcarryflag
		regclear : out std_logic_vector(6 downto 0); -- ordem = Reg00 Reg01 Reg10 Reg11 Regin Regout Regcarryflag
		alucontrol : out std_logic_vector(3 downto 0)
	);
end component;

signal instruction_proc : std_logic_vector(7 downto 0);
signal mux0select_proc : std_logic_vector(2 downto 0);
signal mux1select_proc, mux2select_proc : std_logic_vector(1 downto 0);
signal alucontrol_proc : std_logic_vector(3 downto 0);
signal regload_proc, regclear_proc : std_logic_vector(6 downto 0);

begin
controlador0 : controlador port map (clk, reset, execute, instruction_proc, finished, mux0select_proc, mux1select_proc, mux2select_proc, regload_proc, regclear_proc, alucontrol_proc);
datapath0 : datapath port map (clk, instruction, address, instruction_proc, saida, mux0select_proc, mux1select_proc, mux2select_proc, regload_proc, regclear_proc, alucontrol_proc);

end architecture Behavioral;