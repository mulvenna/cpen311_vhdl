-- testbench for spring 2009 midterm q2
library IEEE;
use IEEE.std_logic_1164.all;

entity state_machine_testbench is
end entity;

architecture stimulus of state_machine_testbench is
  component state_machine is
    port(clk, x : in std_logic;
         y : out std_logic);  
  end component;
  
  signal in_clk : std_logic := '0'; --must initialize for clk_gen
  signal in_x, out_y : std_logic;
  
  constant HALF_CLK_PERIOD : time := 5ns; --assume HALF_CLK_PERIOD > TIME_AFTER_EDGE
  constant TIME_AFTER_EDGE : time := 2ns;
begin
  DUT : state_machine port map(clk => in_clk, x => in_x, y => out_y);

  clk_gen : process
  begin
    wait for HALF_CLK_PERIOD;
    in_clk <= not in_clk;
  end process;

  test : process
  begin
    --there is no reset or starting state specified in the problem statement
    --so we will have x=1 for 2 cycles to ensure that we arrive at a known
    --state (state B) before we begin our assertions
    in_x <= '1';
    wait until rising_edge(in_clk);
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state B
    assert(out_y = '0')
      report "expected state B with y=0"
      severity error;
 
    in_x <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state B
    assert(out_y = '0')
      report "expected state B with y=0"
      severity error;

    in_x <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state D
    assert(out_y = '1')
      report "expected state D with y=1"
      severity error;

    in_x <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state A
    assert(out_y = '1')
      report "expected state A with y=1"
      severity error;
    
    in_x <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state B
    assert(out_y = '0')
      report "expected state B with y=0"
      severity error;

    in_x <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state D
    assert(out_y = '1')
      report "expected state D with y=1"
      severity error;

    in_x <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state C
    assert(out_y = '0')
      report "expected state C with y=0"
      severity error;

    in_x <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state C
    assert(out_y = '0')
      report "expected state C with y=0"
      severity error;

    in_x <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state B
    assert(out_y = '0')
      report "expected state B with y=0"
      severity error;

    in_x <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state D
    assert(out_y = '1')
      report "expected state D with y=1"
      severity error;

    in_x <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state A
    assert(out_y = '1')
      report "expected state A with y=1"
      severity error;

    in_x <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --state D
    assert(out_y = '1')
      report "expected state D with y=1"
      severity error;

    report "Tests completed"
      severity note;
    wait; --done

  end process;
end architecture;
