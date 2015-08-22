-- testbench for summer 2015 assignment 3 question 7
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity timer_testbench is
end entity;

architecture stimulus of timer_testbench is
  component timer is
    port(clk, stb : in std_logic;
         ts, tl : out std_logic);
  end component;

  signal in_clk : std_logic := '0'; --must be initialized for clk_gen process to work
  signal in_stb, out_ts, out_tl : std_logic;

  constant HALF_CLK_PERIOD : time := 5ns;
  constant STB_LOW_TIME    : time := 3ns; --test assumes STB_LOW_TIME < HALF_CLK_PERIOD

  constant TS_HIGH : integer := 4; --number of cycles after STB goes high for TS to go high
  constant TL_HIGH : integer := 7; --number of cycles after STB goes high for TL to go high
  constant LOOP_LIMIT : integer := 10; --for checking that TS and TL stay high for a few more cycles
begin
  DUT : timer port map(clk => in_clk, stb => in_stb,
                       ts => out_ts, tl => out_tl);

  clk_gen : process
  begin
    in_clk <= not in_clk;
    wait for HALF_CLK_PERIOD;
  end process;

  test : process
  begin
    in_stb <= '1';
    wait until rising_edge(in_clk);
    wait for STB_LOW_TIME;
    in_stb <= '0';
    wait for STB_LOW_TIME;
    in_stb <= '1';
    wait until rising_edge(in_clk);
    
    for i in 0 to (TS_HIGH-1) loop
      wait until rising_edge(in_clk);
      assert(out_ts = '0')
        report "ts was not 0"
        severity error;
      assert(out_tl = '0')
        report "tl was not 0"
        severity error;
    end loop;
    for i in TS_HIGH to (TL_HIGH-1) loop
      wait until rising_edge(in_clk);
      assert(out_ts = '1')
        report "ts was not 1"
        severity error;
      assert(out_tl = '0')
        report "tl was not 0"
        severity error;
    end loop;
    for i in TL_HIGH to LOOP_LIMIT loop
      wait until rising_edge(in_clk);
      assert(out_ts = '1')
        report "ts was not 1"
        severity error;
      assert(out_tl = '1')
        report "tl was not 1"
        severity error;
    end loop;

    wait for STB_LOW_TIME;
    in_stb <= '0';
    wait for STB_LOW_TIME;
    in_stb <= '1';
    for i in 0 to (TL_HIGH-2) loop
      wait until rising_edge(in_clk);
    end loop;

    --if STB goes low again before TL goes high, the count should reset
    wait for STB_LOW_TIME;
    in_stb <= '0';
    wait for STB_LOW_TIME;
    in_stb <= '1';
    wait until rising_edge(in_clk);

    for i in 0 to (TS_HIGH-1) loop
      wait until rising_edge(in_clk);
      assert(out_ts = '0')
        report "ts was not 0"
        severity error;
      assert(out_tl = '0')
        report "tl was not 0"
        severity error;
    end loop;
    for i in TS_HIGH to (TL_HIGH-1) loop
      wait until rising_edge(in_clk);
      assert(out_ts = '1')
        report "ts was not 1"
        severity error;
      assert(out_tl = '0')
        report "tl was not 0"
        severity error;
    end loop;
    for i in TL_HIGH to LOOP_LIMIT loop
      wait until rising_edge(in_clk);
      assert(out_ts = '1')
        report "ts was not 1"
        severity error;
      assert(out_tl = '1')
        report "tl was not 1"
        severity error;
    end loop;

    report "Tests completed without errors"
      severity note;
    wait; --done
  end process;
end architecture;
