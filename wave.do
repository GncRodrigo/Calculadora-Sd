# Limpa o que tiver na visualização atual
delete wave *

# Mostra sinais do testbench
add wave -divider "Testbench"
add wave -decimal /tb_calc/clock
add wave -decimal /tb_calc/reset
add wave -decimal /tb_calc/cmd
add wave -decimal /tb_calc/status

# Mostra entradas no calc_top
add wave -divider "Entradas - calc_top"
add wave -decimal /tb_calc/dut/dig
add wave -decimal /tb_calc/dut/pos
add wave -decimal /tb_calc/dut/cmd

# Sinais internos do ctrl
add wave -divider "Ctrl - displays e data"
add wave -hex /tb_calc/dut/ctrl/data
add wave -hex /tb_calc/dut/ctrl/displays

# Mostra os displays decodificados
add wave -divider "Displays individuais (segments)"
add wave -hex /tb_calc/dut/ctrl/displays[0]
add wave -hex /tb_calc/dut/ctrl/displays[1]
add wave -hex /tb_calc/dut/ctrl/displays[2]
add wave -hex /tb_calc/dut/ctrl/displays[3]
add wave -hex /tb_calc/dut/ctrl/displays[4]
add wave -hex /tb_calc/dut/ctrl/displays[5]
add wave -hex /tb_calc/dut/ctrl/dis_
