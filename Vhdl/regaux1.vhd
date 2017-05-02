library ieee;
use ieee.std_logic_1164.all;

-- Auxiliar register 1 - IF stage to ID stage

Entity regaux1 is
    Port (Clk,rst  : IN  std_logic;
	  inst_in  : in  std_logic_vector(15 downto 0);	
          inst_out : out std_logic_vector(15 downto 0)
         );
    End;

Architecture behave of regaux1 is
    begin
        PROCESS (Clk,rst)
	BEGIN
		IF rst = '1'  THEN
			inst_out <= (OTHERS=>'1');
		ELSIF rising_edge(Clk) THEN
			inst_out <= inst_in;
		END IF;
	END PROCESS;
    end;