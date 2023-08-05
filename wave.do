onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal -childformat {{/cpu/BREG/Cluster(0) -radix decimal} {/cpu/BREG/Cluster(1) -radix decimal} {/cpu/BREG/Cluster(2) -radix decimal} {/cpu/BREG/Cluster(3) -radix decimal} {/cpu/BREG/Cluster(4) -radix decimal} {/cpu/BREG/Cluster(5) -radix decimal} {/cpu/BREG/Cluster(6) -radix decimal} {/cpu/BREG/Cluster(7) -radix decimal} {/cpu/BREG/Cluster(8) -radix decimal} {/cpu/BREG/Cluster(9) -radix decimal} {/cpu/BREG/Cluster(10) -radix decimal} {/cpu/BREG/Cluster(11) -radix decimal} {/cpu/BREG/Cluster(12) -radix decimal} {/cpu/BREG/Cluster(13) -radix decimal} {/cpu/BREG/Cluster(14) -radix decimal} {/cpu/BREG/Cluster(15) -radix decimal} {/cpu/BREG/Cluster(16) -radix decimal} {/cpu/BREG/Cluster(17) -radix decimal} {/cpu/BREG/Cluster(18) -radix decimal} {/cpu/BREG/Cluster(19) -radix decimal} {/cpu/BREG/Cluster(20) -radix decimal} {/cpu/BREG/Cluster(21) -radix decimal} {/cpu/BREG/Cluster(22) -radix decimal} {/cpu/BREG/Cluster(23) -radix decimal} {/cpu/BREG/Cluster(24) -radix decimal} {/cpu/BREG/Cluster(25) -radix decimal} {/cpu/BREG/Cluster(26) -radix decimal} {/cpu/BREG/Cluster(27) -radix decimal} {/cpu/BREG/Cluster(28) -radix decimal} {/cpu/BREG/Cluster(29) -radix decimal} {/cpu/BREG/Cluster(30) -radix decimal} {/cpu/BREG/Cluster(31) -radix decimal}} -subitemconfig {/cpu/BREG/Cluster(0) {-height 17 -radix decimal} /cpu/BREG/Cluster(1) {-height 17 -radix decimal} /cpu/BREG/Cluster(2) {-height 17 -radix decimal} /cpu/BREG/Cluster(3) {-height 17 -radix decimal} /cpu/BREG/Cluster(4) {-height 17 -radix decimal} /cpu/BREG/Cluster(5) {-height 17 -radix decimal} /cpu/BREG/Cluster(6) {-height 17 -radix decimal} /cpu/BREG/Cluster(7) {-height 17 -radix decimal} /cpu/BREG/Cluster(8) {-height 17 -radix decimal} /cpu/BREG/Cluster(9) {-height 17 -radix decimal} /cpu/BREG/Cluster(10) {-height 17 -radix decimal} /cpu/BREG/Cluster(11) {-height 17 -radix decimal} /cpu/BREG/Cluster(12) {-height 17 -radix decimal} /cpu/BREG/Cluster(13) {-height 17 -radix decimal} /cpu/BREG/Cluster(14) {-height 17 -radix decimal} /cpu/BREG/Cluster(15) {-height 17 -radix decimal} /cpu/BREG/Cluster(16) {-height 17 -radix decimal} /cpu/BREG/Cluster(17) {-height 17 -radix decimal} /cpu/BREG/Cluster(18) {-height 17 -radix decimal} /cpu/BREG/Cluster(19) {-height 17 -radix decimal} /cpu/BREG/Cluster(20) {-height 17 -radix decimal} /cpu/BREG/Cluster(21) {-height 17 -radix decimal} /cpu/BREG/Cluster(22) {-height 17 -radix decimal} /cpu/BREG/Cluster(23) {-height 17 -radix decimal} /cpu/BREG/Cluster(24) {-height 17 -radix decimal} /cpu/BREG/Cluster(25) {-height 17 -radix decimal} /cpu/BREG/Cluster(26) {-height 17 -radix decimal} /cpu/BREG/Cluster(27) {-height 17 -radix decimal} /cpu/BREG/Cluster(28) {-height 17 -radix decimal} /cpu/BREG/Cluster(29) {-height 17 -radix decimal} /cpu/BREG/Cluster(30) {-height 17 -radix decimal} /cpu/BREG/Cluster(31) {-height 17 -radix decimal}} /cpu/BREG/Cluster
add wave -noupdate /cpu/MEM/Dataout
add wave -noupdate -radix decimal /cpu/PC/Saida
add wave -noupdate /cpu/clk
add wave -noupdate /cpu/reset
add wave -noupdate /cpu/ALU/A
add wave -noupdate /cpu/ALU/B
add wave -noupdate /cpu/ALU/S
add wave -noupdate /cpu/M_ALU_SRCA/out
add wave -noupdate /cpu/M_ALU_SRCA/PC
add wave -noupdate /cpu/CTRL/STATE
add wave -noupdate /cpu/CTRL/PC_write
add wave -noupdate /cpu/M_PC_SRC/out
add wave -noupdate /cpu/clk
add wave -noupdate /cpu/reset
add wave -noupdate -radix decimal /cpu/CTRL/OPCODE
add wave -noupdate -radix binary /cpu/CTRL/FUNCT
add wave -noupdate /cpu/CTRL/COUNTER
add wave -noupdate /cpu/clk
add wave -noupdate /cpu/reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2 ps} 0}
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
WaveRestoreZoom {0 ps} {1 ns}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue HiZ -period 100ps -dutycycle 50 -starttime 0ps -endtime 10000ps sim:/cpu/clk 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 10000ps sim:/cpu/reset 
wave edit change_value -start 0ps -end 100ps -value 1 Edit:/cpu/reset 
WaveCollapseAll -1
wave clipboard restore
