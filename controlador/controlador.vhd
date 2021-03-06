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
		regload : out std_logic_vector(7 downto 0); --Ordem dos regs = Reg00 Reg01 Reg10 Reg11 Regin Regout Regcarryflag RegZero
		alucontrol : out std_logic_vector(3 downto 0);
		datamem_write_enable : out std_logic;
		pcounter_control: out std_logic_vector(1 downto 0);
		zero_sign_in : in std_logic;
		prev_instruction : in std_logic_vector(7 downto 0)
	);
end entity controlador;

architecture Behavioral of controlador is
	type state_type is (start, busca, busca_LD, busca_OUT, decode, MOV, MVI, ADD, SUB, instIN, instOUT, LD, ST, JMP, JZ, SHL, SHR, instAND, instOR, instNOT, instXOR);
	signal state, next_state : state_type;
	begin
		sincronia : process (clk, reset)
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
			when busca_LD =>
				if (execute = '1') then
					next_state <= decode;
				else
					next_state <= busca;
				end if;
			when busca_OUT =>
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
					when "1000" =>
						next_state <= instAND;
					when "1001" =>
						next_state <= instOR;
					when "1010" =>
						next_state <= instXOR;
					when "1011" =>
						next_state <= instNOT;			
					when "1100" =>
						next_state <= instIN;
					when "1101" =>
						next_state <= instOUT;
					when "1110" =>
						next_state <= JMP;
					when "1111" =>
						next_state <= JZ;
					when others =>
						next_state <= busca; --Volta para busca caso o usuário entre com uma instrução inválida
				end case;
			when LD =>
				next_state <= busca_LD;
			when instOUT =>
				next_state <= busca_OUT;
			when others =>
				next_state <= busca;
		end case;
	end process;

	sinais_de_controle : process (state, instruction, zero_sign_in, prev_instruction)
	begin
		case (state) is
			when start => --No start tudo é zerado. Volta pra start caso reset seja '1'.
				regload <= "00000000";
				finished <= '0';
				datamem_write_enable <= '0';
				pcounter_control <= "00";
			when busca =>
				finished <= '0';
				regload <= "00000000";
				if (execute = '1') then --Esse if existe pra não incrementar o endereço de memória de programa caso o execute esteja em '0';
					pcounter_control <= "01";
				else 
					pcounter_control <= "00";
				end if;
			when busca_LD => --Existe para que seja possível realizar a instrução LD sem alterar o estado "busca" original. O busca_LD mantêm o regload anterior.  
				finished <= '0';
				regload(3 downto 0) <= "0000";
				if (execute = '1') then
					pcounter_control <= "01";
				else 
					pcounter_control <= "00";
				end if;
			when busca_OUT => --Existe para que erros de timing não aconteçam. 
				finished <= '0';
				--regload <= "00000100"; --Usar isso caso existam problemas de timing na instrução OUT
				regload <= "00000000"; --Usar isso pra simulações de waveform, ou na placa quando não der problema de timning 
				if (execute = '1') then
					pcounter_control <= "01";
				else 
					pcounter_control <= "00";
				end if;
			when decode =>
				regload <= "00000000";
				finished <= '0';
				datamem_write_enable <= '0';
				pcounter_control <= "00";
			when LD => 
				finished <= '1'; 
 				pcounter_control <= "01";
				mux0select <= "011";
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
 				datamem_write_enable <= '1';
 				case (prev_instruction(3 downto 0)) is 
					when "0000" =>
						mux2select <= "00"; --Mux2select indica qual o endereco de mem de destino
						mux1select <= "00"; --Mux1select indica o valor que ira para esse endereco
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
			when instAND =>
				finished <= '1';
				mux0select <= "000";
				alucontrol <= "0010";
				pcounter_control <= "01";
				case (prev_instruction(3 downto 0)) is 
					when "0000" =>
						regload <= "10000000"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "00";
					when "0001" =>
						regload <= "10000000"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "01";
					when "0010" =>
						regload <= "10000000"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "10";
					when "0011" =>
						regload <= "10000000"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "11";
					when "0100" =>
						regload <= "01000000"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "00";
					when "0101" =>
						regload <= "01000000"; --Load em Reg01, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "01";
					when "0110" =>
						regload <= "01000000"; --Load em Reg01, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "10";
					when "0111" =>
						regload <= "01000000"; --Load em Reg01, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "11";
					when "1000" =>
						regload <= "00100000"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "00";
					when "1001" =>
						regload <= "00100000"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "01";
					when "1010" =>
						regload <= "00100000"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "10";
					when "1011" =>
						regload <= "00100000"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "11";
					when "1100" =>
						regload <= "00010000"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "00";
					when "1101" =>
						regload <= "00010000"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "01";
					when "1110" =>
						regload <= "00010000"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "10";
					when "1111" =>
						regload <= "00010000"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "11";
				end case;
			when instOR =>
				finished <= '1';
				mux0select <= "000";
				alucontrol <= "0011";
				pcounter_control <= "01";
				case (prev_instruction(3 downto 0)) is 
					when "0000" =>
						regload <= "10000000"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "00";
					when "0001" =>
						regload <= "10000000"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "01";
					when "0010" =>
						regload <= "10000000"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "10";
					when "0011" =>
						regload <= "10000000"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "11";
					when "0100" =>
						regload <= "01000000"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "00";
					when "0101" =>
						regload <= "01000000"; --Load em Reg01, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "01";
					when "0110" =>
						regload <= "01000000"; --Load em Reg01, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "10";
					when "0111" =>
						regload <= "01000000"; --Load em Reg01, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "11";
					when "1000" =>
						regload <= "00100000"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "00";
					when "1001" =>
						regload <= "00100000"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "01";
					when "1010" =>
						regload <= "00100000"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "10";
					when "1011" =>
						regload <= "00100000"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "11";
					when "1100" =>
						regload <= "00010000"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "00";
					when "1101" =>
						regload <= "00010000"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "01";
					when "1110" =>
						regload <= "00010000"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "10";
					when "1111" =>
						regload <= "00010000"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "11";
				end case;
			when instXOR =>
				finished <= '1';
				mux0select <= "000";
				alucontrol <= "0100";
				pcounter_control <= "01";
				case (prev_instruction(3 downto 0)) is 
					when "0000" =>
						regload <= "10000000"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "00";
					when "0001" =>
						regload <= "10000000"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "01";
					when "0010" =>
						regload <= "10000000"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "10";
					when "0011" =>
						regload <= "10000000"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "00";
						mux2select <= "11";
					when "0100" =>
						regload <= "01000000"; --Load em Reg00, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "00";
					when "0101" =>
						regload <= "01000000"; --Load em Reg01, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "01";
					when "0110" =>
						regload <= "01000000"; --Load em Reg01, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "10";
					when "0111" =>
						regload <= "01000000"; --Load em Reg01, Rcarryflag e Rzero
						mux1select <= "01";
						mux2select <= "11";
					when "1000" =>
						regload <= "00100000"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "00";
					when "1001" =>
						regload <= "00100000"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "01";
					when "1010" =>
						regload <= "00100000"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "10";
					when "1011" =>
						regload <= "00100000"; --Load em Reg10, Rcarryflag e Rzero
						mux1select <= "10";
						mux2select <= "11";
					when "1100" =>
						regload <= "00010000"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "00";
					when "1101" =>
						regload <= "00010000"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "01";
					when "1110" =>
						regload <= "00010000"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "10";
					when "1111" =>
						regload <= "00010000"; --Load em Reg11, Rcarryflag e Rzero
						mux1select <= "11";
						mux2select <= "11";
				end case;
			when instNOT =>
				finished <= '1';
				mux0select <= "000";
				alucontrol <= "0101";
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
			when instIN =>
				finished <= '1';
				mux0select <= "100";
				regload <= "00001000";
				pcounter_control <= "01";
			when instOUT =>
				finished <= '1';
				regload <= "00000100"; --load no Regout
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
				pcounter_control <= "10"; --Faz o contador de programa ir para o "address" 
			when JZ =>
				finished <= '1';
				regload <= "00000000";
				if (zero_sign_in = '1') then
					pcounter_control <= "10"; --Faz o contador de programa ir para o "address" 
				else 
					pcounter_control <= "01"; --Caso a ultima operação não tenha sido igual á '0', incrementa normalmente
				end if;
		end case;
	end process;	
end architecture Behavioral; 