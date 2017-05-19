onerror {quit -f}
vlib work
vlog -work work memtest.vo
vlog -work work memtest.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.memtest_vlg_vec_tst
vcd file -direction memtest.msim.vcd
vcd add -internal memtest_vlg_vec_tst/*
vcd add -internal memtest_vlg_vec_tst/i1/*
add wave /*
run -all
