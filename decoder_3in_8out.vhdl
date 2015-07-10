-- summer 2015 assignment 1 question 2
library IEEE;
use IEEE.std_logic_1164.all;

entity decoder is
  port(w : in std_logic_vector(2 downto 0);
       y : out std_logic_vector(7 downto 0));
end entity;

--The decoder asserts (sets to 1) bit w of y
--when the input w is "000", the output y is "00000001"
--when the input w is "100", the output y is "00010000"
architecture behavioural of decoder is
begin
  process(w)
  begin
    case w is
      when "000"  => y <= "00000001";
      when "001"  => y <= "00000010";
      when "010"  => y <= "00000100";
      when "011"  => y <= "00001000";
      when "100"  => y <= "00010000";
      when "101"  => y <= "00100000";
      when "110"  => y <= "01000000";
      when others => y <= "10000000";
    end case;
  end process;
end behavioural;
