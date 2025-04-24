# Limpa o que tiver na visualização atual
delete wave *

# Mostra sinais do testbench
add wave -divider "Testbench"
#coloca EA para checar
add wave -binary sim:/tb_calc_top/EA
add wave -binary sim:/tb_calc_top/PE
add wave -decimal sim:/tb_calc_top/clock
add wave -decimal sim:/tb_calc_top/reset
add wave -binary sim:/tb_calc_top/cmd
add wave -binary sim:/tb_calc_top/status
add wave -binary sim:/tb_calc_top/displays

# Mostra os displays


# Executa a simulação
run 100ns
