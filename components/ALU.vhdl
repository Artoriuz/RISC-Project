library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
port(   CLK : in std_logic; 
        IN0 : in signed(7 downto 0);
		IN1 : in signed(7 downto 0);	
        SEl : in unsigned(3 downto 0); 
        OUT0 : out signed(7 downto 0);  
        CARRY : out signed;
		FLAG : out signed
		);
end alu;

architecture Behavioral of alu is


signal Reg1,Reg2,Reg3,Si : signed(7 downto 0) := (others => '0');
signal Temp : signed(8 downto 0);

begin

Reg1 <= IN0;
Reg2 <= IN1;
OUT0 <= Reg3;

process(CLK)
begin

    if(rising_edge(CLK)) then --Somente faz os seguintes passos na subida positiva do clock
        case SEL is
            when "0000" => 
                Temp <= Reg1 + Reg2;
				Reg3 <= Temp(7 downto 0);
				Si(0) <= Temp(8);
				Si(7 downto 1) = '0';
			when "0001" => 
				if (Reg1 >= Reg2) then
					Reg3 <= std_logic_vector(unsigned(Reg1) - unsigned(Reg2));
					FLAG <= '0';
				else
					Reg3 <= std_logic_vector(unsigned(Reg2) - unsigned(Reg1));
					FLAG <= '1';
				end if;
			when "0010" => 
                Reg3 <= not Reg1;  --NOT gate
            when "0011" => 
                Reg3 <= Reg1 nand Reg2; --NAND gate 
            when "0100" => 
                Reg3 <= Reg1 nor Reg2; --NOR gate               
            when "0101" => 
                Reg3 <= Reg1 and Reg2;  --AND gate
            when "0110" => 
                Reg3 <= Reg1 or Reg2;  --OR gate    
            when "0111" => 
                Reg3 <= Reg1 xor Reg2; --XOR gate   
            when others =>
                NULL;
        end case;       
    end if;
    
end process;    

end Behavioral;
