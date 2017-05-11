onerror {quit -f}
vlib work
vlog -work work microprocessador.vo
vlog -work work microprocessador.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.microprocessador_vlg_vec_tst
vcd file -direction microprocessador.msim.vcd
vcd add -internal microprocessador_vlg_vec_tst/*
vcd add -internal microprocessador_vlg_vec_tst/i1/*
add wave /*
run -all
