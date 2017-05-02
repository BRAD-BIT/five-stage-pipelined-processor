LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

ENTITY project_system IS
	PORT  ( 
			system_clock            : IN     std_logic;
			memory_clock            : IN     std_logic;
			rest_registers          : IN     std_logic
	     );
END project_system;

ARCHITECTURE a_project_system OF project_system IS
	
	COMPONENT my_reg IS
	PORT( Clk,rst,en : IN std_logic;
		  d : IN  std_logic_vector(15 DOWNTO 0);
		  q : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT;

	
	COMPONENT my_inst_memory is
	port (
		clk : in std_logic;
		address : in std_logic_vector(5 downto 0);
		dataout : out std_logic_vector(15 downto 0) );
	END COMPONENT;

	COMPONENT my_control_unit is
	port (
		rest: in std_logic;
		clk : in std_logic;
		address : in std_logic_vector(4 downto 0);
		dataout : out std_logic_vector(23 downto 0) );
	END COMPONENT;

	COMPONENT regaux1 is
    	Port (  Clk,rst  : IN  std_logic;
	  	inst_in  : in  std_logic_vector(15 downto 0);	
         	inst_out : out std_logic_vector(15 downto 0));
   	END COMPONENT;

	COMPONENT regaux2 is
		Port (Clk,rst  : IN  std_logic;
			  inst_in  : in  std_logic_vector(15 downto 0);
			  ReadData1_in  : in  std_logic_vector(15 downto 0);
			  ReadData2_in  : in  std_logic_vector(15 downto 0);	
			  ControlUnit_in  : in  std_logic_vector(23 downto 0);	
				  inst_out  : out  std_logic_vector(15 downto 0);
			  ReadData1_out  : out  std_logic_vector(15 downto 0);
			  ReadData2_out  : out  std_logic_vector(15 downto 0);	
			  ControlUnit_out  : out  std_logic_vector(23 downto 0)	
			 );
   	END COMPONENT;
	
	COMPONENT regaux3 is
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
   	 END COMPONENT;
	 
	COMPONENT regaux4 is
    Port (Clk,rst  : IN  std_logic;
	  inst_in  : in  std_logic_vector(15 downto 0);
	  DataToReg_in  : in  std_logic_vector(15 downto 0);
	  ControlUnit_in  : in  std_logic_vector(23 downto 0);	
          inst_out  : out  std_logic_vector(15 downto 0);
	  DataToReg_out  : out  std_logic_vector(15 downto 0);
	  ControlUnit_out  : out  std_logic_vector(23 downto 0)	
         );
    END COMPONENT;

	COMPONENT my_reg_file is
		port(ReadRegNum1   : in std_logic_vector(2 downto 0);
			 ReadRegNum2   : in std_logic_vector(2 downto 0);
			 WriteRegNum  : in std_logic_vector(2 downto 0);
			 WriteData     : in std_logic_vector(15 downto 0);
			 clk           : in std_logic;
			 rst           : in std_logic;
			 EnableWrite   : in std_logic;
			 ReadData1 	   : out std_logic_vector(15 downto 0);
			 ReadData2     : out std_logic_vector(15 downto 0));
	END COMPONENT;

	COMPONENT my_memory is
	port (
		clk : in std_logic;
		EnableRead  : in std_logic;
		EnableWrite : in std_logic;
		address : in std_logic_vector(15 downto 0);
		datain  : in std_logic_vector(15 downto 0);
		dataout : out std_logic_vector(15 downto 0)
	);
	END COMPONENT;

	COMPONENT my_mux2 IS  
			PORT (
				s   : IN  std_logic;			
				a, b: IN std_logic_vector(2 downto 0);		      
				z   : OUT std_logic_vector(2 downto 0));    
	END COMPONENT my_mux2;
	
	
	COMPONENT my_alu is
	port(
		ALuOperand1   : in  std_logic_vector(15 downto 0);
		ALuOperand2   : in  std_logic_vector(15 downto 0);
		AluSelect 	  : in  std_logic_vector(03 downto 0);
		Flags_in      : in  std_logic_vector(03 downto 0);
		ALuAns   	  : out std_logic_vector(15 downto 0);
		Flags_out     : out std_logic_vector(03 downto 0)
		);
	End COMPONENT;
	
	SIGNAL Current_PC,NEXT_PC,Inst : std_logic_vector(15 DOWNTO 0);
	
	--ID
	SIGNAL FD_Inst,ReadData1,ReadData2 : std_logic_vector(15 DOWNTO 0);
	SIGNAL FD_Inst_Opcode          : std_logic_vector(04 DOWNTO 0);
	SIGNAL ControlSignals 	       : std_logic_vector(23 DOWNTO 0);
	SIGNAL ReadRegNum1,ReadRegNum2,WriteRegNum : std_logic_vector(2 DOWNTO 0);
	SIGNAL StopControlUnit		   : std_logic;
	--EX
	SIGNAL DE_ReadDate1,DE_ReadDate2,DE_Inst,ALuAns : std_logic_vector(15 DOWNTO 0);
	SIGNAL DE_ControlSignals 	       : std_logic_vector(23 DOWNTO 0);
	SIGNAL CCR 	: std_logic_vector(3 DOWNTO 0);

	--ME
	SIGNAL EM_Inst,EM_ALuAns : std_logic_vector(15 DOWNTO 0);
	SIGNAL EM_ControlSignals 	       : std_logic_vector(23 DOWNTO 0);
	SIGNAL EM_CCR 	: std_logic_vector(3 DOWNTO 0);
	SIGNAL Mem_Out  : std_logic_vector(15 DOWNTO 0);
	SIGNAL DataToReg  : std_logic_vector(15 DOWNTO 0);
	
	--WB
	SIGNAL MW_Inst,MW_DataToReg : std_logic_vector(15 DOWNTO 0);
	SIGNAL MW_ControlSignals 	: std_logic_vector(23 DOWNTO 0);

	BEGIN
	--IF
	CurrentPC	: my_reg             port map(system_clock,rest_registers,'1',NEXT_PC,Current_PC);
	NEXTPC		: NEXT_PC <= Current_PC+1;
	InstMemory	: my_inst_memory     port map(system_clock,Current_PC(5 downto 0),Inst);
	RegPipe1 	: regaux1	     port map(system_clock,rest_registers,Inst,FD_Inst);
	--ID

	FD_Inst_Opcode <= FD_Inst(15 downto 11);
	StopControlUnit<=rest_registers or DE_ControlSignals(6);
	ControlUnit     : my_control_unit    port map(StopControlUnit,system_clock,FD_Inst_Opcode,ControlSignals);
	
	ReadRegNumSel	: my_mux2	     port map(ControlSignals(20),FD_Inst(7 downto 5),FD_Inst(10 downto 8),ReadRegNum1);
	ReadRegNum2 <= FD_Inst(4 downto 2);
	WriteRegNum <= MW_Inst(10 downto 8);
	RegisterFile    : my_reg_file    port map(ReadRegNum1,ReadRegNum2,WriteRegNum,MW_DataToReg,system_clock,rest_registers,MW_ControlSignals(21),ReadData1,ReadData2);
	RegPipe2 	    : regaux2	     port map(system_clock,rest_registers,FD_Inst,ReadData1,ReadData2,ControlSignals,DE_Inst,DE_ReadDate1,DE_ReadDate2,DE_ControlSignals);
	
	--EX
		
	AluExecution	: my_alu		 port map(DE_ReadDate1,DE_ReadDate2,DE_ControlSignals(18 DOWNTO 15),EM_CCR,ALuAns,CCR);
	RegPipe3 	    : regaux3	     port map(system_clock,rest_registers,DE_Inst,ALuAns,CCR,DE_ControlSignals,EM_Inst,EM_ALuAns,EM_CCR,EM_ControlSignals);

	--ME
	MemoryFetch     : my_memory      port map(system_clock,EM_ControlSignals(14),EM_ControlSignals(13),DE_Inst,EM_ALuAns,Mem_Out);
	
	DataToReg <= DE_Inst WHEN EM_Inst(15 DOWNTO 11) = "11011" 
	ELSE Mem_Out WHEN EM_ControlSignals(14)='1'
	ELSE EM_ALuAns;
	
	RegPipe4 	    : regaux4	     port map(system_clock,rest_registers,EM_Inst,DataToReg,EM_ControlSignals,MW_Inst,MW_DataToReg,MW_ControlSignals);

	--WB
	
END a_project_system;
