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
		regload : in std_logic_vector(6 downto 0); -- ordem = Reg00 Reg01 Reg10 Reg11 Regout Regout Regcarryflag
		reset: in std_logic;
		alucontrol : in std_logic_vector(3 downto 0);
		datamem_write_enable : in std_logic;
		pcounter_control: in std_logic_vector (1 downto 0);
		externaldata : in std_logic_vector(7 downto 0)
	);
end entity datapath;
		
architecture Behavioral of datapath is 

signal mux0out, mux1out, mux2out, reg00out, reg01out, reg10out, reg11out, reginout, aluout : std_logic_vector (7 downto 0);
signal alucarryflag : std_logic;
signal progmemaddress : std_logic_vector(7 downto 0);
--signal datamemaddress : std_logic_vector(4 downto 0);
signal fullinstruction : std_logic_vector(15 downto 0);
signal internaldata :std_logic_vector(7 downto 0);

begin
programcounter0 : programcounter port map (clk, fullinstruction(7 downto 0), pcounter_control, reset, progmemaddress);

progmem0 : progmem port map (progmemaddress, clk, "0000000000000000", '0', fullinstruction);
datamem0 : datamem port map (mux2out(4 downto 0), clk, mux1out, datamem_write_enable, internaldata);

reg00 : register8 port map (mux0out, regload(6), clk, reset, reg00out);
reg01 : register8 port map (mux0out, regload(5), clk, reset, reg01out);
reg10 : register8 port map (mux0out, regload(4), clk, reset, reg10out);
reg11 : register8 port map (mux0out, regload(3), clk, reset, reg11out);

regin : register8 port map (externaldata, regload(2), clk, reset, reginout); 
reout : register8 port map (mux1out, regload(1), clk, reset, saida);
regcarryflag : register1 port map (alucarryflag, regload(0), clk, reset, carryflag); 

mux0 : mux5to1 port map (mux0select, aluout, mux1out, fullinstruction(7 downto 0), internaldata, reginout, mux0out); --Como estou sem memoria eu repeti o fullinstruction(7 downto 0) 3 vezes
mux1 : mux4to1 port map (mux1select, reg00out, reg01out, reg10out, reg11out, mux1out);
mux2 : mux4to1 port map (mux2select, reg00out, reg01out, reg10out, reg11out, mux2out);

ALU0 : ALU port map (mux1out, mux2out, alucontrol, alucarryflag, aluout);

instructionout <= fullinstruction (15 downto 8);

end architecture Behavioral;