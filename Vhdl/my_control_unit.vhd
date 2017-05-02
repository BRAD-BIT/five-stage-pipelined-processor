library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


Entity my_control_unit is
	port (
		rest: in std_logic;
		clk : in std_logic;
		address : in std_logic_vector(4 downto 0);
		dataout : out std_logic_vector(23 downto 0) );
end entity my_control_unit;

architecture a_my_control_unit of my_control_unit is
   
	type ram_type is array(0 to 31) of std_logic_vector(23 downto 0);

signal ram : ram_type ;
begin
	process(clk,rest,address) is
  		Begin
			IF rest = '1'  THEN
			dataout <= (OTHERS=>'0');
			ELSIF address'event then  
  			dataout <= ram(to_integer(unsigned(address)));
			end if;
	end process;

end architecture a_my_control_unit;

