transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+myip_pong2_1  -L xil_defaultlib -L xilinx_vip -L xpm -L util_vector_logic_v2_0_4 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.myip_pong2_1 xil_defaultlib.glbl

do {myip_pong2_1.udo}

run 1000ns

endsim

quit -force
