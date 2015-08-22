-- testbench for fall 2007 final q3
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity circuit_testbench is
end entity;

architecture stimulus of circuit_testbench is
  component circuit is
    port(clk, a, b, en : in std_logic;
         y : out std_logic);
  end component;

  signal in_clk : std_logic := '0'; --must initialize for clk_gen
  signal in_a, in_b, in_en, out_y : std_logic;

  constant HALF_CLK_PERIOD : time := 5ns; --assume HALF_CLK_PERIOD > TIME_AFTER_EDGE
  constant TIME_AFTER_EDGE : time := 2ns;
begin
  DUT : circuit port map(clk => in_clk, a => in_a, b => in_b, en => in_en, y => out_y);

  clk_gen : process
  begin
    wait for HALF_CLK_PERIOD;
    in_clk <= not in_clk;
  end process;

  test : process
  begin
    in_en <= '0';
    in_a <= '0';
    in_b <= '0';
    wait for TIME_AFTER_EDGE;
    assert(out_y = 'Z')
      report "expected y=Z (high impedance) while en=0"
      severity error;
    wait for TIME_AFTER_EDGE;
    wait until rising_edge(in_clk);
    in_en <= '1';
    wait for TIME_AFTER_EDGE;
    assert(out_y = '0')
      report "expected y=0"
      severity error;

    in_a <= '1';
    in_b <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_y = '1')
      report "expected y=1"
      severity error;

    in_a <= '1';
    in_b <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_y = '0')
      report "expected y=0"
      severity error;

    in_a <= '0';
    in_b <= '1';
    wait for TIME_AFTER_EDGE;
    assert(out_y = '1')
      report "expected y=1"
      severity error;

    report "Tests completed"
      severity note;
    wait; --done

  end process;
end architecture;
