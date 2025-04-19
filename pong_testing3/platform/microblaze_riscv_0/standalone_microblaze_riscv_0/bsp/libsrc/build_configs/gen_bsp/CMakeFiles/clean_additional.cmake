# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "")
  file(REMOVE_RECURSE
  "C:\\VivadoProjects\\pong_testing3\\platform\\microblaze_riscv_0\\standalone_microblaze_riscv_0\\bsp\\include\\sleep.h"
  "C:\\VivadoProjects\\pong_testing3\\platform\\microblaze_riscv_0\\standalone_microblaze_riscv_0\\bsp\\include\\xiltimer.h"
  "C:\\VivadoProjects\\pong_testing3\\platform\\microblaze_riscv_0\\standalone_microblaze_riscv_0\\bsp\\include\\xtimer_config.h"
  "C:\\VivadoProjects\\pong_testing3\\platform\\microblaze_riscv_0\\standalone_microblaze_riscv_0\\bsp\\lib\\libxiltimer.a"
  )
endif()
