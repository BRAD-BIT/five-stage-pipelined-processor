vsim -gui work.project_system
mem load -i F:/www/Pro/Project/Vhdl/Initialize/InitializeMemory.mem -format binary /project_system/MemoryFetch/ram
mem load -i F:/www/Pro/Project/Vhdl/Initialize/InitializeRegisterFile.mem -format binary /project_system/RegisterFile/ram
mem load -i F:/www/Pro/Project/Vhdl/Initialize/InitializeControlUnit.mem -format binary /project_system/ControlUnit/ram
mem load -i F:/www/Pro/Project/Vhdl/EncodedCodes/NewTest.mem -format binary /project_system/InstMemory/ram
add wave -position insertpoint  \
sim:/project_system/system_clock \
sim:/project_system/rest_registers
force -freeze sim:/project_system/system_clock 1 0, 0 {50 ps} -r 100
force -freeze sim:/project_system/rest_registers 1 0
force -freeze sim:/project_system/Reset 0 0
force -freeze sim:/project_system/Interrupt 0 0
run
force -freeze sim:/project_system/rest_registers 0 0
run


