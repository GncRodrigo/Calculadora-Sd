onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_display/data
add wave -noupdate /tb_display/a
add wave -noupdate /tb_display/b
add wave -noupdate /tb_display/c
add wave -noupdate /tb_display/d
add wave -noupdate /tb_display/e
add wave -noupdate /tb_display/f
add wave -noupdate /tb_display/g
add wave -noupdate /tb_display/dp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {377768 ns} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1050 us}
view wave 
WaveCollapseAll -1
