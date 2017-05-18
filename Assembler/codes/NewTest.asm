LDM R0, 0				#R0=0
0
LDM R1, 21              #R1=21
21
LDM R2, 25				#R2=25
25
LDM R4, 12				#R4=12
12
LDM R5, 15				#R5=15
15
STD R0, 3				#M[3]=0
3
IN R3					#Get Input
AND R3, R3, R3
JN R1					#If negative JMP Line_21
LDD R0, 3				#else
3
ADD R0, R3, R0			#Add input to M[3]
STD R0, 3
3
JMP R4					#Jump to get input Line_12
CALL R2					#Call abs Line_25
JMP R5					#jump to Add to M[3] Line_15
STD R4, 3				#Set M[3] by 1
3
NEG R3					#Negate the Input
RET						#Return
STD R2, 3				#Set M[3] by 1
3
STD R1,10
10
STD R2,11
11
STD R3,12
12
STD R4,13
13
STD R5,13
14
RTI
