-- testbench for summer 2015 midterm question 2
library IEEE;
use IEEE.std_logic_1164.all;

entity fsm_testbench is
end entity;

architecture stimulus of fsm_testbench is
  component fsm is
    port(a, en, clk, rst : in std_logic;
         f : out std_logic);
  end component;
  
  signal in_clk : std_logic := '0'; --must initialize for clk_gen to work
  signal in_a, in_en, in_rst, out_f : std_logic;
  
  constant HALF_CLK_PERIOD : time := 5ns; --assume HALF_CLK_PERIOD > TIME_AFTER_EDGE
  constant TIME_AFTER_EDGE : time := 2ns;
begin
  DUT : fsm port map(a => in_a, en => in_en, clk => in_clk, rst => in_rst, f => out_f);

  clk_gen : process
  begin
    wait for HALF_CLK_PERIOD;
    in_clk <= not in_clk;
  end process;

  test : process
  begin
    in_en <= '1';
    in_a <= '0';
    --async reset
    in_rst <= '1';
    wait for TIME_AFTER_EDGE;
    in_rst <= '0';
    wait for TIME_AFTER_EDGE;
    --state SA
    assert(out_f = '0')
      report "should be state SA with f=0"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state SA
    assert(out_f = '0')
      report "should be state SA with f=0"
      severity error;
    in_a <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state SB
    assert(out_f = '1')
      report "should be state SB with f=1"
      severity error;
    in_a <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state SA
    assert(out_f = '0')
      report "should be state SA with f=0"
      severity error;
    in_a <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state SB
    assert(out_f = '1')
      report "should be state SB with f=1"
      severity error;
    in_a <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state SC
    assert(out_f = '0')
      report "should be state SC with f=0"
      severity error;
    in_a <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state SB
    assert(out_f = '1')
      report "should be state SB with f=1"
      severity error;
    in_a <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state SA
    assert(out_f = '0')
      report "should be state SA with f=0"
      severity error;

    in_en <= '0';
    in_a <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state SA
    assert(out_f = '0')
      report "should be state SA with f=0"
      severity error;

    report "Tests completed"
      severity note;
    wait; --done
  end process;
end architecture;
