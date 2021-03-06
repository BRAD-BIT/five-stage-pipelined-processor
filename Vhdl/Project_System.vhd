LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

ENTITY project_system IS
	PORT  ( 
			system_clock            : IN     std_logic;
			rest_registers          : IN     std_logic;
			Interrupt				: IN 	 std_logic;
			Reset					: IN 	 std_logic;
			IN_PORT 				: IN	 std_logic_vector(15 DOWNTO 0);
			OUT_PORT 				: OUT	 std_logic_vector(15 DOWNTO 0)
	     );
END project_system;

ARCHITECTURE a_project_system OF project_system IS
	
	COMPONENT my_reg IS
	PORT( Clk,rst,en : IN std_logic;
		  d : IN  std_logic_vector(15 DOWNTO 0);
		  q : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT;

	COMPONENT my_branch_flush_reg IS
	PORT( Clk,rst,en : IN std_logic;
		  d : IN  std_logic;
		  q : OUT std_logic);
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
    	Port (  Clk,rst,en  : IN  std_logic;
	  	inst_in  : in  std_logic_vector(15 downto 0);	
 		next_pc_in  : in  std_logic_vector(15 downto 0);	
		 reset	: in std_logic;
		  interrupt : in std_logic;
		  reset_out	: out std_logic;
		  interrupt_out : out std_logic;
    		next_pc_out : out std_logic_vector(15 downto 0);
         	inst_out : out std_logic_vector(15 downto 0));
   	END COMPONENT;

	COMPONENT regaux2 is
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
   	END COMPONENT;
	
	COMPONENT regaux3 is
    	Port (Clk,rst,not_ccr  : IN  std_logic;
	  inst_in  : in  std_logic_vector(15 downto 0);
	  AluAns_in  : in  std_logic_vector(15 downto 0);
	  CCR_in  : in  std_logic_vector(3 downto 0);	
	  ControlUnit_in  : in  std_logic_vector(23 downto 0);	
 	  next_pc_in  : in  std_logic_vector(15 downto 0);	
	   reset	: in std_logic;
		  interrupt : in std_logic;
		  reset_out	: out std_logic;
		  interrupt_out : out std_logic;
          next_pc_out : out std_logic_vector(15 downto 0);
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
	
	COMPONENT regaux4Temp is
    Port (Clk,rst,en  : IN  std_logic;
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
	END COMPONENT;

	COMPONENT my_mux2 IS  
			PORT (
				s   : IN  std_logic;			
				a, b: IN std_logic_vector(2 downto 0);		      
				z   : OUT std_logic_vector(2 downto 0));    
	END COMPONENT my_mux2;
	
	
	COMPONENT my_alu is
	port(
		clk			  : in std_logic;
		ALuOperand1   : in  std_logic_vector(15 downto 0);
		ALuOperand2   : in  std_logic_vector(15 downto 0);
		AluSelect 	  : in  std_logic_vector(03 downto 0);
		Flags_in      : in  std_logic_vector(03 downto 0);
		ALuAns   	  : out std_logic_vector(15 downto 0);
		Flags_out     : out std_logic_vector(03 downto 0)
		);
	End COMPONENT;
	--Global
	SIGNAL InterruptResetStop : std_logic;

	
	--IF
	SIGNAL Current_PC,NEXT_PC,Inst : std_logic_vector(15 DOWNTO 0);
	
	--ID
	SIGNAL FD_NEXT_PC : std_logic_vector(15 DOWNTO 0);
	SIGNAL FD_Inst,ReadData1,ReadData2 : std_logic_vector(15 DOWNTO 0);
	SIGNAL FD_Inst_Opcode          : std_logic_vector(04 DOWNTO 0);
	SIGNAL ControlSignals 	       : std_logic_vector(23 DOWNTO 0);
	SIGNAL ReadRegNum1,ReadRegNum2,WriteRegNum : std_logic_vector(2 DOWNTO 0);
	SIGNAL StopControlUnit		   : std_logic;
	SIGNAL RegPipe1Rst			   : std_logic; 
	SIGNAL EnableJmpCall 		   : std_logic;
	SIGNAL EnableJmpCallFlush      : std_logic;
	SIGNAL AluForward1,AluForward2 : std_logic_vector(15 DOWNTO 0);  
	SIGNAL InputeNeeded  		   : std_logic;
	SIGNAL FD_Reset,FD_Interrupt   : std_logic;
	--EX
	SIGNAL DE_NEXT_PC : std_logic_vector(15 DOWNTO 0);
	SIGNAL DE_ReadDate1,DE_ReadDate2,DE_Inst,ALuAns : std_logic_vector(15 DOWNTO 0);
	SIGNAL DE_ControlSignals 	       : std_logic_vector(23 DOWNTO 0);
	SIGNAL CCR 	: std_logic_vector(3 DOWNTO 0);
	SIGNAL EnableBranch : std_logic;
	SIGNAL EnableBranchFlush : std_logic;
	SIGNAL RegPipe2Rst			   : std_logic;
	SIGNAL DE_ReadRegNum1 : std_logic_vector(2 DOWNTO 0);
	SIGNAL DE_Reset,DE_Interrupt   : std_logic;
	SIGNAL CCR_IN : std_logic_vector(3 DOWNTO 0);
	--ME
	SIGNAL EM_NEXT_PC : std_logic_vector(15 DOWNTO 0);
	SIGNAL EM_Inst,EM_ALuAns : std_logic_vector(15 DOWNTO 0);
	SIGNAL EM_ControlSignals 	       : std_logic_vector(23 DOWNTO 0);
	SIGNAL EM_CCR 	: std_logic_vector(3 DOWNTO 0);
	SIGNAL Mem_Out  : std_logic_vector(15 DOWNTO 0);
	SIGNAL DataToReg  : std_logic_vector(15 DOWNTO 0);
	SIGNAL SP_In,SP_Out,PopData,PushData : std_logic_vector(15 DOWNTO 0);
	SIGNAL EnableRet 		   : std_logic;
	SIGNAL EnableRetFlush      : std_logic;
	SIGNAL RegPipe3Rst		   : std_logic;
	SIGNAL EM_Reset,EM_Interrupt   : std_logic;
	SIGNAL EnablePush    : std_logic;
	SIGNAL EnableMemRead : std_logic;
	SIGNAL MemReadAddress	 : std_logic_vector(15 DOWNTO 0);
	--WB
	SIGNAL MW_Inst,MW_DataToReg : std_logic_vector(15 DOWNTO 0);
	SIGNAL MW_ControlSignals 	: std_logic_vector(23 DOWNTO 0);
	BEGIN
	--IF
	CurrentPC	: my_reg             port map(system_clock,rest_registers,EnableJmpCallFlush,NEXT_PC,Current_PC);
	
	NEXT_PC <= ALuAns    WHEN EnableBranchFlush='1'  AND system_clock='0'
	ELSE 	   ALuAns	 WHEN EnableJmpCallFlush='1' AND system_clock='1'
	ELSE       "000000"&PopData(9 DOWNTO 0) WHEN EnableRetFlush='1' AND system_clock='0'
	ELSE 	   Mem_Out WHEN EM_Interrupt='1' or EM_Reset='1'
	ELSE       Current_PC+1 WHEN Interrupt='1' and  ControlSignals(6)='1' and system_clock='0' 
	ELSE       Current_PC WHEN (Interrupt='1' or InterruptResetStop='1')
	ELSE       Current_PC+1;
	
	InstMemory	: my_inst_memory     port map(system_clock,Current_PC(5 downto 0),Inst);
	
	RegPipe1Rst<=rest_registers or EnableBranchFlush or EnableJmpCallFlush or EnableRetFlush or InterruptResetStop;
	RegPipe1 	: regaux1	     port map(system_clock,RegPipe1Rst,ControlSignals(6),Inst,NEXT_PC,Reset,Interrupt,FD_Reset,FD_Interrupt,FD_NEXT_PC,FD_Inst);
	--ID

	InterruptResetStop <= '1' WHEN FD_Interrupt='1' or FD_Reset='1' or DE_Interrupt='1' or DE_Reset='1' or EM_Interrupt='1' or EM_Reset='1'
	ELSE '0';
	
	
	FD_Inst_Opcode <= FD_Inst(15 downto 11);
	StopControlUnit<=rest_registers or DE_ControlSignals(6);
	ControlUnit     : my_control_unit    port map(StopControlUnit,system_clock,FD_Inst_Opcode,ControlSignals);
	
	InputeNeeded<=ControlSignals(8);
	
	ReadRegNumSel	: my_mux2	     port map(ControlSignals(20),FD_Inst(7 downto 5),FD_Inst(10 downto 8),ReadRegNum1);
	ReadRegNum2 <= FD_Inst(4 downto 2);
	WriteRegNum <= MW_Inst(10 downto 8);
	RegisterFile    : my_reg_file    port map(ReadRegNum1,ReadRegNum2,WriteRegNum,MW_DataToReg,system_clock,rest_registers,MW_ControlSignals(21),ReadData1,ReadData2);
	
	
	EnableJmpCall <= '1' WHEN FD_Inst(15 DOWNTO 11)="11000" or FD_Inst(15 DOWNTO 11)="10111" 
	ELSE '0';
	FlushJmpCallSet		: my_branch_flush_reg port map(system_clock,rest_registers,'1',EnableJmpCall,EnableJmpCallFlush);

	
	
	
	--OUT_PORT <= ReadData1 WHEN FD_Inst(15 DOWNTO 11)="01110"
	--ELSE OUT_PORT;
	
	
	RegPipe2Rst<=rest_registers or EnableBranchFlush or EnableRetFlush;
	RegPipe2 	    : regaux2	     port map(system_clock,RegPipe2Rst,'0',FD_Inst,ReadData1,ReadData2,ControlSignals,FD_NEXT_PC,FD_Reset,FD_Interrupt,DE_Reset,DE_Interrupt,DE_NEXT_PC,DE_Inst,DE_ReadDate1,DE_ReadDate2,DE_ControlSignals);
	
	--EX
	
	
	DE_ReadRegNum1 <= DE_Inst(7 downto 5) WHEN DE_ControlSignals(20)='0'
	ELSE DE_Inst(10 downto 8);
	


	
	AluForward1 <= EM_ALuAns WHEN EM_Inst(10 downto 8)=DE_ReadRegNum1 and EM_ControlSignals(21)='1' and EM_ControlSignals(14)='0' and EM_ControlSignals(11)='0' and EM_ControlSignals(8)='0'
	ELSE PopData WHEN EM_Inst(10 downto 8)=DE_ReadRegNum1 and EM_ControlSignals(21)='1' and EM_ControlSignals(11)='1'
	ELSE MW_DataToReg WHEN MW_Inst(10 downto 8)=DE_ReadRegNum1 and MW_ControlSignals(21)='1' and (MW_ControlSignals(14)='1' or MW_ControlSignals(11)='1' or MW_ControlSignals(8)='0')
	ELSE IN_PORT WHEN MW_Inst(10 downto 8)=DE_ReadRegNum1 and MW_ControlSignals(8)='1'
	ELSE IN_PORT WHEN EM_Inst(10 downto 8)=DE_ReadRegNum1 and EM_ControlSignals(8)='1'
	ELSE DE_ReadDate1;
	
	AluForward2 <= EM_ALuAns WHEN EM_Inst(10 downto 8)=DE_Inst(4 downto 2) and EM_ControlSignals(21)='1' and EM_ControlSignals(14)='0' and EM_ControlSignals(11)='0' and EM_ControlSignals(8)='0'
	ELSE PopData WHEN EM_Inst(10 downto 8)=DE_Inst(4 downto 2) and EM_ControlSignals(21)='1' and EM_ControlSignals(11)='1'
	ELSE MW_DataToReg WHEN MW_Inst(10 downto 8)=DE_Inst(4 downto 2) and MW_ControlSignals(21)='1' and (MW_ControlSignals(14)='1' or MW_ControlSignals(11)='1' or MW_ControlSignals(8)='0')
	ELSE IN_PORT WHEN MW_Inst(10 downto 8)=DE_Inst(4 downto 2) and MW_ControlSignals(8)='1'
	ELSE IN_PORT WHEN EM_Inst(10 downto 8)=DE_Inst(4 downto 2) and EM_ControlSignals(8)='1'
	ELSE DE_ReadDate2;
	
	OUT_PORT<=AluForward1 WHEN DE_Inst(15 DOWNTO 11)="01110";
	
	
	
	CCR_IN    <=   PopData(13 DOWNTO 10) WHEN EnableRetFlush='1' AND system_clock='0'
	ELSe EM_CCR;
		
	AluExecution	: my_alu		 port map(system_clock,AluForward1,AluForward2,DE_ControlSignals(18 DOWNTO 15),CCR_IN,ALuAns,CCR);
	
	EnableBranch <= '1' WHEN DE_Inst(15 DOWNTO 11)="10100" AND CCR(0)='1'
	ELSE			'1' WHEN DE_Inst(15 DOWNTO 11)="10101" AND CCR(1)='1'
	ELSE			'1' WHEN DE_Inst(15 DOWNTO 11)="10110" AND CCR(2)='1'
	ELSE 			'0';
	
	FlushBranchSet		: my_branch_flush_reg port map(system_clock,rest_registers,'1',EnableBranch,EnableBranchFlush);
	
	RegPipe3Rst<=rest_registers or EnableRetFlush;
	RegPipe3 	    : regaux3	     port map(system_clock,RegPipe3Rst,EnableRetFlush,DE_Inst,ALuAns,CCR,DE_ControlSignals,DE_NEXT_PC,DE_Reset,DE_Interrupt,EM_Reset,EM_Interrupt,EM_NEXT_PC,EM_Inst,EM_ALuAns,EM_CCR,EM_ControlSignals);

	--ME
	
	
	SP_In <= "0000001111111111" WHEN rest_registers='1'
	ELSE SP_Out;
	
	PushData <= EM_ALuAns WHEN EM_ControlSignals(10 DOWNTO 9)="00" and EM_Interrupt='0'
	ELSE	 "00"&EM_CCR&Current_PC(9 DOWNTO 0) WHEN EM_Interrupt='1'
	ELSE     "00"&EM_CCR&EM_NEXT_PC(9 DOWNTO 0);
	
	
	EnablePush <= EM_ControlSignals(12) or EM_Interrupt;
	
	EnableMemRead<=EM_Interrupt or EM_Reset or EM_ControlSignals(14);
	
	MemReadAddress<= "0000000000000000" WHEN EM_Reset='1'
	ELSE "0000000000000001" WHEN EM_Interrupt='1'
	ELSE DE_Inst;
	
	MemoryFetch     : my_memory      port map(system_clock,EnablePush,EM_ControlSignals(11),SP_In,SP_Out,PushData,PopData,EnableMemRead,EM_ControlSignals(13),MemReadAddress,EM_ALuAns,Mem_Out);
	
	DataToReg <= DE_Inst WHEN EM_Inst(15 DOWNTO 11) = "11011" 
	ELSE Mem_Out WHEN EM_ControlSignals(14)='1'
	ELSE PopData WHEN EM_Inst(15 DOWNTO 11) = "01101"
	ELSE IN_PORT WHEN EM_Inst(15 DOWNTO 11) = "01111"
	ELSE EM_ALuAns;

	EnableRet<='1' WHEN EM_Inst(15 DOWNTO 11)="11001"
	ELSE       '1' WHEN EM_Inst(15 DOWNTO 11)="11010"
	ELSE '0';
	
	FlushRetSet		: my_branch_flush_reg port map(system_clock,rest_registers,'1',EnableRet,EnableRetFlush);
	
	RegPipe4 	    : regaux4	     port map(system_clock,rest_registers,EM_Inst,DataToReg,EM_ControlSignals,MW_Inst,MW_DataToReg,MW_ControlSignals);
	

	
	--WB
	
	
END a_project_system;


