-- (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- (c) Copyright 2022-2025 Advanced Micro Devices, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of AMD and is protected under U.S. and international copyright
-- and other intellectual property laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- AMD, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) AMD shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or AMD had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- AMD products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of AMD products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:module_ref:Pong_Top2:1.0
-- IP Revision: 1

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY design_6_Pong_Top2_0_0 IS
  PORT (
    i_Clk : IN STD_LOGIC;
    i_Col_Count : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    i_Row_Count : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    i_Game_Start : IN STD_LOGIC;
    i_Paddle_Up_P1 : IN STD_LOGIC;
    i_Paddle_Dn_P1 : IN STD_LOGIC;
    i_Paddle_Up_P2 : IN STD_LOGIC;
    i_Paddle_Dn_P2 : IN STD_LOGIC;
    top_ball_X : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    top_ball_Y : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    Dir_X : OUT STD_LOGIC;
    Dir_Y : OUT STD_LOGIC;
    Paddle_Y_Top : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    Paddle_Y_Bot : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    o_Red_Video : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    o_Blu_Video : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    o_Grn_Video : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
  );
END design_6_Pong_Top2_0_0;

ARCHITECTURE design_6_Pong_Top2_0_0_arch OF design_6_Pong_Top2_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF design_6_Pong_Top2_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT Pong_Top2 IS
    GENERIC (
      g_Video_Width : INTEGER;
      g_Total_Cols : INTEGER;
      g_Total_Rows : INTEGER;
      g_Active_Cols : INTEGER;
      g_Active_Rows : INTEGER
    );
    PORT (
      i_Clk : IN STD_LOGIC;
      i_Col_Count : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      i_Row_Count : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      i_Game_Start : IN STD_LOGIC;
      i_Paddle_Up_P1 : IN STD_LOGIC;
      i_Paddle_Dn_P1 : IN STD_LOGIC;
      i_Paddle_Up_P2 : IN STD_LOGIC;
      i_Paddle_Dn_P2 : IN STD_LOGIC;
      top_ball_X : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      top_ball_Y : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      Dir_X : OUT STD_LOGIC;
      Dir_Y : OUT STD_LOGIC;
      Paddle_Y_Top : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      Paddle_Y_Bot : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      o_Red_Video : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      o_Blu_Video : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      o_Grn_Video : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
  END COMPONENT Pong_Top2;
  ATTRIBUTE X_CORE_INFO : STRING;
  ATTRIBUTE X_CORE_INFO OF design_6_Pong_Top2_0_0_arch: ARCHITECTURE IS "Pong_Top2,Vivado 2024.2";
  ATTRIBUTE CHECK_LICENSE_TYPE : STRING;
  ATTRIBUTE CHECK_LICENSE_TYPE OF design_6_Pong_Top2_0_0_arch : ARCHITECTURE IS "design_6_Pong_Top2_0_0,Pong_Top2,{}";
  ATTRIBUTE CORE_GENERATION_INFO : STRING;
  ATTRIBUTE CORE_GENERATION_INFO OF design_6_Pong_Top2_0_0_arch: ARCHITECTURE IS "design_6_Pong_Top2_0_0,Pong_Top2,{x_ipProduct=Vivado 2024.2,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=Pong_Top2,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VHDL,x_ipSimLanguage=MIXED,g_Video_Width=3,g_Total_Cols=800,g_Total_Rows=525,g_Active_Cols=640,g_Active_Rows=480}";
  ATTRIBUTE IP_DEFINITION_SOURCE : STRING;
  ATTRIBUTE IP_DEFINITION_SOURCE OF design_6_Pong_Top2_0_0_arch: ARCHITECTURE IS "module_ref";
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_MODE : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF i_Clk: SIGNAL IS "xilinx.com:signal:clock:1.0 i_Clk CLK";
  ATTRIBUTE X_INTERFACE_MODE OF i_Clk: SIGNAL IS "slave i_Clk";
  ATTRIBUTE X_INTERFACE_PARAMETER OF i_Clk: SIGNAL IS "XIL_INTERFACENAME i_Clk, FREQ_HZ 25000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_6_clk_100MHz, INSERT_VIP 0";
BEGIN
  U0 : Pong_Top2
    GENERIC MAP (
      g_Video_Width => 3,
      g_Total_Cols => 800,
      g_Total_Rows => 525,
      g_Active_Cols => 640,
      g_Active_Rows => 480
    )
    PORT MAP (
      i_Clk => i_Clk,
      i_Col_Count => i_Col_Count,
      i_Row_Count => i_Row_Count,
      i_Game_Start => i_Game_Start,
      i_Paddle_Up_P1 => i_Paddle_Up_P1,
      i_Paddle_Dn_P1 => i_Paddle_Dn_P1,
      i_Paddle_Up_P2 => i_Paddle_Up_P2,
      i_Paddle_Dn_P2 => i_Paddle_Dn_P2,
      top_ball_X => top_ball_X,
      top_ball_Y => top_ball_Y,
      Dir_X => Dir_X,
      Dir_Y => Dir_Y,
      Paddle_Y_Top => Paddle_Y_Top,
      Paddle_Y_Bot => Paddle_Y_Bot,
      o_Red_Video => o_Red_Video,
      o_Blu_Video => o_Blu_Video,
      o_Grn_Video => o_Grn_Video
    );
END design_6_Pong_Top2_0_0_arch;
