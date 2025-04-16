onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ctrl/clock
add wave -noupdate /tb_ctrl/reset
add wave -noupdate /tb_ctrl/dig
add wave -noupdate /tb_ctrl/pos
add wave -noupdate -expand /tb_ctrl/a
add wave -noupdate /tb_ctrl/b
add wave -noupdate /tb_ctrl/c
add wave -noupdate /tb_ctrl/d
add wave -noupdate /tb_ctrl/e
add wave -noupdate /tb_ctrl/f
add wave -noupdate /tb_ctrl/g
add wave -noupdate /tb_ctrl/dp
add wave -noupdate /tb_ctrl/master0/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {18500 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {105 ns}
