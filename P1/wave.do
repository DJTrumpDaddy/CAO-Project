onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Test Bench}
add wave -noupdate /sisc_tb/clk
add wave -noupdate /sisc_tb/rst_f
add wave -noupdate /sisc_tb/ir
add wave -noupdate -divider {Control Unit}
add wave -noupdate /sisc_tb/uut/ControlUnit/present_state
add wave -noupdate /sisc_tb/uut/ControlUnit/next_state
add wave -noupdate /sisc_tb/uut/ControlUnit/wb_sel
add wave -noupdate /sisc_tb/uut/ControlUnit/alu_op
add wave -noupdate /sisc_tb/uut/ControlUnit/rf_we
add wave -noupdate -divider {Register File}
add wave -noupdate {/sisc_tb/uut/RegisterFile/ram_array[6]}
add wave -noupdate {/sisc_tb/uut/RegisterFile/ram_array[5]}
add wave -noupdate {/sisc_tb/uut/RegisterFile/ram_array[4]}
add wave -noupdate {/sisc_tb/uut/RegisterFile/ram_array[3]}
add wave -noupdate {/sisc_tb/uut/RegisterFile/ram_array[2]}
add wave -noupdate {/sisc_tb/uut/RegisterFile/ram_array[1]}
add wave -noupdate -divider Mux4
add wave -noupdate /sisc_tb/uut/Mux4/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {946900 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 236
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
WaveRestoreZoom {0 ps} {988100 ps}
