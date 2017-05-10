library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity controlador is
	port(
		clk, reset, execute : in std_logic;
		instruction : in std_logic_vector(7 downto 0);
		finished : out std_logic; 
		mux0select : out std_logic_vector(2 downto 0); 
		mux1select, mux2select : out std_logic_vector(1 downto 0);
		regload : out std_logic_vector(6 downto 0); -- ordem = Reg00 Reg01 Reg10 Reg11 Regin Regout Regcarryflag
		alucontrol : out std_logic_vector(3 downto 0)
	);
end entity controlador;

architecture Behavioral of controlador is
	type state_type is (start, busca, decode, MOV, MVI, ADD, SUB, instIN, instOUT);
	signal state, next_state : state_type;
	begin
		sincronia : process (clk)
			begin
			if (reset = '1') then 
				state <= start;
			elsif rising_edge(clk) then
				state <= next_state;
			end if;
	end process;

	proximo_estado : process (state, instruction, execute)
	begin
		next_state <= start;
		case (state) is
			when start =>
				next_state <= busca;
			when busca =>
				if (execute = '1') then
					next_state <= decode;
				else
					next_state <= busca;
				end if;
			when decode =>
				case (instruction (7 downto 4)) is
					when "0010" =>
						next_state <= MOV;
					when "0011" =>
						next_state <= MVI;
					when "0100" =>
						next_state <= ADD;
					when "0101" =>
						next_state <= SUB;
					when "1100" =>
						next_state <= instIN;
					when "1101" =>
						next_state <= instOUT;
					when others =>
						next_state <= busca; --Volta para busca caso o usuÃ¡rio entre com uma instruÃ§Ã£o invÃ¡lida
				end case;
			when others =>
				next_state <= busca;
		end case;
	end process;

	sinais_de_controle : process (state, instruction)
	begin
		case (state) is
			when start =>
				regload <= "0000000";
				finished <= '0';
			when busca =>
				regload <= "0000000";	
				finished <= '0';
			when decode =>
				regload <= "0000000";
				finished <= '0';
			when MOV =>		
				finished <= '1';
				mux0select <= "001";
				mux1select <= instruction(1 downto 0);
				case (instruction(3 downto 2)) is 
					when "00" =>
						regload <= "1000000";
					when "01" =>
						regload <= "0100000";
					when "10" =>
						regload <= "0010000";
					when "11" =>
						regload <= "0001000";
				end case;
			when MVI =>
				finished <= '1';
				mux0select <= "010";
				case (instruction(3 downto 2)) is 
					when "00" =>
						regload <= "1000000";
					when "01" =>
						regload <= "0100000";
					when "10" =>
						regload <= "0010000";
					when "11" =>
						regload <= "0001000";
				end case;
			when ADD =>
				finished <= '1';
				mux0select <= "000";
				alucontrol <= "0000";
				case (instruction(3 downto 0)) is 
					when "0000" =>
						regload <= "1000001"; --Load em Reg00 e Rcarryflag
						mux1select <= "00";
						mux2select <= "00";
					when "0001" =>
						regload <= "1000001"; --Load em Reg00 e Rcarryflag
						mux1select <= "00";
						mux2select <= "01";
					when "0010" =>
						regload <= "1000001"; --Load em Reg00 e Rcarryflag
						mux1select <= "00";
						mux2select <= "10";
					when "0011" =>
						regload <= "1000001"; --Load em Reg00 e Rcarryflag
						mux1select <= "00";
						mux2select <= "11";
					when "0100" =>
						regload <= "0100001"; --Load em Reg00 e Rcarryflag
						mux1select <= "10";
						mux2select <= "00";
					when "0101" =>
						regload <= "0100001"; --Load em Reg01 e Rcarryflag
						mux1select <= "01";
						mux2select <= "01";
					when "0110" =>
						regload <= "0100001"; --Load em Reg01 e Rcarryflag
						mux1select <= "01";
						mux2select <= "10";
					when "0111" =>
						regload <= "0100001"; --Load em Reg01 e Rcarryflag
						mux1select <= "01";
						mux2select <= "11";
					when "1000" =>
						regload <= "0010001"; --Load em Reg10 e Rcarryflag
						mux1select <= "10";
						mux2select <= "00";
					when "1001" =>
						regload <= "0010001"; --Load em Reg10 e Rcarryflag
						mux1select <= "10";
						mux2select <= "01";
					when "1010" =>
						regload <= "0010001"; --Load em Reg10 e Rcarryflag
						mux1select <= "10";
						mux2select <= "10";
					when "1011" =>
						regload <= "0010001"; --Load em Reg10 e Rcarryflag
						mux1select <= "10";
						mux2select <= "11";
					when "1100" =>
						regload <= "0001001"; --Load em Reg11 e Rcarryflag
						mux1select <= "11";
						mux2select <= "00";
					when "1101" =>
						regload <= "0001001"; --Load em Reg11 e Rcarryflag
						mux1select <= "11";
						mux2select <= "01";
					when "1110" =>
						regload <= "0001001"; --Load em Reg11 e Rcarryflag
						mux1select <= "11";
						mux2select <= "10";
					when "1111" =>
						regload <= "0001001"; --Load em Reg11 e Rcarryflag
						mux1select <= "11";
						mux2select <= "11";
				end case;
			when SUB =>
				finished <= '1';
				mux0select <= "000";
				alucontrol <= "0001";
				case (instruction(3 downto 0)) is 
					when "0000" =>
						regload <= "1000001";
						mux1select <= "00";
						mux2select <= "00";
					when "0001" =>
						regload <= "1000001"; --Load em Reg00 e Rcarryflag
						mux1select <= "00";
						mux2select <= "01";
					when "0010" =>
						regload <= "1000001"; --Load em Reg00 e Rcarryflag
						mux1select <= "00";
						mux2select <= "10";
					when "0011" =>
						regload <= "1000001"; --Load em Reg00 e Rcarryflag
						mux1select <= "00";
						mux2select <= "11";
					when "0100" =>
						regload <= "0100001"; --Load em Reg00 e Rcarryflag
						mux1select <= "10";
						mux2select <= "00";
					when "0101" =>
						regload <= "0100001"; --Load em Reg01 e Rcarryflag
						mux1select <= "01";
						mux2select <= "01";
					when "0110" =>
						regload <= "0100001"; --Load em Reg01 e Rcarryflag
						mux1select <= "01";
						mux2select <= "10";
					when "0111" =>
						regload <= "0100001"; --Load em Reg01 e Rcarryflag
						mux1select <= "01";
						mux2select <= "11";
					when "1000" =>
						regload <= "0010001"; --Load em Reg10 e Rcarryflag
						mux1select <= "10";
						mux2select <= "00";
					when "1001" =>
						regload <= "0010001"; --Load em Reg10 e Rcarryflag
						mux1select <= "10";
						mux2select <= "01";
					when "1010" =>
						regload <= "0010001"; --Load em Reg10 e Rcarryflag
						mux1select <= "10";
						mux2select <= "10";
					when "1011" =>
						regload <= "0010001"; --Load em Reg10 e Rcarryflag
						mux1select <= "10";
						mux2select <= "11";
					when "1100" =>
						regload <= "0001001"; --Load em Reg11 e Rcarryflag
						mux1select <= "11";
						mux2select <= "00";
					when "1101" =>
						regload <= "0001001"; --Load em Reg11 e Rcarryflag
						mux1select <= "11";
						mux2select <= "01";
					when "1110" =>
						regload <= "0001001"; --Load em Reg11 e Rcarryflag
						mux1select <= "11";
						mux2select <= "10";
					when "1111" =>
						regload <= "0001001"; --Load em Reg11 e Rcarryflag
						mux1select <= "11";
						mux2select <= "11";
				end case;
			when instIN =>
				finished <= '1';
				mux0select <= "100";
				case (instruction(3 downto 2)) is 
					when "00" =>
						regload <= "1000000"; --Load em Reg00
					when "01" =>
						regload <= "0100000"; --Load em Reg01
					when "10" =>
						regload <= "0010000"; --Load em Reg10
					when "11" =>
						regload <= "0001000"; --Load em Reg11
				end case; 
			when instOUT =>
				finished <= '1';
				regload <= "0000010"; --Regout
				case (instruction(3 downto 2)) is 
					when "00" =>
						mux1select <= "00"; --Selecionando Reg00
					when "01" =>
						mux1select <= "01"; --Selecionando Reg01
					when "10" =>
						mux1select <= "10"; --Selecionando Reg10
					when "11" =>
						mux1select <= "11"; --Selecionando Reg11
				end case;
		end case;
	end process;	
end architecture Behavioral; 