entity programcounter is
    Port( 
		clk : in  STD_LOGIC;
        in0 : in  STD_LOGIC_VECTOR (7 downto 0);
        operation : in  STD_LOGIC_VECTOR (1 downto 0);
        out0 : out  STD_LOGIC_VECTOR (7 downto 0)
        );
end programcounter;

architecture Behavioral of programcounter is
	signal current: std_logic_vector (7 downto 0) := X"0000";
begin
	process (clk)
	begin
		if rising_edge(clk) then
			case operation is
				when "00" => -- N�o faz nada
					current <= current;
				when "01" => -- Incremento 
					current <= std_logic_vector(unsigned(current) + 1);
				when "10" => -- Seta de um valor externo
					current <= in0;
				when "11" => -- Reset
					current <= X"0000"; --X para mandar em hexadecimal 
			end case;
		end if;
	end process;
	out0 <= current;
end Behavioral;

