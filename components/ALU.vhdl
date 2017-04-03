library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity ALU is
	port(
		in0 : in std_logic_vector(7 downto 0); 
		in1 : in std_logic_vector(7 downto 0);
		operation : in std_logic_vector(7 downto 0);
		carry : out std_logic;
		flag : out std_logic; --Podemos usar uma coisa só para as duas linhas em cima disso
		result : out std_logic_vector(7 downto 0)
	);
end entity ALU;
 
architecture Behavioral of ALU is

signal temp : std_logic_vector(8 downto 0);

begin
	process(in0, in1, operation, temp) is
	begin
		flag <= '0';
		case operation is
		when "0000" => -- result = in0 + in1, flag = carry = Overflow
			temp <= std_logic_vector((unsigned("0" & in0) + unsigned(in1)));
			result <= temp(7 downto 0);
			carry <= temp(8);
		when "0001" => -- result = |in0 - in1|, flag = 1 if in1 > in0
			if (in0 >= in1) then
				result <= std_logic_vector(unsigned(in0) - unsigned(in1));
				flag <= '0';
			else
				result <= std_logic_vector(unsigned(in1) - unsigned(in0));
				flag <= '1';
            end if;
		when "0010" => -- and port
			result <= in0 and in1;
		when "0011" => -- or port 
			result <= in0 or in1;
		when "0100" => -- xor port 
			result <= in0 xor in1;
		when "0101" => -- not port primeira entrada
			result <= not in0;
		when "0110" => -- shift right
			temp(8) <= '0';
			temp(7 downto 0) <= in0;
			result(7 downto 0) <= temp(8 downto 1);
		when "0111" => --shift left
			temp(0) <= '0';
			temp(8 downto 1) <= in0;
			result(7 downto 0) <= temp(7 downto 0);
		when others => 
			temp (8 downto 0) <= '0';
			result <= temp (7 downto 0);
			flag <= '0'; --provavelmente não preciso disso e nem da linha de baixo dessa 
			carry <= '0';
		end case;
	end process;
end architecture Behavioral;
--Devemos ainda mudar a codificação dentro do ALU para a mesma ficar igual á codificação as instruções, o que é mais fácil para o controlador. Mas isso não importa.