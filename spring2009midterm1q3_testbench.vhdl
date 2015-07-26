-- testbench for spring 2008 midterm1 q3
library IEEE;
use IEEE.std_logic_1164.all;

entity circuit_testbench is
end entity;

architecture stimulus of circuit_testbench is
  component circuit is
  port(clk, reset, a, b, c, d, e : in std_logic;
       z : out std_logic);
  end component;
  
  signal in_clk : std_logic := '0'; --must initialize for clk_gen
  signal in_reset, in_a, in_b, in_c, in_d, in_e, out_z : std_logic;
  
  constant HALF_CLK_PERIOD : time := 5ns; --assume HALF_CLK_PERIOD > TIME_AFTER_EDGE
  constant TIME_AFTER_EDGE : time := 2ns;
begin
  DUT : circuit port map(clk => in_clk, reset => in_reset, a => in_a, 
                            b => in_b, c => in_c, d => in_d, e => in_e, 
                            z => out_z);

  clk_gen : process
  begin
    wait for HALF_CLK_PERIOD;
    in_clk <= not in_clk;
  end process;

  test : process
  begin
    --sync reset
    in_reset <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --flip-flops contain (from left to right on circuit diagram) 000
    assert(out_z = '0')
      report "expected z=0 after reset"
      severity error;
    in_reset <= '0';
    in_a <= '1';
    in_b <= '1';
    in_c <= '1';
    in_d <= '1';
    in_e <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --flip-flops contain 101
    assert(out_z = '1')
      report "expected z=1"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --flip-flops contain 111
    assert(out_z = '1')
      report "expected z=1"
      severity error;
    in_a <= '0';
    in_b <= '0';
    in_c <= '1';
    in_d <= '0';
    in_e <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --flip-flops contain 010
    assert(out_z = '0')
      report "expected z=0"
      severity error;
    in_a <= '1';
    in_b <= '1';
    in_c <= '0';
    in_d <= '1';
    in_e <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --flip-flops contain 010
    assert(out_z = '0')
      report "expected z=0"
      severity error;
    in_a <= '1';
    in_b <= '0';
    in_c <= '0';
    in_d <= '1';
    in_e <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --flip-flops contain 000
    assert(out_z = '0')
      report "expected z=0"
      severity error;

    report "Tests completed"
      severity note;
    wait; --done

  end process;
end architecture;
