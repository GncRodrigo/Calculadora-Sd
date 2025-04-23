# Limpa o que tiver na visualização atual
delete wave *

# Mostra sinais do testbench
add wave -divider "Testbench"
add wave -decimal sim:/tb_calc_top/clock
add wave -decimal sim:/tb_calc_top/reset
add wave -decimal sim:/tb_calc_top/cmd
add wave -binary sim:/tb_calc_top/status
add wave -decimal sim:/tb_calc_top/displays

# Mostra os displays
add wave -divider "Displays"
add wave -hex sim:/tb_calc_top/displays(0)
add wave -hex sim:/tb_calc_top/displays(1)
add wave -hex sim:/tb_calc_top/displays(2)
add wave -hex sim:/tb_calc_top/displays(3)
add wave -hex sim:/tb_calc_top/displays(4)
add wave -hex sim:/tb_calc_top/displays(5)
add wave -hex sim:/tb_calc_top/displays(6)
add wave -hex sim:/tb_calc_top/displays(7)

# Executa a simulação
run 100ns
