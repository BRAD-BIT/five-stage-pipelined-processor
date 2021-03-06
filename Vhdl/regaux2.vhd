library ieee;
use ieee.std_logic_1164.all;

-- Auxiliar register 2 - ID stage to EX stage

Entity regaux2 is
    Port (Clk,rst,en  : IN  std_logic;
	  inst_in  : in  std_logic_vector(15 downto 0);
	  ReadData1_in  : in  std_logic_vector(15 downto 0);
	  ReadData2_in  : in  std_logic_vector(15 downto 0);	
	  ControlUnit_in  : in  std_logic_vector(23 downto 0);	
	  next_pc_in  : in  std_logic_vector(15 downto 0);	
	  reset	: in std_logic;
	  interrupt : in std_logic;
	  reset_out	: out std_logic;
	  interrupt_out : out std_logic;
	  next_pc_out : out std_logic_vector(15 downto 0);
	  inst_out  : out  std_logic_vector(15 downto 0);
	  ReadData1_out  : out  std_logic_vector(15 downto 0);
	  ReadData2_out  : out  std_logic_vector(15 downto 0);	
	  ControlUnit_out  : out  std_logic_vector(23 downto 0)	
         );
    End;

Architecture behave of regaux2 is
    begin
        PROCESS (Clk)
	BEGIN
		IF rst = '1'  THEN
			inst_out        <= (OTHERS=>'0');
			ReadData1_out   <= (OTHERS=>'0');
			ReadData2_out   <= (OTHERS=>'0');
			ControlUnit_out <= (OTHERS=>'0');
			next_pc_out <= (OTHERS=>'0');
			reset_out <= '0';
			interrupt_out <='0';
		ELSIF rising_edge(Clk) and en='0' THEN
			inst_out        <= inst_in;
			ReadData1_out   <= ReadData1_in;
			ReadData2_out   <= ReadData2_in;
			ControlUnit_out <= ControlUnit_in;
			next_pc_out <= next_pc_in;
			reset_out <= reset;
			interrupt_out <=interrupt;
		END IF;
	END PROCESS;
    end;