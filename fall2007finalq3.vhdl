-- fall 2007 final q3
library IEEE;
use IEEE.std_logic_1164.all;

entity circuit is
  port(clk, a, b, en : in std_logic;
       y : out std_logic);
end entity;

--use no more than two processes
architecture behavioural of circuit is
  signal q : std_logic;
begin
  -- AND gate and flip-flop (sequential)
  process(clk)
  begin
    if (rising_edge(clk)) then
      q <= a and b;
    end if;
  end process;

  -- XOR gate and tri-state buffer (combinational)
  process(a, en, q)
  begin
    if (en = '1') then
      y <= a xor q;
    else
      y <= 'Z';
    end if;
  end process;
end architecture;
