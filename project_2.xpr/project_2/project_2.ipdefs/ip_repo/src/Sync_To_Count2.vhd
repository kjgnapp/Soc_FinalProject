-- This module will take incoming horizontal and veritcal sync pulses and
-- create Row and Column counters based on these syncs.
-- It will align the Row/Col counters to the output Sync pulses.
-- Useful for any module that needs to keep track of which Row/Col position we
-- are on in the middle of a frame.
--
-- timing analysis:
-- o_HSync, o_VSync, o_Col_Count and o_Row_Count delay **one** clock cycle
-- relative to i_HSync and i_VSync
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Sync_To_Count2 is
  generic (
    g_TOTAL_COLS : integer := 800;
    g_TOTAL_ROWS : integer := 525
    );
  port (
    i_Clk     : in std_logic;
    i_HSync   : in std_logic;
    i_VSync   : in std_logic;
  
    o_HSync     : out std_logic;
    o_VSync     : out std_logic;
    o_Col_Count : out std_logic_vector(9 downto 0);
    o_Row_Count : out std_logic_vector(9 downto 0)
    );
end entity Sync_To_Count2;

architecture RTL of Sync_To_Count2 is

  signal r_VSync, r_VSync2        : std_logic := '0';
  signal r_HSync, r_HSync2      : std_logic := '0';
  signal w_Frame_Start : std_logic;
  
  -- Make these unsigned counters (always positive)
  signal r_Col_Count : unsigned(9 downto 0) := (others => '0');
  signal r_Row_Count : unsigned(9 downto 0) := (others => '0');

begin

  -- Register syncs to align with output data.
  -- r_VSync, r_HSync delay one clock cycle
  -- o_VSync, o_HSync directly wire to r_VSync, r_HSync
  p_Reg_Syncs : process (i_Clk) is
  begin
    if rising_edge(i_Clk) then
      r_VSync <= i_VSync;
      r_HSync <= i_HSync;
      
      r_VSync2 <= r_VSync;
      r_HSync2 <= r_HSync;
    end if;
  end process p_Reg_Syncs; 


  -- Keep track of Row/Column counters.
  -- r_Col_Count, r_Row_Count delay one clock cycle
  -- o_Row_Count, o_Col_Count directly wire to r_Col_Count, r_Row_Count
  p_Row_Col_Count : process (i_Clk) is
  begin
    if rising_edge(i_Clk) then
      if w_Frame_Start = '1' then
        r_Col_Count <= (others => '0');
        r_Row_Count <= (others => '0');
      else
        if r_Col_Count = to_unsigned(g_TOTAL_COLS-1, r_Col_Count'length) then
          if r_Row_Count = to_unsigned(g_TOTAL_ROWS-1, r_Row_Count'length) then
            r_Row_Count <= (others => '0');
          else
            r_Row_Count <= r_Row_Count + 1;
          end if;
          r_Col_Count <= (others => '0');
        else
          r_Col_Count <= r_Col_Count + 1;
        end if;
      end if;
    end if;
  end process p_Row_Col_Count;
  
    
  -- Look for rising edge on Vertical Sync to reset the counters
  w_Frame_Start <= '1' when r_VSync2 = '0' and i_VSync = '1' else '0';
  
  o_VSync <= r_VSync2;
  o_HSync <= r_HSync2;

  o_Row_Count <= std_logic_vector(r_Row_Count);
  o_Col_Count <= std_logic_vector(r_Col_Count);
  
end architecture RTL;