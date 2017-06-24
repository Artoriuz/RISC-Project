library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.ALL;

entity datapath is 
	port(
		clk : in std_logic;
		instructionout : out std_logic_vector(7 downto 0);
		saida : out std_logic_vector(7 downto 0);
		carryflag : out std_logic;
		mux0select : in std_logic_vector(2 downto 0); 
		mux1select, mux2select : in std_logic_vector(1 downto 0);
		regload : in std_logic_vector(7 downto 0); -- ordem = Reg00 Reg01 Reg10 Reg11 Regin Regout Regcarryflag RegZero
		reset: in std_logic;
		alucontrol : in std_logic_vector(3 downto 0);
		datamem_write_enable : in std_logic;
		pcounter_control: in std_logic_vector (1 downto 0);
		externaldata : in std_logic_vector(7 downto 0);
		zero_sign_out : out std_logic;
		previous_instruction : out std_logic_vector(7 downto 0);
		clk_out : out std_logic
	);
end entity datapath;
		
architecture Behavioral of datapath is 

signal mux0out, mux1out, mux2out, reg00out, reg01out, reg10out, reg11out, reginout, aluout : std_logic_vector (7 downto 0);
signal alucarryflag, zero_sign_dp : std_logic;
signal progmemaddress : std_logic_vector(7 downto 0);
signal progmem_out : std_logic_vector(7 downto 0);
signal internaldata : std_logic_vector(7 downto 0);
signal clk_low : std_logic;

begin
--divisor de clock
clk0 : clk10Hz port map (clk, reset, clk_low);

--contador de programa
programcounter0 : programcounter port map (clk_low, progmem_out, pcounter_control, reset, progmemaddress);

--memórias de programa e de dados
progmem0 : progmem port map (progmemaddress, clk_low, "00000000", '0', progmem_out);
datamem0 : datamem port map (mux2out(4 downto 0), clk_low, mux1out, datamem_write_enable, internaldata);

--registradores internos do register file
reg00 : register8 port map (mux0out, regload(7), clk_low, reset, reg00out);
reg01 : register8 port map (mux0out, regload(6), clk_low, reset, reg01out);
reg10 : register8 port map (mux0out, regload(5), clk_low, reset, reg10out);
reg11 : register8 port map (mux0out, regload(4), clk_low, reset, reg11out);

--registradores de entrada e saída, e registrador dos últimos 8 bits de intrução (esse vai para o controlador)
regin : register8 port map (externaldata, regload(3), clk_low, reset, reginout); 
reout : register8 port map (mux1out, regload(2), clk_low, reset, saida);
reg_prev_isnt : register8 port map (progmem_out, '1', clk_low, reset, previous_instruction);

--registrador de carry/flag e registrador sinalizador de zero
regcarryflag : register1 port map (alucarryflag, regload(1), clk_low, reset, carryflag); 
regzero : register1 port map (zero_sign_dp, regload(0), clk_low, reset, zero_sign_out);

--multiplexadores
mux0 : mux5to1 port map (mux0select, aluout, mux1out, progmem_out, internaldata, reginout, mux0out);
mux1 : mux4to1 port map (mux1select, reg00out, reg01out, reg10out, reg11out, mux1out);
mux2 : mux4to1 port map (mux2select, reg00out, reg01out, reg10out, reg11out, mux2out);

--unidade lógica aritmética
ALU0 : ALU port map (mux1out, mux2out, alucontrol, alucarryflag, aluout, zero_sign_dp);

--saídas restantes
instructionout <= progmem_out;
clk_out <= clk_low;
end architecture Behavioral;