-- summer 2015 assignment 3 question 7
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity timer is
  port(clk, stb : in std_logic;
       ts, tl : out std_logic);
end entity;

architecture behavioural of timer is
begin
  process(clk, stb)
    variable count : unsigned(3 downto 0) := "0000";
  begin
    if (stb = '0') then
      count := "1000";
    elsif (rising_edge(clk)) then
      if (count > 0) then
        count := count - 1;
      end if;

      if (count < 4) then
        ts <= '1';
      else
        ts <= '0';
      end if;
      if (count = 0) then
        tl <= '1';
      else
        tl <= '0';
      end if;
    end if;
  end process;
end architecture;
