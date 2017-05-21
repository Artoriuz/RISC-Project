library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity controlador2 is
	port(
		clk, reset, execute : in std_logic;
		instruction : in std_logic_vector(7 downto 0);
		finished : out std_logic; 
		mux0select : out std_logic_vector(2 downto 0); 
		mux1select, mux2select : out std_logic_vector(1 downto 0);
		regload : out std_logic_vector(7 downto 0); -- ordem = Reg00 Reg01 Reg10 Reg11 Regin Regout Regcarryflag RegZero
		alucontrol : out std_logic_vector(3 downto 0);
		datamem_write_enable : out std_logic;
		pcounter_control: out std_logic_vector(1 downto 0);
		zero_sign_in : in std_logic;
		prev_instruction : in std_logic_vector(7 downto 0)
	);
end entity controlador2;

architecture Behavioral of controlador2 is
	type state_type is (start, busca, decode, MOV, MVI, ADD, SUB, instIN, instOUT, LD, ST, JMP, JZ, SHL, SHR);
	signal state, next_state, prev_state : state_type;
	begin
		sincronia : process (clk, reset)
			begin
			if (reset = '1') then 
				state <= start;
				prev_state <= start;
			elsif rising_edge(clk) then
				state <= next_state;
				prev_state <= state;
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
					when "0000" =>
						next_state <= LD;					
					when "0001" =>
						next_state <= ST;
					when "0010" =>
						next_state <= MOV;
					when "0011" =>
						next_state <= MVI;
					when "0100" =>
						next_state <= ADD;
					when "0101" =>
						next_state <= SUB;
					when "0110" =>
						next_state <= SHL;
					when "0111" =>
						next_state <= SHR;
					when "1100" =>
						next_state <= instIN;
					when "1101" =>
						next_state <= instOUT;
					when "1110" =>
						next_state <= JMP;
					when "1111" =>
						next_state <= JZ;
					when others =>
						next_state <= busca; --Volta para busca caso o usuario entre com uma instrucao invalida
				end case;
			when others =>
				next_state <= busca;
		end case;
	end process;

	sinais_de_controle : process (state, instruction, zero_sign_in, prev_instruction, prev_state)
	begin
		case (state) is
			when start =>
				regload <= "00000000";
				finished <= '0';
				datamem_write_enable <= '0';
				pcounter_control <= "00";
			when busca =>
				finished <= '0';
				pcounter_control <= "01";
				regload(3 downto 0) <= "0000";
				case (prev_state) is
					when LD =>
						regload(3 downto 0) <= "0000"; --para que seja possivel colocar um valor apos o LD em um reg interno 
						datamem_write_enable <= '0';
					when ST =>
						regload <= "00000000";
						datamem_write_enable <= '1';
					when others =>
						regload <= "00000000";
						datamem_write_enable <= '0';
					end case;	
			when decode =>
				regload <= "00000000";
				finished <= '0';
				datamem_write_enable <= '0';
				pcounter_control <= "00";
			when LD => --nao confundir com ST, essa instrucao aqui so carrega um valor de origem propria memoria de dados em um dos regs internos
				finished <= '1'; 
 				pcounter_control <= "01";
				mux0select <= "011";
				--MANDAR O VALOR EM RY (O QUE SAI DO MUX2) COMO ENDEREÇO EM DATAMEM
 				case (prev_instruction(3 downto 0)) is 
					when "0000" =>
						regload <= "10000000"; --Load em Reg00
						mux2select <= "00";
					when "0001" =>
						regload <= "10000000"; --Load em Reg00
						mux2select <= "01";
					when "0010" =>
						regload <= "10000000"; --Load em Reg00
						mux2select <= "10";
					when "0011" =>
						regload <= "10000000"; --Load em Reg00
						mux2select <= "11";
					when "0100" =>
						regload <= "01000000"; --Load em Reg00
						mux2select <= "00";
					when "0101" =>
						regload <= "01000000"; --Load em Reg01
						mux2select <= "01";
					when "0110" =>
						regload <= "01000000"; --Load em Reg01
						mux2select <= "10";
					when "0111" =>
						regload <= "01000000"; --Load em Reg01
						mux2select <= "11";
					when "1000" =>
						regload <= "00100000"; --Load em Reg10
						mux2select <= "00";
					when "1001" =>
						regload <= "00100000"; --Load em Reg10
						mux2select <= "01";
					when "1010" =>
						regload <= "00100000"; --Load em Reg10
						mux2select <= "10";
					when "1011" =>
						regload <= "00100000"; --Load em Reg10
						mux2select <= "11";
					when "1100" =>
						regload <= "00010000"; --Load em Reg11
						mux2select <= "00";
					when "1101" =>
						regload <= "00010000"; --Load em Reg11
						mux2select <= "01";
					when "1110" =>
						regload <= "00010000"; --Load em Reg11
						mux2select <= "10";
					when "1111" =>
						regload <= "00010000"; --Load em Reg11
						mux2select <= "11";
				end case;
			when ST =>
				regload <= "00000000";
				finished <= '1';
 				pcounter_control <= "01";
				--MANDAR A ENTRADA QUE DIZ EM QUAL POSICAO IREMOS ESCREVER O VALOR NA MEMORIA DE DADOS (Isso esta definido no switch case)
 				datamem_write_enable <= '1';
 				case (prev_instruction(3 downto 0)) is 
					when "0000" =>
						mux2select <= "00"; --mux2select indica qual o endereco de mem de destino
						mux1select <= "00"; --mux1select indica o valor que ira para esse endereco
					when "0001" =>
						mux2select <= "00";
						mux1select <= "01";
					when "0010" =>
						mux2select <= "00";
						mux1select <= "10";
					when "0011" =>
						mux2select <= "00";
						mux1select <= "11";
					when "0100" =>
						mux2select <= "01";
						mux1select <= "00";
					when "0101" =>
						mux2select <= "01";
						mux1select <= "01";
					when "0110" =>
						mux2select <= "01";
						mux1select <= "10";
					when "0111" =>
						mux2select <= "01";
						mux1select <= "11";
					when "1000" =>
						mux2select <= "10";
						mux1select <= "00";
					when "1001" =>
						mux2select <= "10";
						mux1select <= "01";
					when "1010" =>
						mux2select <= "10";
						mux1select <= "10";
					when "1011" =>
						mux2select <= "10";
						mux1select <= "11";
					when "1100" =>
						mux2select <= "11";
						mux1select <= "00";
					when "1101" =>
						mux2select <= "11";
						mux1select <= "01";
					when "1110" =>
						mux2select <= "11";
						mux1select <= "10";
					when "1111" =>
						mux2select <= "11";
						mux1select <= "11";
				end case;
			when MOV =>		
				finished <= '1';
				mux0select <= "001";
				mux1select <= prev_instruction(1 downto 0);
				pcounter_control <= "01";
				case (prev_instruction(3 downto 2)) is 
					when "00" =>
						regload <= "10000000"; --Load em Reg00
					when "01" =>
						regload <= "01000000"; --Load em Reg01
					when "10" =>
						regload <= "00100000"; --Load em Reg10
					when "11" =>
						regload <= "00010000"; --Load em Reg11
				end case;
			when MVI =>
				finished <= '1';
				mux0select <= "010";
				pcounter_control <= "01";
				case (prev_instruction(3 downto 2)) is 
					when "00" =>
						regload <= "10000000"; --Load em Reg00
					when "01" =>
						regload <= "01000000"; --Load em Reg01
					when "10" =>
						regload <= "00100000"; --Load em Reg10
					when "11" =>
						regload <= "00010000"; --Load em Reg11
				end case;
			when ADD =>
				finished <= '1';
				mux0select <= "000";
				alucontrol <= "0000";
				pcounter_control <= "01";
				case (prev_instruction(3 downto 0)) is 
					when "0000" =>
						regload <= "10000011"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "00";
					when "0001" =>
						regload <= "10000011"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "01";
					when "0010" =>
						regload <= "10000011"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "10";
					when "0011" =>
						regload <= "10000011"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "11";
					when "0100" =>
						regload <= "01000011"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "00";
					when "0101" =>
						regload <= "01000011"; --Load em Reg01, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "01";
					when "0110" =>
						regload <= "01000011"; --Load em Reg01, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "10";
					when "0111" =>
						regload <= "01000011"; --Load em Reg01, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "11";
					when "1000" =>
						regload <= "00100011"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "00";
					when "1001" =>
						regload <= "00100011"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "01";
					when "1010" =>
						regload <= "00100011"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "10";
					when "1011" =>
						regload <= "00100011"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "11";
					when "1100" =>
						regload <= "00010011"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "00";
					when "1101" =>
						regload <= "00010011"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "01";
					when "1110" =>
						regload <= "00010011"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "10";
					when "1111" =>
						regload <= "00010011"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "11";
				end case;
			when SUB =>
				finished <= '1';
				mux0select <= "000";
				alucontrol <= "0001";
				pcounter_control <= "01";
				case (prev_instruction(3 downto 0)) is 
					when "0000" =>
						regload <= "10000011"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "00";
					when "0001" =>
						regload <= "10000011"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "01";
					when "0010" =>
						regload <= "10000011"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "10";
					when "0011" =>
						regload <= "10000011"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "11";
					when "0100" =>
						regload <= "01000011"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "00";
					when "0101" =>
						regload <= "01000011"; --Load em Reg01, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "01";
					when "0110" =>
						regload <= "01000011"; --Load em Reg01, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "10";
					when "0111" =>
						regload <= "01000011"; --Load em Reg01, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "11";
					when "1000" =>
						regload <= "00100011"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "00";
					when "1001" =>
						regload <= "00100011"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "01";
					when "1010" =>
						regload <= "00100011"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "10";
					when "1011" =>
						regload <= "00100011"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "11";
					when "1100" =>
						regload <= "00010011"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "00";
					when "1101" =>
						regload <= "00010011"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "01";
					when "1110" =>
						regload <= "00010011"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "10";
					when "1111" =>
						regload <= "00010011"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "11";
				end case;
			when SHL =>
				finished <= '1';
				alucontrol <="1000";
				mux0select <= "000";
				pcounter_control <= "01";
				case (prev_instruction(3 downto 0)) is 
					when "0000" =>
						regload <= "10000000"; --Load em Reg00
						mux1select <= "00"; --Vai receber o shift
					when "0001" =>
						regload <= "10000000"; --Load em Reg00
						mux1select <= "01"; --Vai receber o shift
					when "0010" =>
						regload <= "10000000"; --Load em Reg00
						mux1select <= "10"; --Vai receber o shift
					when "0011" =>
						regload <= "10000000"; --Load em Reg00
						mux1select <= "11"; --Vai receber o shift
					when "0100" =>
						regload <= "01000000"; --Load em Reg00
						mux1select <= "00"; --Vai receber o shift
					when "0101" =>
						regload <= "01000000"; --Load em Reg01
						mux1select <= "01"; --Vai receber o shift
					when "0110" =>
						regload <= "01000000"; --Load em Reg01
						mux1select <= "10"; --Vai receber o shift
					when "0111" =>
						regload <= "01000000"; --Load em Reg01
						mux1select <= "11"; --Vai receber o shift
					when "1000" =>
						regload <= "00100000"; --Load em Reg10
						mux1select <= "00"; --Vai receber o shift
					when "1001" =>
						regload <= "00100000"; --Load em Reg10
						mux1select <= "01"; --Vai receber o shift
					when "1010" =>
						regload <= "00100000"; --Load em Reg10
						mux1select <= "10"; --Vai receber o shift
					when "1011" =>
						regload <= "00100000"; --Load em Reg10
						mux1select <= "11"; --Vai receber o shift
					when "1100" =>
						regload <= "00010000"; --Load em Reg11
						mux1select <= "00"; --Vai receber o shift
					when "1101" =>
						regload <= "00010000"; --Load em Reg11
						mux1select <= "01"; --Vai receber o shift
					when "1110" =>
						regload <= "00010000"; --Load em Reg11
						mux1select <= "10"; --Vai receber o shift
					when "1111" =>
						regload <= "00010000"; --Load em Reg11
						mux1select <= "11"; --Vai receber o shift
				end case;
			when SHR =>
				finished <= '1';
				alucontrol <="1001";
				mux0select <= "000";
				pcounter_control <= "01";
				case (prev_instruction(3 downto 0)) is 
					when "0000" =>
						regload <= "10000000"; --Load em Reg00
						mux1select <= "00"; --Vai receber o shift
					when "0001" =>
						regload <= "10000000"; --Load em Reg00
						mux1select <= "01"; --Vai receber o shift
					when "0010" =>
						regload <= "10000000"; --Load em Reg00
						mux1select <= "10"; --Vai receber o shift
					when "0011" =>
						regload <= "10000000"; --Load em Reg00
						mux1select <= "11"; --Vai receber o shift
					when "0100" =>
						regload <= "01000000"; --Load em Reg00
						mux1select <= "00"; --Vai receber o shift
					when "0101" =>
						regload <= "01000000"; --Load em Reg01
						mux1select <= "01"; --Vai receber o shift
					when "0110" =>
						regload <= "01000000"; --Load em Reg01
						mux1select <= "10"; --Vai receber o shift
					when "0111" =>
						regload <= "01000000"; --Load em Reg01
						mux1select <= "11"; --Vai receber o shift
					when "1000" =>
						regload <= "00100000"; --Load em Reg10
						mux1select <= "00"; --Vai receber o shift
					when "1001" =>
						regload <= "00100000"; --Load em Reg10
						mux1select <= "01"; --Vai receber o shift
					when "1010" =>
						regload <= "00100000"; --Load em Reg10
						mux1select <= "10"; --Vai receber o shift
					when "1011" =>
						regload <= "00100000"; --Load em Reg10
						mux1select <= "11"; --Vai receber o shift
					when "1100" =>
						regload <= "00010000"; --Load em Reg11
						mux1select <= "00"; --Vai receber o shift
					when "1101" =>
						regload <= "00010000"; --Load em Reg11
						mux1select <= "01"; --Vai receber o shift
					when "1110" =>
						regload <= "00010000"; --Load em Reg11
						mux1select <= "10"; --Vai receber o shift
					when "1111" =>
						regload <= "00010000"; --Load em Reg11
						mux1select <= "11"; --Vai receber o shift
				end case;
			when instIN =>
				finished <= '1';
				mux0select <= "100";
				regload <= "00001000";
				pcounter_control <= "01";
			when instOUT =>
				finished <= '1';
				regload <= "00000100"; --Regout
				pcounter_control <= "01";
				case (prev_instruction(3 downto 2)) is 
					when "00" =>
						mux1select <= "00"; --Selecionando Reg00
					when "01" =>
						mux1select <= "01"; --Selecionando Reg01
					when "10" => 
						mux1select <= "10"; --Selecionando Reg10
					when "11" =>
						mux1select <= "11"; --Selecionando Reg11
				end case;
			when JMP =>
				finished <= '1';
				regload <= "00000000";
				pcounter_control <= "10";
				--FORCAR O CONTADOR DE PROGRAMA A IR PARA O "ADDRESS"
			when JZ =>
				finished <= '1';
				regload <= "00000000";
				if (zero_sign_in = '1') then
					pcounter_control <= "10";
				else 
					pcounter_control <= "01";
				end if;
				--FORCAR O CONTADOR DE PROGRAMA A IR PARA O "ADDRESS" se o ultimo resultado for 0 (acho que se o regout tiver 0 nele)
		end case;
	end process;	
end architecture Behavioral; 