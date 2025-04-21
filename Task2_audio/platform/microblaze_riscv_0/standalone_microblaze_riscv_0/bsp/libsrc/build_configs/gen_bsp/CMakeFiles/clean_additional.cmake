# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "")
  file(REMOVE_RECURSE
  "C:\\Users\\kurti\\Downloads\\Soc_FinalProject\\Task2_audio\\platform\\microblaze_riscv_0\\standalone_microblaze_riscv_0\\bsp\\include\\sleep.h"
  "C:\\Users\\kurti\\Downloads\\Soc_FinalProject\\Task2_audio\\platform\\microblaze_riscv_0\\standalone_microblaze_riscv_0\\bsp\\include\\xiltimer.h"
  "C:\\Users\\kurti\\Downloads\\Soc_FinalProject\\Task2_audio\\platform\\microblaze_riscv_0\\standalone_microblaze_riscv_0\\bsp\\include\\xtimer_config.h"
  "C:\\Users\\kurti\\Downloads\\Soc_FinalProject\\Task2_audio\\platform\\microblaze_riscv_0\\standalone_microblaze_riscv_0\\bsp\\lib\\libxiltimer.a"
  )
endif()
