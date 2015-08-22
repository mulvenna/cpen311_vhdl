-- testbench for summer 2008 midterm q4
library IEEE;
use IEEE.std_logic_1164.all;

entity onehot_fsm_testbench is
end entity;

architecture stimulus of onehot_fsm_testbench is
  component onehot_fsm is
    port(reset, clk, w : in std_logic;
         z : out std_logic);
  end component;
  
  signal in_clk : std_logic := '0'; --must initialize for clk_gen
  signal in_reset, in_w, out_z : std_logic;
  
  constant HALF_CLK_PERIOD : time := 5ns; --assume HALF_CLK_PERIOD > TIME_AFTER_EDGE
  constant TIME_AFTER_EDGE : time := 2ns;
begin
  DUT : onehot_fsm port map(reset => in_reset, clk => in_clk, w => in_w, z => out_z);

  clk_gen : process
  begin
    wait for HALF_CLK_PERIOD;
    in_clk <= not in_clk;
  end process;

  test : process
  begin
    in_reset <= '1';
    wait for TIME_AFTER_EDGE;
    in_reset <= '0';
    wait for TIME_AFTER_EDGE;
    assert(out_z = '1')
      report "state S0 with z=1 expected after async reset"
      severity error;

    in_w <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_z = '1')
      report "expected state S0 with z=1"
      severity error;

    in_w <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_z = '0')
      report "expected state S1 with z=0"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_z = '1')
      report "expected state S2 with z=1"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_z = '1')
      report "expected state S0 with z=1"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_z = '0')
      report "expected state S1 with z=0"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_z = '1')
      report "expected state S2 with z=1"
      severity error;
    in_w <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_z = '1')
      report "expected state S0 with z=1"
      severity error;

    in_w <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_z = '0')
      report "expected state S1 with z=0"
      severity error;
    in_w <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_z = '0')
      report "expected state S3 with z=0"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_z = '0')
      report "expected state S3 with z=0"
      severity error;
    in_w <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_z = '1')
      report "expected state S0 with z=1"
      severity error;

    report "Tests completed"
      severity note;
    wait; --done

  end process;
end architecture;
