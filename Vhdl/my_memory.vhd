library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


Entity my_memory is
	port (
		clk : in std_logic;
		EnableRead  : in std_logic;
		EnableWrite : in std_logic;
		address : in std_logic_vector(15 downto 0);
		datain  : in std_logic_vector(15 downto 0);
		dataout : out std_logic_vector(15 downto 0)
	);
end entity my_memory;

architecture a_my_memory of my_memory is
   
	type ram_type is array(0 to 1023) of std_logic_vector(15 downto 0);

signal ram : ram_type ;
begin
	process(clk) is
  		Begin
			if falling_edge(clk) then  
				if EnableRead='1' then
  				dataout <= ram(to_integer(unsigned(address)));
				end if;
				if EnableWrite='1' then
  				ram(to_integer(unsigned(address)))<=datain;
				end if;
			end if;
	end process;

end architecture a_my_memory;

