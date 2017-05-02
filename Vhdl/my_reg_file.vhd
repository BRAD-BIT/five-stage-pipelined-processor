library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity my_reg_file is
port(ReadRegNum1   : in std_logic_vector(2 downto 0);
     ReadRegNum2   : in std_logic_vector(2 downto 0);
     WriteRegNum  : in std_logic_vector(2 downto 0);
     WriteData     : in std_logic_vector(15 downto 0);
     clk           : in std_logic;
     rst           : in std_logic;
     EnableWrite   : in std_logic;
     ReadData1 	   : out std_logic_vector(15 downto 0);
     ReadData2     : out std_logic_vector(15 downto 0));
End my_reg_file;


Architecture a_my_reg_file of my_reg_file is

    type ram_type is array (0 to 5) of std_logic_vector(15 downto 0);
    signal ram : ram_type;

    begin
        process (ReadRegNum1, ReadRegNum2, WriteRegNum, clk)
	begin
	    if rst = '1' then
		ReadData1 <="0000000000000000";
		ReadData2 <="0000000000000000";
	    Else	
	        if clk'event and clk = '0' and not(ReadRegNum1="111") then 
            	ReadData1 <= ram(to_integer(unsigned(ReadRegNum1)));               
            	ReadData2 <= ram(to_integer(unsigned(ReadRegNum2)));               
            end if;
            if clk'event and clk = '1' then 
                if EnableWrite = '1' then
                    ram(to_integer(unsigned(WriteRegNum))) <= WriteData;
                end if;
            end if;
		end if;

        end process;
    end a_my_reg_file;