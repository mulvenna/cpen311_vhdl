-- testbench for summer 2015 assignment 3 question 4
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bcdcounter_testbench is
end entity;

architecture stimulus of bcdcounter_testbench is
  component bcdcounter is
    port(clock, enable, reset : in std_logic;
         ones, tens : out std_logic_vector(3 downto 0));
  end component;
  
  signal in_clock, in_enable, in_reset : std_logic;
  signal out_ones, out_tens : std_logic_vector(3 downto 0);
  constant HALF_CLOCK_PERIOD : time := 5ns;
begin
  DUT : bcdcounter port map (clock => in_clock, enable => in_enable,
                              reset => in_reset, ones => out_ones,
                              tens => out_tens);

  test : process
    variable expected_ones, expected_tens: unsigned(3 downto 0);
  begin    
    --async reset
    in_reset <= '1';
    wait for HALF_CLOCK_PERIOD;
    expected_tens := "0000";
    expected_ones := "0000";
    assert (out_tens = std_logic_vector(expected_tens)
            and out_ones = std_logic_vector(expected_ones))
      report "reset error"
      severity error;
    in_reset <= '0';
    
    --not enabled
    in_enable <= '0';
    in_clock <= '0';
    wait for HALF_CLOCK_PERIOD;
    in_clock <= '1';
    wait for HALF_CLOCK_PERIOD;
    assert (out_tens = std_logic_vector(expected_tens)
            and out_ones = std_logic_vector(expected_ones))
      report "enable=0 error"
      severity error;

    --enabled
    in_enable <= '1';
    in_clock <= '0';
    wait for HALF_CLOCK_PERIOD;
    in_clock <= '1';
    wait for HALF_CLOCK_PERIOD;
    expected_ones := expected_ones + 1;
    assert (out_tens = std_logic_vector(expected_tens)
            and out_ones = std_logic_vector(expected_ones))
      report "enable=1 error"
      severity error;
    
    --test 02 to 09
    for i in 2 to 9 loop
      in_clock <= '0';
      wait for HALF_CLOCK_PERIOD;
      in_clock <= '1';
      wait for HALF_CLOCK_PERIOD;
      expected_ones := expected_ones + 1;
      assert (out_tens = std_logic_vector(expected_tens)
              and out_ones = std_logic_vector(expected_ones))
        report "ones error"
        severity error;
    end loop;
    
    --count up to 99
    for i in 10 to 99 loop
      in_clock <= '0';
      wait for HALF_CLOCK_PERIOD;
      in_clock <= '1';
      wait for HALF_CLOCK_PERIOD;
    end loop;
    expected_tens := "1001";
    expected_ones := "1001";
    assert (out_tens = std_logic_vector(expected_tens)
            and out_ones = std_logic_vector(expected_ones))
      report "output was not tens=9, ones=9"
      severity error;
    
    --overflow to 00
    in_clock <= '0';
    wait for HALF_CLOCK_PERIOD;
    in_clock <= '1';
    wait for HALF_CLOCK_PERIOD;
    expected_tens := "0000";
    expected_ones := "0000";
    assert (out_tens = std_logic_vector(expected_tens)
            and out_ones = std_logic_vector(expected_ones))
      report "output did not overflow to tens=0, ones=0"
      severity error;
    
    report "Tests completed without errors"
      severity note;
    wait; --done
  end process;
end architecture;
