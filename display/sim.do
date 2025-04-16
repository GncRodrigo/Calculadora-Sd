if {[file isdirectory work]} {vdel -all -lib work}
vlib work
vmap work work

vlog -work work ../../rtl/display.sv
vlog -work work tb_display.sv
vsim -voptargs=+acc work.tb_display

quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1

do wave.do
run 20ns

