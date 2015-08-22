-- testbench for spring 2009 midterm q4
library IEEE;
use IEEE.std_logic_1164.all;

entity signature_testbench is
end entity;

architecture stimulus of signature_testbench is
  component signature is
    port(clk, reset, p, d : in std_logic;
         system_bus : out std_logic_vector(2 downto 0));
  end component;
  
  signal in_clk : std_logic := '0'; --must initialize for clk_gen
  signal in_reset, in_p, in_d : std_logic;
  signal out_system_bus : std_logic_vector(2 downto 0);
  
  constant HALF_CLK_PERIOD : time := 5ns; --assume HALF_CLK_PERIOD > TIME_AFTER_EDGE
  constant TIME_AFTER_EDGE : time := 2ns;
begin
  DUT : signature port map(clk => in_clk, reset => in_reset, p => in_p,
                           d => in_d, system_bus => out_system_bus);

  clk_gen : process
  begin
    wait for HALF_CLK_PERIOD;
    in_clk <= not in_clk;
  end process;

  test : process
  begin
    in_d <= '0';
    in_p <= '0';
    in_reset <= '1';
    wait for TIME_AFTER_EDGE;
    in_reset <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_system_bus = "ZZZ")
      report "expected system_bus=ZZZ while d=0"
      severity error;
    in_d <= '1';
    wait for TIME_AFTER_EDGE;
    --flip-flops contain (from left to right as seen on circuit diagram) 00000
    assert(out_system_bus = "000")
      report "expected system_bus=000"
      severity error;
    
    in_p <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --flip-flops contain 10000
    assert(out_system_bus = "100")
      report "expected system_bus=100"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --flip-flops contain 11000
    assert(out_system_bus = "100")
      report "expected system_bus=100"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --flip-flops contain 11100
    assert(out_system_bus = "110")
      report "expected system_bus=110"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --flip-flops contain 01110
    assert(out_system_bus = "010")
      report "expected system_bus=010"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    --flip-flops contain 00111
    assert(out_system_bus = "011")
      report "expected system_bus=011"
      severity error;

    report "Tests completed"
      severity note;
    wait; --done

  end process;
end architecture;
