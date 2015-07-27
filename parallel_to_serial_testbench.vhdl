-- testbench for spring 2008 midterm1 q6
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity parallel_to_serial_testbench is
end entity;

architecture stimulus of parallel_to_serial_testbench is
  component parallel_to_serial is
    port(clk, reset : in std_logic;
         data_input : in std_logic_vector(3 downto 0);
         serial_output : out std_logic);
  end component;

  signal in_clk : std_logic := '1'; --must initialize for clk_gen (starts at 1 to match example waveform)
  signal in_reset : std_logic;
  signal in_data_input : std_logic_vector(3 downto 0);
  signal out_serial_output : std_logic;

  constant HALF_CLK_PERIOD : time := 5ns; --assume HALF_CLK_PERIOD > TIME_AFTER_EDGE
  constant TIME_AFTER_EDGE : time := 2ns;
begin
  DUT : parallel_to_serial port map(clk => in_clk, reset => in_reset,
                                    data_input => in_data_input, 
                                    serial_output => out_serial_output);

  clk_gen : process
  begin
    wait for HALF_CLK_PERIOD;
    in_clk <= not in_clk;
  end process;

  test : process
  begin
    --match the example waveform in the problem statement
    in_data_input <= "0000";
    in_reset <= '1';
    wait for TIME_AFTER_EDGE;
    in_reset <= '0';
    wait for TIME_AFTER_EDGE;

    in_data_input <= "0101";
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_serial_output = '1')
      report "expected serial_output=1"
      severity error;
    in_data_input <= "1111"; --DUT should remember the input from earlier
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_serial_output = '0')
      report "expected serial_output=0"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_serial_output = '1')
      report "expected serial_output=1"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_serial_output = '0')
      report "expected serial_output=0"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_serial_output = '0')
      report "expected serial_output=0 (for parity bit)"
      severity error;

    in_data_input <= "0111";
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_serial_output = '1')
      report "expected serial_output=1"
      severity error;
    in_data_input <= "0000"; --DUT should remember the input from earlier
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_serial_output = '1')
      report "expected serial_output=1"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_serial_output = '1')
      report "expected serial_output=1"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_serial_output = '0')
      report "expected serial_output=0"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_serial_output = '1')
      report "expected serial_output=1 (for parity bit)"
      severity error;

    report "Tests completed"
      severity note;
    wait; --done

  end process;
end architecture;
