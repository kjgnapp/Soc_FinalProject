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

    sleep(1);

    start_pwm_beep();

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

void start_pwm_beep() {
    xil_printf("Initializing PWM output...\r\n");

    // Clear timer enable bits
    Xil_Out32(TIMER_BASEADDR + TCSR0_OFFSET, 0x00);
    Xil_Out32(TIMER_BASEADDR + TCSR1_OFFSET, 0x00);

    // Write and load timer register 
    u32 PWM_PERIOD = (MAX_COUNT - 600 + 2) * AXI_CLOCK_PERIOD;
    u32 PWM_HIGH_TIME = (MAX_COUNT - 50 + 2) * AXI_CLOCK_PERIOD;

    Xil_Out32(TIMER_BASEADDR + TLR0_OFFSET, PWM_PERIOD); // Period
    Xil_Out32(TIMER_BASEADDR + TLR1_OFFSET, PWM_HIGH_TIME); // High time

    Xil_Out32(TIMER_BASEADDR + TCSR0_OFFSET, PWM_LOAD);
    Xil_Out32(TIMER_BASEADDR + TCSR1_OFFSET, PWM_LOAD); 

    // Write timer enable bits
    Xil_Out32(TIMER_BASEADDR + TCSR0_OFFSET, PWM_ENABLE);
    Xil_Out32(TIMER_BASEADDR + TCSR1_OFFSET, PWM_ENABLE); 

    xil_printf("PWM signal now active on pwm0 pin.\r\n");
}
