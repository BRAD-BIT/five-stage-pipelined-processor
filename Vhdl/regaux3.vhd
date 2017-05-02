library ieee;
use ieee.std_logic_1164.all;

-- Auxiliar register 3 - EX stage to ME stage

Entity regaux3 is
    Port (Clk,rst  : IN  std_logic;
	  inst_in  : in  std_logic_vector(15 downto 0);
	  AluAns_in  : in  std_logic_vector(15 downto 0);
	  CCR_in  : in  std_logic_vector(3 downto 0);	
	  ControlUnit_in  : in  std_logic_vector(23 downto 0);	
          inst_out  : out  std_logic_vector(15 downto 0);
	  AluAns_out  : out  std_logic_vector(15 downto 0);
	  CCR_out  : out  std_logic_vector(3 downto 0);	
	  ControlUnit_out  : out  std_logic_vector(23 downto 0)	
         );
    End;

Architecture behave of regaux3 is
    begin
        PROCESS (Clk,rst)
	BEGIN
		IF rst = '1'  THEN
			inst_out        <= (OTHERS=>'0');
			AluAns_out      <= (OTHERS=>'0');
			CCR_out         <= (OTHERS=>'0');
			ControlUnit_out <= (OTHERS=>'0');
		ELSIF rising_edge(Clk) THEN
			inst_out        <= inst_in;
			AluAns_out   <= AluAns_in;
			CCR_out   <= CCR_in;
			ControlUnit_out <= ControlUnit_in;
		END IF;
	END PROCESS;
    end;