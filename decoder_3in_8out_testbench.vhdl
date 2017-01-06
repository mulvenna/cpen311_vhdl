-- summer 2015 assignment 1 question 2
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decoder_testbench is
end entity;

architecture stimulus of decoder_testbench is
  component decoder is
    port (w : in std_logic_vector(2 downto 0);
          y : out std_logic_vector(7 downto 0));
  end component;
  
  signal in_w : std_logic_vector(2 downto 0);
  signal out_y : std_logic_vector(7 downto 0);
  signal expected_y : std_logic_vector(7 downto 0);
  constant WAIT_TIME : time := 5ns;
  
begin
  DUT : decoder port map (w => in_w, y => out_y);
  
  test : process
  begin
    in_w <= "000";
    expected_y <= "00000001";
    
    for i in 0 to 7 loop
      wait for WAIT_TIME;
      assert (out_y = expected_y)
        report "assert error at iteration " & integer'image(i)
        severity error;
      in_w <= std_logic_vector(unsigned(in_w) + 1); --increment
      expected_y <= expected_y(6 downto 0) & '0'; --shift left 1 bit
    end loop;
    
    report "Tests completed without errors"
      severity note;
    wait; --done
    
  end process;
end architecture;
