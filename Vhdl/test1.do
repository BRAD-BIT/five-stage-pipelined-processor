vsim -gui work.project_system
mem load -i C:/Users/moham/Desktop/#Arch_Proj/vhdl/Initialize_Reg_File.mem -format binary /project_system/RegisterFile/ram
mem load -i C:/Users/moham/Desktop/#Arch_Proj/vhdl/control_unit.mem -format binary /project_system/ControlUnit/ram
mem load -i C:/Users/moham/Desktop/#Arch_Proj/vhdl/encoded_code.mem -format binary /project_system/InstMemory/ram
add wave -position insertpoint  \
sim:/project_system/system_clock \
sim:/project_system/rest_registers
force -freeze sim:/project_system/system_clock 1 0, 0 {50 ps} -r 100
force -freeze sim:/project_system/rest_registers 1 0
run
force -freeze sim:/project_system/rest_registers 0 0
run
