if {[file isdirectory work]} {vdel -all -lib work}
vlib work
vmap work work

vlog -work work calc_top.sv
vlog -work work display.sv
vlog -work work ctrl.sv
vlog -work work calc.sv


vlog -work work tb_calc.sv
vsim -voptargs=+acc work.tb_calc

quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1

do wave.do
run 100ns