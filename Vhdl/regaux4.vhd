library ieee;
use ieee.std_logic_1164.all;

-- Auxiliar register 4 - ME stage to WB stage

Entity regaux4 is
    Port (Clk,rst  : IN  std_logic;
	  inst_in  : in  std_logic_vector(15 downto 0);
	  DataToReg_in  : in  std_logic_vector(15 downto 0);
	  ControlUnit_in  : in  std_logic_vector(23 downto 0);	
      inst_out  : out  std_logic_vector(15 downto 0);
	  DataToReg_out  : out  std_logic_vector(15 downto 0);
	  ControlUnit_out  : out  std_logic_vector(23 downto 0)	
         );
    End;

Architecture behave of regaux4 is
    begin
    PROCESS (Clk,rst,DataToReg_in)
	BEGIN
		IF rst = '1'  THEN
			inst_out        <= (OTHERS=>'0');
			DataToReg_out   <= (OTHERS=>'0');
			ControlUnit_out <= (OTHERS=>'0');
		ELSIF Clk='0' THEN
			inst_out        <= inst_in;
			DataToReg_out   <= DataToReg_in;		
			ControlUnit_out <= ControlUnit_in;
		END IF;
	END PROCESS;
    end;