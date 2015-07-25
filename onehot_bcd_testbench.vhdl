-- testbench for summer 2014 midterm question 1
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity onehot_bcd_testbench is
end entity;

architecture stimulus of onehot_bcd_testbench is
  component onehot_bcd is
    port(clk, reset : std_logic;
         cnt : out std_logic_vector(3 downto 0));
  end component;
  
  signal in_clk : std_logic := '0'; --must initalize for clk_gen
  signal in_reset : std_logic;
  signal out_cnt : std_logic_vector(3 downto 0);
  
  constant HALF_CLK_PERIOD : time := 5ns; --assume HALF_CLK_PERIOD > TIME_AFTER EDGE
  constant TIME_AFTER_EDGE : time := 2ns;
begin
  DUT : onehot_bcd port map(clk => in_clk, reset => in_reset, cnt => out_cnt);

  clk_gen : process
  begin
    wait for HALF_CLK_PERIOD;
    in_clk <= not in_clk;
  end process;

  test : process
    variable expected_cnt : unsigned(3 downto 0) := "0000";
  begin
    --sync reset
    in_reset <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_cnt = "0000")
      report "after reset, expected cnt=0"
      severity error;
    in_reset <='0';

    for i in 1 to 9 loop
      wait until rising_edge(in_clk);
      wait for TIME_AFTER_EDGE;
      expected_cnt := expected_cnt + 1;
      assert(out_cnt = std_logic_vector(expected_cnt))
        report "during loop, expected cnt=" & integer'image(i)
        severity error;
    end loop;
    
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_cnt = "0000")
      report "expected roll over to cnt=0"
      severity error;

    report "Tests completed"
      severity note;
    wait; --done
  end process;
end architecture;
