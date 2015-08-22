-- testbench for summer 2015 assignment 3 question 5
library IEEE;
use IEEE.std_logic_1164.all;

entity lfsr_testbench is
end entity;

architecture stimulus of lfsr_testbench is
  component lfsr is
    port(clk, reset : in std_logic;
         outs : out std_logic);
  end component;
  
  signal in_clk, in_reset, out_outs : std_logic;
  constant HALF_CLK_PERIOD : time := 5ns;
  
begin
  DUT : lfsr port map (clk => in_clk, reset => in_reset, outs => out_outs);
  
  test : process
    variable expected_reg_value : std_logic_vector(5 downto 0);
  begin
    --async reset
    in_reset <= '1';
    wait for HALF_CLK_PERIOD;
    expected_reg_value := "000000";
    assert(out_outs = expected_reg_value(5))
      report "reset error"
      severity error;
    in_reset <= '0';

    --loop (calculate expected value using XNOR)
    for i in 0 to 40 loop --an n-bit LFSR counts through 2^n - 1 numbers
      in_clk <= '0';
      wait for HALF_CLK_PERIOD;
      in_clk <= '1';
      wait for HALF_CLK_PERIOD;
      expected_reg_value := expected_reg_value(4 downto 0) 
                            & (expected_reg_value(5) xnor expected_reg_value(4));
      assert(out_outs = expected_reg_value(5))
        report "error at loop iteration " & integer'image(i)
        severity error;
    end loop;
    
    report "Tests completed without errors"
      severity note;
    wait; --done
  end process;
end architecture;
