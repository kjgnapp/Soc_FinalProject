/******************************************************************************
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/
/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"

#include "xparameters.h"
#include "xil_io.h"

#include "xgpio.h"
#include "sleep.h"

/************************** Constant Definitions *****************************/
#define GPIO_ONE  XPAR_XGPIO_0_BASEADDR 
#define LED_ON  0xAA
#define LED_OFF 0x55
#define LED_ALL_OFF 0x00

#define TCSR0_OFFSET   0x00  // Control/Status Register 0
#define TLR0_OFFSET    0x04  // Load Register 0 (Period)
#define TCR0_OFFSET    0x08  // Timer Counter Register 0

#define TCSR1_OFFSET   0x10  // Control/Status Register 1
#define TLR1_OFFSET    0x14  // Load Register 1 (Duty Cycle)
#define TCR1_OFFSET    0x18  // Timer Counter Register 1

#define PWM_ENABLE     0b01010000100
#define PWM_LOAD       0b100000

#define LED_CTL_BASE XPAR_APB_LED_CTL_0_BASEADDR
#define LED_REG_OFFSET 0x00  // likely register offset for LED[7:0]

#define TIMER_BASEADDR XPAR_AXI_TIMER_0_BASEADDR

#define MAX_COUNT 0xFFFFFFFF

#define AXI_CLOCK_PERIOD XPAR_XTMRCTR_0_CLOCK_FREQUENCY

/************************** Function Prototypes ******************************/

int SystemInit(void);
int predict(int start_y, int dir_y, int width, int height);
int mod(int a, int b);
void start_pwm_beep();

/************************** Variable Definitions *****************************/
XGpio Gpio1; /* The Instance of the GPIO Driver */


int main()
{
    init_platform();

    // Task 1
    print("Hello World\n\r");
    print("Successfully ran Hello World application\n\r");

    start_pwm_beep();

    sleep(1);

    // Task 3

    int Status = XST_SUCCESS;

    Status = SystemInit();

    if(Status == XST_FAILURE)
    {
        print("System init failed\r\n");
        while(1);
    }

    print("Starting Game\r\n");
    sleep(1);

    const u8 GAME_START = 0b10000;

    Status = Xil_SecureOut32(XPAR_MYIP_PONG2_0_BASEADDR + (4 * 0), GAME_START);

    if(Status == XST_FAILURE)
    {
        print("Address pong Write failed\r\n");
        while(1);
    }


    int ball_predict = 0;

    while (1) {

        // read from gpio
        u32 paddle_data = XGpio_DiscreteRead(&Gpio1, 1);

        // write value to paddle register

        u32 reg2_val = Xil_In32(XPAR_MYIP_PONG2_0_BASEADDR + (4 * 2));

        int ball_x = reg2_val & 0x3F;
        int ball_y = (reg2_val >> 6) & 0x3F;
        int paddle_top = (reg2_val >> 12) & 0x3F;
        int paddle_bot = (reg2_val >> 18) & 0x3F;

        int paddle_mid = ((paddle_top + paddle_bot)/2);
        int dir_y = (reg2_val >> 25) & 0x01;


        if(ball_x == 0) {
            ball_predict = predict(ball_y, dir_y, 40,30);
        }
        if (paddle_mid > ball_predict) {
            Xil_Out32(XPAR_MYIP_PONG2_0_BASEADDR + (4 * 0), GAME_START | paddle_data | 0b1000);
        }
        else if (paddle_mid < ball_predict) {
            Xil_Out32(XPAR_MYIP_PONG2_0_BASEADDR + (4 * 0), GAME_START | paddle_data | 0b0100);
        }
        else {
            Xil_Out32(XPAR_MYIP_PONG2_0_BASEADDR + (4 * 0), GAME_START | paddle_data | 0b000);
        }


    }

    print("Exited Error\r\n");
    cleanup_platform();
    return 0;
}


//////////////////////f(x)///////////
int SystemInit(void)
{
    int Status = XST_SUCCESS;

	Status = XGpio_Initialize(&Gpio1, GPIO_ONE);
	if (Status != XST_SUCCESS) {
		xil_printf("Gpio Initialization Failed\r\n");
		return XST_FAILURE;
	}
    
    Status = XGpio_SelfTest(&Gpio1);
	if (Status != XST_SUCCESS) {
		xil_printf("Gpio self-test Failed\r\n");
		return XST_FAILURE;
	}

    return Status;
}

int mod(int a, int b) {
    int r = a % b;
    return r < 0 ? r + b : r;
}

int predict(int start_y, int dir_y, int width, int height) {
    int vertical_movement;
    
    if (dir_y == 1) { 
        vertical_movement = width;
    } else {
        vertical_movement = -width;
    }
    
    int q = mod(vertical_movement, 2 * height);
    int final_pos = start_y + q;

    if (final_pos >= height) {
        final_pos = height - (final_pos - height);
    } else if (final_pos < 0) {
        final_pos = -final_pos;
    }
    
    return final_pos;
}

void debug_dump_timer_registers() {
    xil_printf("\n=== AXI Timer Register Dump ===\r\n");
    xil_printf("TCSR0  (0x00): 0x%08X\r\n", Xil_In32(TIMER_BASEADDR + TCSR0_OFFSET));
    xil_printf("TLR0   (0x04): 0x%08X\r\n", Xil_In32(TIMER_BASEADDR + TLR0_OFFSET));
    xil_printf("TCR0   (0x08): 0x%08X\r\n", Xil_In32(TIMER_BASEADDR + TCR0_OFFSET));

    xil_printf("TCSR1  (0x10): 0x%08X\r\n", Xil_In32(TIMER_BASEADDR + TCSR1_OFFSET));
    xil_printf("TLR1   (0x14): 0x%08X\r\n", Xil_In32(TIMER_BASEADDR + TLR1_OFFSET));
    xil_printf("TCR1   (0x18): 0x%08X\r\n", Xil_In32(TIMER_BASEADDR + TCR1_OFFSET));
    xil_printf("================================\r\n\n");
}


void start_pwm_beep() {
    xil_printf("Initializing PWM output (active-high LED)...\r\n");

    const u32 TLR0_VAL = 99999998;   // 1 Hz period (Timer 0)
    const u32 TLR1_VAL = 49999998;   // 50% ON time (Timer 1)

    // Disable both timers before configuration
    Xil_Out32(TIMER_BASEADDR + TCSR0_OFFSET, 0x0);
    Xil_Out32(TIMER_BASEADDR + TCSR1_OFFSET, 0x0);

    // Load period and high time
    Xil_Out32(TIMER_BASEADDR + TLR0_OFFSET, TLR0_VAL);
    Xil_Out32(TIMER_BASEADDR + TLR1_OFFSET, TLR1_VAL);

    // Configure PWM mode: LOAD | ARHT | PWMA0 | GENT | UDT (down count)
    u32 tcsr_common = (1 << 5) | (1 << 4) | (1 << 9) | (1 << 2) | (1 << 1);  // LOAD, ARHT, PWMA0, GENT, UDT

    Xil_Out32(TIMER_BASEADDR + TCSR0_OFFSET, tcsr_common);
    Xil_Out32(TIMER_BASEADDR + TCSR1_OFFSET, tcsr_common);

    // Clear LOAD and start timers: ENT | ARHT | PWMA0 | GENT | UDT
    tcsr_common = (1 << 7) | (1 << 4) | (1 << 9) | (1 << 2) | (1 << 1);  // ENT, ARHT, PWMA0, GENT, UDT

    Xil_Out32(TIMER_BASEADDR + TCSR0_OFFSET, tcsr_common);
    Xil_Out32(TIMER_BASEADDR + TCSR1_OFFSET, tcsr_common);

    debug_dump_timer_registers();
}




