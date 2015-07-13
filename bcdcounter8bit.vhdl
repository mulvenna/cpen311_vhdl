-- summer 2015 assignment 3 question 4
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bcdcounter is
  port(clock, enable, reset : in std_logic;
       ones, tens : out std_logic_vector(3 downto 0));
end entity;

-- based on slide set 10 page 22
architecture behavioural of bcdcounter is
begin
  process(clock, reset)
    variable count_ones, count_tens: unsigned(3 downto 0);
  begin
    if (reset = '1') then --async reset
      count_ones := "0000";
      count_tens := "0000";
    elsif (rising_edge(clock)) then
      if (enable = '1') then --only count when enabled
        if (count_ones = 9) then --if ones will overflow
          count_ones := "0000";
          if (count_tens = 9) then --if tens will overflow
            count_tens := "0000";
          else
            count_tens := count_tens + 1;
          end if;
        else
          count_ones := count_ones + 1;
        end if;
      end if;
    end if;
    ones <= std_logic_vector(count_ones);
    tens <= std_logic_vector(count_tens);
  end process;
end architecture;
