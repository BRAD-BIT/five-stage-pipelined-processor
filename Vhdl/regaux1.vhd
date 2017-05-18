library ieee;
use ieee.std_logic_1164.all;

-- Auxiliar register 1 - IF stage to ID stage

Entity regaux1 is
    Port (Clk,rst,en     : IN  std_logic;
		  inst_in     : in  std_logic_vector(15 downto 0);	
          next_pc_in  : in  std_logic_vector(15 downto 0);	
		  reset	: in std_logic;
		  interrupt : in std_logic;
		  reset_out	: out std_logic;
		  interrupt_out : out std_logic;
          next_pc_out : out std_logic_vector(15 downto 0);
          inst_out    : out std_logic_vector(15 downto 0)
         );
    End;

Architecture behave of regaux1 is
    begin
        PROCESS (Clk)
	BEGIN
		IF rst = '1' and Clk='1' THEN
			inst_out <= (OTHERS=>'1');
			next_pc_out <= (OTHERS=>'0');
			reset_out <= '0';
			interrupt_out <='0';
		ELSIF rising_edge(Clk) THEN
			if (interrupt='1' or reset='1')and en='0' then
				inst_out <= (OTHERS=>'1');
				next_pc_out <= (OTHERS=>'0');
				ELSE
				inst_out <= inst_in;
				next_pc_out <= next_pc_in;
			end if;
			reset_out <= reset;
			interrupt_out <=interrupt;
		END IF;
		
	END PROCESS;
    end;