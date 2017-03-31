<<<<<<< HEAD
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity mux4to1 is port( 
			Sel : in  std_logic_vector (1 downto 0);     
			in0 : in  std_logic_vector (7 downto 0);     
            in1 : in  std_logic_vector (7 downto 0);
		    in2 : in  std_logic_vector (7 downto 0);
		    in3 : in  std_logic_vector (7 downto 0);
		    out0 : out std_logic_vector (7 downto 0)
);		   
end mux4to1;

architecture behavioral of mux4to1 is
begin
	with Sel select
		X <= in0 when "00",
			in1 when "01",
			in2 when "10",
			in3 when "11",
			'0'  when others;
end behavioral;
=======
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity mux4to1 is port( 
			Sel : in  std_logic_vector (1 downto 0);     
			in0 : in  std_logic_vector (7 downto 0);     
            in1 : in  std_logic_vector (7 downto 0);
		    in2 : in  std_logic_vector (7 downto 0);
		    in3 : in  std_logic_vector (7 downto 0);
		    out0 : out std_logic_vector (7 downto 0)
);		   
end mux4to1;

architecture behavioral of mux4to1 is
begin
	with Sel select
		X <= in0 when "00",
			in1 when "01",
			in2 when "10",
			in3 when "11",
			'0'  when others;
end behavioral;
>>>>>>> 7ae28f3e1e324121b9ef80808201ef0e0864ed19
