-The Quartus project is inside of the "quartus" directory, and it's called "microprocessador.qpf".

-The "progmem.mif" file is a Fibonacci sequence. 

-To test in the board, it's necessary to substitute 2 lines in the "clk10Hz.vhd" component (code already there, commented), since the
clock in the board is simply too high, this is necessary to make debugging it visible. 
