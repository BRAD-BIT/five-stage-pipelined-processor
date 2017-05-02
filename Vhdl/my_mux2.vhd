LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY my_mux2 IS  
		PORT (
			s   : IN  std_logic;			
			a, b: IN std_logic_vector(2 downto 0);		      
			z   : OUT std_logic_vector(2 downto 0));    
END ENTITY my_mux2;


ARCHITECTURE a_my_mux2 OF my_mux2 IS
BEGIN
     z <= a when s = '0' else b;
     
END a_my_mux2;
