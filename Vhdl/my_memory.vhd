library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;              


Entity my_memory is
	port (
		clk : in std_logic;
		EnablePush  : in std_logic;
		EnablePop   : in std_logic;
		SP_In		: in std_logic_vector(15 downto 0);
		SP_Out		: out std_logic_vector(15 downto 0);
		PushData    : in std_logic_vector(15 downto 0);
		PopData 	: out std_logic_vector(15 downto 0);
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
				if EnablePop='1' then
  				PopData <= ram(to_integer(unsigned(SP_In+"0000000000000001")));
				SP_Out <= SP_In+"0000000000000001";
				end if;
				if EnablePush='1' then
  				ram(to_integer(unsigned(SP_In)))<=PushData;
				SP_Out <= SP_In-"0000000000000001";
				end if;
				if EnablePush='0' AND EnablePop='0' then 
				SP_Out<=SP_In;
				end if;
			end if;
	end process;

end architecture a_my_memory;

