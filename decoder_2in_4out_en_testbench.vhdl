-- summer 2015 assignment 1 question 3
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decoder_testbench is
end entity;

architecture stimulus of decoder_testbench is
  component decoder is
    port (en : in std_logic;
          w  : in std_logic_vector(1 downto 0);
          y  : out std_logic_vector(3 downto 0));
  end component;
  
  signal in_w  : std_logic_vector(1 downto 0);
  signal in_en : std_logic;
  signal out_y : std_logic_vector(3 downto 0);
  signal expected_y : std_logic_vector(3 downto 0);
  constant WAIT_TIME : time := 5ns;
  
begin
  DUT : decoder port map (en => in_en, w => in_w, y => out_y);
  
  test : process
  begin
    in_en <= '1';
    in_w <= "00";
    expected_y <= "0001";
    
    for i in 0 to 3 loop
      wait for WAIT_TIME;
      assert (out_y = expected_y)
        report "assert error at iteration " & integer'image(i)
        severity error;
      in_w <= std_logic_vector(unsigned(in_w) + 1); --increment
      expected_y <= expected_y(2 downto 0) & '0'; --shift left 1 bit
    end loop;
    
    in_en <= '0';
    in_w <= "XX";
    wait for WAIT_TIME;
    assert (out_y = "0000")
      report "assert error when en=0"
      severity error;
      
    report "Tests completed without errors"
      severity note;
    wait; --done
    
  end process;
end architecture;
