LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY my_reg IS
	PORT( Clk,rst,en : IN std_logic;
		  d : IN  std_logic_vector(15 DOWNTO 0);
		  q : OUT std_logic_vector(15 DOWNTO 0));
END my_reg;

ARCHITECTURE a_my_reg OF my_reg IS
	BEGIN
		PROCESS (Clk,rst,d)
			BEGIN
				IF rst = '1'  THEN
					q <= (OTHERS=>'0');
				ELSIF rising_edge(Clk) or (en='1' and Clk='1') THEN
					q <= d;
				END IF;
		END PROCESS;
END a_my_reg;
