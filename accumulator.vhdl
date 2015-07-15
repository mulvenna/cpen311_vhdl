-- summer 2015 assignment 3 question 6
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity accumulator is
  port(clk, reset, valid : in std_logic;
       data : in std_logic_vector(15 downto 0);
       sum : out std_logic_vector(15 downto 0));
end entity;

--reset is synchronous
architecture behavioural of accumulator is
begin
  process(clk)
    variable internal_sum : unsigned(15 downto 0);
  begin
    if(rising_edge(clk)) then
      if(reset = '1') then
        --reset (ignore data line)
        internal_sum := (others => '0');
      elsif(valid = '1') then
        --data is valid so accumulate
        internal_sum := internal_sum + unsigned(data);
      end if;
      sum <= std_logic_vector(internal_sum);
    end if;
  end process;
end architecture;
