-- testbench for fall 2007 final q4
library IEEE;
use IEEE.std_logic_1164.all;

entity seq_detector_testbench is
end entity;

architecture stimulus of seq_detector_testbench is
  component seq_detector is
    port(clk, serial_in : in std_logic;
         z : out std_logic);
  end component;

  signal in_clk : std_logic := '0'; --must initialize for clk_gen
  signal in_serial_in, out_z : std_logic;

  constant HALF_CLK_PERIOD : time := 5ns; --assume HALF_CLK_PERIOD > TIME_AFTER_EDGE
  constant TIME_AFTER_EDGE : time := 2ns;
begin
  DUT : seq_detector port map(clk => in_clk, serial_in => in_serial_in, z => out_z);

  clk_gen : process
  begin
    wait for HALF_CLK_PERIOD;
    in_clk <= not in_clk;
  end process;

  test : process
  begin
    in_serial_in <= '0';
    wait until rising_edge(in_clk);
    wait until rising_edge(in_clk);
    wait until rising_edge(in_clk);
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --000 (most recent on the left)
    assert(out_z = '0')
      report "expected z=0"
      severity error;
    in_serial_in <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --100 (most recent on the left)
    assert(out_z = '0')
      report "expected z=0"
      severity error;
    in_serial_in <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --010
    assert(out_z = '1')
      report "expected z=1"
      severity error;
    in_serial_in <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --101
    assert(out_z = '1')
      report "expected z=1"
      severity error;
    in_serial_in <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --010
    assert(out_z = '1')
      report "expected z=1"
      severity error;
    in_serial_in <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --001
    assert(out_z = '0')
      report "expected z=0"
      severity error;
    in_serial_in <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --100
    assert(out_z = '0')
      report "expected z=0"
      severity error;
    in_serial_in <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --110
    assert(out_z = '0')
      report "expected z=0"
      severity error;
    in_serial_in <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --111
    assert(out_z = '0')
      report "expected z=0"
      severity error;

    report "Tests completed"
      severity note;
    wait; --done

  end process;
end architecture;
