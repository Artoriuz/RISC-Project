library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity ALU is
   port(
		Input0, Input1 : in std_logic_vector(7 downto 0);
		Operation : in std_logic_vector(7 downto 0);
		Carry : out std_logic;
		Flag : out std_logic; --Podemos usar uma coisa só para as duas linhas em cima disso
		Result : out std_logic_vector(7 downto 0)
   );
end entity ALU;
 
architecture Behavioral of ALU is

	signal Temp: std_logic_vector(8 downto 0);

begin
	process(Input0, Input1, Operation, temp) is
	begin
		Flag <= '0';
		case Operation is
		when "0000" => -- Result = Input0 + Input1, Flag = Carry = Overflow
			Temp <= std_logic_vector((unsigned("0" & Input0) + unsigned(Input1)));
			Result <= temp(6 downto 0);
			Carry <= temp(7);
		when "0001" => -- Result = |Input0 - Input1|, flag = 1 if Input1 > Input0
			if (Input0 >= Input1) then
				Result <= std_logic_vector(unsigned(Input0) - unsigned(Input1));
				Flag <= '0';
			else
				Result <= std_logic_vector(unsigned(Input1) - unsigned(Input0));
				Flag <= '1';
            end if;
		when "0010" =>
			Result <= Input0 and Input1;
		when "0011" =>
			Result <= Input0 or Input1;
		when "0100" =>
			Result <= Input0 xor Input1;
		when "0101" =>
			Result <= not Input0;
		when "0110" =>
            Result <= not Input1;
		when others => 
			--Temp <= std_logic_vector((unsigned("0" & Input0) + unsigned(not Input1)) + 1);
			--Result <= temp(3 downto 0);
			--Flag <= temp(4);
			Temp <= '000000000';
			Result <= Temp (3 downto 0);
			Flag <= '0';
		end case;
	end process;

end architecture Behavioral;
--Devemos ainda mudar a codificação dentro do ALU para a mesma ficar igual á codificação as instruções, o que é mais fácil para o controlador. Mas isso não importa.
