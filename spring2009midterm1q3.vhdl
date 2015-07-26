-- spring 2008 midterm1 q3
library IEEE;
use IEEE.std_logic_1164.all;

entity circuit is
  port(clk, reset, a, b, c, d, e : in std_logic; --synchronous active-high reset
       z : out std_logic);
end circuit;

--the testbench only simulates a few clock cycles so an incorrect design may still pass the tests

--design may use only one process and also (if necessary) only one concurrent assignment
architecture behavioural of circuit is
  signal internal_value : std_logic_vector(2 downto 0);
begin
  process(clk)
  begin
    if (reset = '1') then
      internal_value <= "000";
    elsif (rising_edge(clk)) then
      if (e = '1') then
        internal_value <= d & internal_value(2) & a;
      else
        internal_value <= c & b & (not internal_value(1));
      end if;
    end if;
  end process;
  
  z <= internal_value(0);
end architecture;
