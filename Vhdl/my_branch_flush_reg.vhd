LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY my_branch_flush_reg IS
	PORT( Clk,rst,en : IN std_logic;
		  d : IN  std_logic;
		  q : OUT std_logic);
END my_branch_flush_reg;

ARCHITECTURE a_my_branch_flush_reg OF my_branch_flush_reg IS
	BEGIN
		PROCESS (Clk,rst)
			BEGIN
				IF rst = '1'  THEN
					q <= '0';
				ELSIF en = '1' AND falling_edge(Clk) THEN
					q <= d;
				END IF;
		END PROCESS;
END a_my_branch_flush_reg;
