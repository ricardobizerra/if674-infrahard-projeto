onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /cpu/PC/Saida
add wave -noupdate -radix decimal /cpu/CTRL/STATE
add wave -noupdate /cpu/reset
add wave -noupdate -radix decimal /cpu/CTRL/COUNTER
add wave -noupdate -radix decimal /cpu/CTRL/OPCODE
add wave -noupdate -radix unsigned /cpu/CTRL/FUNCT
add wave -noupdate -radix unsigned -childformat {{/cpu/BREG/Cluster(0) -radix unsigned} {/cpu/BREG/Cluster(1) -radix unsigned} {/cpu/BREG/Cluster(2) -radix unsigned} {/cpu/BREG/Cluster(3) -radix unsigned} {/cpu/BREG/Cluster(4) -radix unsigned} {/cpu/BREG/Cluster(5) -radix unsigned} {/cpu/BREG/Cluster(6) -radix unsigned} {/cpu/BREG/Cluster(7) -radix unsigned} {/cpu/BREG/Cluster(8) -radix unsigned} {/cpu/BREG/Cluster(9) -radix unsigned} {/cpu/BREG/Cluster(10) -radix unsigned} {/cpu/BREG/Cluster(11) -radix unsigned} {/cpu/BREG/Cluster(12) -radix unsigned} {/cpu/BREG/Cluster(13) -radix unsigned} {/cpu/BREG/Cluster(14) -radix unsigned} {/cpu/BREG/Cluster(15) -radix unsigned} {/cpu/BREG/Cluster(16) -radix unsigned} {/cpu/BREG/Cluster(17) -radix unsigned} {/cpu/BREG/Cluster(18) -radix unsigned} {/cpu/BREG/Cluster(19) -radix unsigned} {/cpu/BREG/Cluster(20) -radix unsigned} {/cpu/BREG/Cluster(21) -radix unsigned} {/cpu/BREG/Cluster(22) -radix unsigned} {/cpu/BREG/Cluster(23) -radix unsigned} {/cpu/BREG/Cluster(24) -radix unsigned} {/cpu/BREG/Cluster(25) -radix unsigned} {/cpu/BREG/Cluster(26) -radix unsigned} {/cpu/BREG/Cluster(27) -radix unsigned} {/cpu/BREG/Cluster(28) -radix unsigned} {/cpu/BREG/Cluster(29) -radix unsigned} {/cpu/BREG/Cluster(30) -radix unsigned} {/cpu/BREG/Cluster(31) -radix unsigned}} -subitemconfig {/cpu/BREG/Cluster(0) {-height 15 -radix unsigned} /cpu/BREG/Cluster(1) {-height 15 -radix unsigned} /cpu/BREG/Cluster(2) {-height 15 -radix unsigned} /cpu/BREG/Cluster(3) {-height 15 -radix unsigned} /cpu/BREG/Cluster(4) {-height 15 -radix unsigned} /cpu/BREG/Cluster(5) {-height 15 -radix unsigned} /cpu/BREG/Cluster(6) {-height 15 -radix unsigned} /cpu/BREG/Cluster(7) {-height 15 -radix unsigned} /cpu/BREG/Cluster(8) {-height 15 -radix unsigned} /cpu/BREG/Cluster(9) {-height 15 -radix unsigned} /cpu/BREG/Cluster(10) {-height 15 -radix unsigned} /cpu/BREG/Cluster(11) {-height 15 -radix unsigned} /cpu/BREG/Cluster(12) {-height 15 -radix unsigned} /cpu/BREG/Cluster(13) {-height 15 -radix unsigned} /cpu/BREG/Cluster(14) {-height 15 -radix unsigned} /cpu/BREG/Cluster(15) {-height 15 -radix unsigned} /cpu/BREG/Cluster(16) {-height 15 -radix unsigned} /cpu/BREG/Cluster(17) {-height 15 -radix unsigned} /cpu/BREG/Cluster(18) {-height 15 -radix unsigned} /cpu/BREG/Cluster(19) {-height 15 -radix unsigned} /cpu/BREG/Cluster(20) {-height 15 -radix unsigned} /cpu/BREG/Cluster(21) {-height 15 -radix unsigned} /cpu/BREG/Cluster(22) {-height 15 -radix unsigned} /cpu/BREG/Cluster(23) {-height 15 -radix unsigned} /cpu/BREG/Cluster(24) {-height 15 -radix unsigned} /cpu/BREG/Cluster(25) {-height 15 -radix unsigned} /cpu/BREG/Cluster(26) {-height 15 -radix unsigned} /cpu/BREG/Cluster(27) {-height 15 -radix unsigned} /cpu/BREG/Cluster(28) {-height 15 -radix unsigned} /cpu/BREG/Cluster(29) {-height 15 -radix unsigned} /cpu/BREG/Cluster(30) {-height 15 -radix unsigned} /cpu/BREG/Cluster(31) {-height 15 -radix unsigned}} /cpu/BREG/Cluster
add wave -noupdate /cpu/BREG/RegWrite
add wave -noupdate /cpu/M_REG_DST/sel
add wave -noupdate -radix unsigned /cpu/M_REG_DST/out
add wave -noupdate -radix decimal /cpu/ALU/S
add wave -noupdate -radix decimal /cpu/ALU/A
add wave -noupdate -radix decimal /cpu/ALU/B
add wave -noupdate /cpu/clk
add wave -noupdate /cpu/MDR/Saida
add wave -noupdate /cpu/ALUReg/Clk
add wave -noupdate /cpu/ALUReg/Reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5421 ps} 0}
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
WaveRestoreZoom {5140 ps} {6140 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue HiZ -period 100ps -dutycycle 50 -starttime 0ps -endtime 10000ps sim:/cpu/clk 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 10000ps sim:/cpu/reset 
wave edit change_value -start 0ps -end 100ps -value 1 Edit:/cpu/reset 
wave edit change_value -start 5900ps -end 6000ps -value 1 Edit:/cpu/reset 
wave edit change_value -start 5900ps -end 6000ps -value 0 Edit:/cpu/reset 
WaveCollapseAll -1
wave clipboard restore
