-- summer 2015 assignment 2, question 2

library ieee;
use ieee.std_logic_1164.all;

entity mealy is
  port ( a, b, clk : in std_logic;
         z         : out std_logic);
end mealy;

architecture structural of mealy is
  signal q : std_logic;
begin

  z <= a xor q;
  
  process(clk)
  begin
    if (rising_edge(clk)) then
      q <= a and b;
    end if;
  end process;

end structural;
