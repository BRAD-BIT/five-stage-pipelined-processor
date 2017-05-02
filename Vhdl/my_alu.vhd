library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;              



Entity my_alu is
port(
	ALuOperand1   : in  std_logic_vector(15 downto 0);
	ALuOperand2   : in  std_logic_vector(15 downto 0);
	AluSelect 	  : in  std_logic_vector(03 downto 0);
	Flags_in      : in  std_logic_vector(03 downto 0);
	ALuAns   	  : out std_logic_vector(15 downto 0);
	Flags_out     : out std_logic_vector(03 downto 0)
    );
End my_alu;
--Z=Flags(0)
--N=Flags(1)
--C=Flags(2)
--V=Flags(3)

Architecture a_my_alu of my_alu is

begin
	process (ALuOperand1,ALuOperand2,AluSelect)
	Variable Y : std_logic_vector(16 downto 0);
	Variable X : unsigned(16 downto 0);
        Variable Aux : std_logic_vector(3 downto 0);
		
        begin    
            Aux := AluSelect;
            case Aux is
				--ALuAns Is ALuOperand1
                when "0000" => 
				Y := '0'&ALuOperand1;
				Flags_out<=Flags_in;
				
				--Add
                when "0001" => 
				Y := ('0' & ALuOperand1) + ('0' & ALuOperand2);
				if Y = 0 then
					Flags_out(0) <= '1';
				else
					Flags_out(0) <= '0';
				end if;
				Flags_out(1)<=Y(15);
				Flags_out(2)<=Y(16);
				Flags_out(3)<=Flags_in(3);
				
				--Sub
                when "0010" => 
				Y := '0' & (ALuOperand1 - ALuOperand2);
				if Y = 0 then
					Flags_out(0) <= '1';
				else
					Flags_out(0) <= '0';
				end if;
				Flags_out(1)<=Y(15);
				Flags_out(2)<=Y(16);
				Flags_out(3)<=Flags_in(3);
				
				--AND
                when "0011" => 
				Y := '0' & (ALuOperand1 AND ALuOperand2);
				if Y = 0 then
					Flags_out(0) <= '1';
				else
					Flags_out(0) <= '0';
				end if;
				Flags_out(1)<=Y(15);
				Flags_out(2)<=Flags_in(2);
				Flags_out(3)<=Flags_in(3);
				
				--OR
                when "0100" => 
				Y := '0' & (ALuOperand1 OR ALuOperand2);
				if Y = 0 then
					Flags_out(0) <= '1';
				else
					Flags_out(0) <= '0';
				end if;
				Flags_out(1)<=Y(15);
				Flags_out(2)<=Flags_in(2);
				Flags_out(3)<=Flags_in(3);
				
				--RLC
                when "0101" => 
				Y := ALuOperand1(15)&ALuOperand1(14 DOWNTO 0)&ALuOperand1(15);
				if Y = 0 then
					Flags_out(0) <= '1';
				else
					Flags_out(0) <= '0';
				end if;
				Flags_out(1)<=Y(15);
				Flags_out(2)<=Y(16);
				Flags_out(3)<=Flags_in(3);
				
				--RRC
				when "0110" => 
				Y := ALuOperand1(0)&ALuOperand1(0)&ALuOperand1(15 DOWNTO 1);
				if Y = 0 then
					Flags_out(0) <= '1';
				else
					Flags_out(0) <= '0';
				end if;
				Flags_out(1)<=Y(15);
				Flags_out(2)<=Y(16);
				Flags_out(3)<=Flags_in(3);
				
				--SHL
                when "0111" => 
				X := shift_left(unsigned("0"&ALuOperand1),to_integer(unsigned(ALuOperand2(3 DOWNTO 0))));
				Y := std_logic_vector(X);
				if Y = 0 then
					Flags_out(0) <= '1';
				else
					Flags_out(0) <= '0';
				end if;
				Flags_out(1)<=Y(15);
				Flags_out(2)<=Y(16);
				Flags_out(3)<=Flags_in(3);
			
				--SHR
                when "1000" => 
				X := shift_right(unsigned("0"&ALuOperand1),to_integer(unsigned(ALuOperand2(3 DOWNTO 0))));
				Y := std_logic_vector(X);
				if Y = 0 then
					Flags_out(0) <= '1';
				else
					Flags_out(0) <= '0';
				end if;
				Flags_out(1)<=Y(15);
				Flags_out(2)<=Y(16);
				Flags_out(3)<=Flags_in(3);
				
				--NOT
                when "1001" => 
				Y := '0'&not(ALuOperand1);
				if Y = 0 then
					Flags_out(0) <= '1';
				else
					Flags_out(0) <= '0';
				end if;
				Flags_out(1)<=Y(15);
				Flags_out(2)<=Flags_in(2);
				Flags_out(3)<=Flags_in(3);
				
				--NEG
                when "1010" =>
				Y := ('0' & not(ALuOperand1)) + ("00000000000000001");
				if Y = 0 then
					Flags_out(0) <= '1';
				else
					Flags_out(0) <= '0';
				end if;
				Flags_out(1)<=Y(15);
				Flags_out(2)<=Flags_in(2);
				Flags_out(3)<=Flags_in(3);
				
				--INC
                when "1011" => 
				Y := ('0' & ALuOperand1) + ("00000000000000001");
				if Y = 0 then
					Flags_out(0) <= '1';
				else
					Flags_out(0) <= '0';
				end if;
				Flags_out(1)<=Y(15);
				Flags_out(2)<=Y(16);
				Flags_out(3)<=Flags_in(3);
				
				--DEC
				when "1100" => 
				Y := '0' & (ALuOperand1 - "0000000000000001");
				if Y = 0 then
					Flags_out(0) <= '1';
				else
					Flags_out(0) <= '0';
				end if;
				Flags_out(1)<=Y(15);
				Flags_out(2)<=Y(16);
				Flags_out(3)<=Flags_in(3);
				
				--SETC
                when "1101" => 
				Y := "00000000000000000";
				Flags_out(0)<=Flags_in(0);
				Flags_out(1)<=Flags_in(1);
				Flags_out(2)<='1';
				Flags_out(3)<=Flags_in(3);
				
				
				--CLRC
                when "1110" => 
				Y := "00000000000000000";
				Flags_out(0)<=Flags_in(0);
				Flags_out(1)<=Flags_in(1);
				Flags_out(2)<='0';
				Flags_out(3)<=Flags_in(3);
			   
                when others => NULL;
            end case;

			ALuAns<=Y(15 DOWNTO 0);
            
        end process;
end a_my_alu;