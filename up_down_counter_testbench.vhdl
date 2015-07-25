--testbench for fall 2012 midterm1 q3
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity up_down_counter_testbench is
end entity;

architecture stimulus of up_down_counter_testbench is
  component up_down_counter is
    port(clk, reset, up, dn : in std_logic;
         count : out std_logic_vector(7 downto 0));
  end component;

  signal in_clk : std_logic := '0'; --must initialize for clk_gen
  signal in_reset, in_up, in_dn : std_logic;
  signal out_count : std_logic_vector(7 downto 0);

  constant HALF_CLK_PERIOD : time := 5ns; --assume HALF_CLK_PERIOD > TIME_AFTER_EDGE
  constant TIME_AFTER_EDGE : time := 2ns;
begin
  DUT : up_down_counter port map(clk => in_clk, reset => in_reset, up => in_up, 
                        dn => in_dn, count => out_count);
  
  clk_gen : process
  begin
    wait for HALF_CLK_PERIOD;
    in_clk <= not in_clk;
  end process;
  
  test : process
  begin
    --sync reset
    in_up <= '0';
    in_dn <= '1';
    in_reset <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_count = "00000000")
      report "reset error"
      severity error;
    
    in_up <= '0';
    in_dn <= '1';
    in_reset <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_count = "11111111") --output is signed (can be negative)
      report "dn error"
      severity error;

    in_up <= '1';
    in_dn <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_count = "00000000")
      report "up error"
      severity error;

    in_up <= '1';
    in_dn <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_count = "00000001")
      report "up error"
      severity error;

    in_up <= '1';
    in_dn <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_count = "00000010")
      report "up error"
      severity error;

    in_up <= '0';
    in_dn <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_count = "00000010")
      report "up=0, dn=0 error"
      severity error;

   in_up <= '0';
   in_dn <= '1';
   wait until rising_edge(in_clk);
   wait for TIME_AFTER_EDGE;
   assert(out_count = "00000001")
     report "dn error"
     severity error;

   in_up <= '1';
   in_dn <= '1';
   wait until rising_edge(in_clk);
   wait for TIME_AFTER_EDGE;
   assert(out_count = "00000001")
     report "up=1, dn=1 error"
     severity error;

    report "Tests completed"
      severity note;
    wait; --done
  end process;
end architecture;
