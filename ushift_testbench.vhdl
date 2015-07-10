-- testbench for summer 2015 assignment 3 question 2
library IEEE;
use IEEE.std_logic_1164.all;

entity ushift_testbench is
end entity;

architecture stimulus of ushift_testbench is
  component ushift is
    port(clk, load, dir : in std_logic;
         par_in         : in std_logic_vector(3 downto 0);
         outsig         : out std_logic);
  end component;
  
  signal in_clk, in_load, in_dir : std_logic;
  signal in_par_in               : std_logic_vector(3 downto 0);
  signal out_outsig              : std_logic;
  constant HALF_CLK_PERIOD : time := 5ns;

begin
  DUT : ushift port map (clk => in_clk, load => in_load,
                         dir => in_dir, par_in => in_par_in,
                         outsig => out_outsig);
  
  test : process
  begin
  
    --parallel load
    in_load <= '1';
    in_par_in <= "1111";
    in_clk <= '0';
    wait for HALF_CLK_PERIOD;
    in_clk <= '1';
    wait for HALF_CLK_PERIOD;
    --reg contains "1111"
    assert (out_outsig = '1')
      report "parallel load error 1"
      severity error;
    in_load <= '0';
    in_par_in <= "XXXX";
    
    --shift right
    in_dir <= '0';
    in_clk <= '0';
    wait for HALF_CLK_PERIOD;
    in_clk <= '1';
    wait for HALF_CLK_PERIOD;
    --reg contains "0111"
    assert (out_outsig = '1')
       report "shift right error 1"
       severity error;
    in_clk <= '0';
    wait for HALF_CLK_PERIOD;
    in_clk <= '1';
    wait for HALF_CLK_PERIOD;
    --reg contains "0011"
    assert (out_outsig = '1')
       report "shift right error 2"
       severity error;

    --shift left
    in_dir <= '1';
    in_clk <= '0';
    wait for HALF_CLK_PERIOD;
    in_clk <= '1';
    wait for HALF_CLK_PERIOD;
    --reg contains "0110"
    assert (out_outsig = '0')
      report "shift left error 1"
      severity error;
    in_clk <= '0';
    wait for HALF_CLK_PERIOD;
    in_clk <= '1';
    wait for HALF_CLK_PERIOD;
    --reg contains "1100"
    assert (out_outsig = '0')
      report "shift left error 2"
      severity error;
    
    --shift right again
    in_dir <= '0';
    in_clk <= '0';
    wait for HALF_CLK_PERIOD;
    in_clk <= '1';
    wait for HALF_CLK_PERIOD;
    --reg contains "0110"
    assert (out_outsig = '0')
      report "shift right error 3"
      severity error;
    in_clk <= '0';
    wait for HALF_CLK_PERIOD;
    in_clk <= '1';
    wait for HALF_CLK_PERIOD;
    --reg contains "0011"
    assert (out_outsig = '1')
      report "shift right error 4"
      severity error;
  
    report "Tests completed without errors"
      severity note;
    wait; --done
  
  end process;
end architecture;
