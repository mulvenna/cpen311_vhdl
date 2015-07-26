-- spring 2009 midterm q4
library IEEE;
use IEEE.std_logic_1164.all;

entity signature is
  port(clk, reset, p, d : in std_logic; --added an asynchronous reset (not originally part of the question)
       system_bus : out std_logic_vector(2 downto 0)); --system_bus bit 2 is the top bit on the circuit diagram
end entity;


architecture behavioural of signature is
  signal reg_value : std_logic_vector(4 downto 0); --bit 4 is the leftmost flip-flop on the circuit diagram
begin
  process(clk, reset)
  begin
    if (reset = '1') then
      reg_value <= (others => '0');
    elsif (rising_edge(clk)) then
      reg_value <= (p xor reg_value(2) xor reg_value(0)) & reg_value(4 downto 1);
    end if;
  end process;
  
  process(d, reg_value)
  begin
    if (d = '1') then
      system_bus <= (p and reg_value(4)) & reg_value(2) & reg_value(0);
    else
      system_bus <= "ZZZ";
    end if;
  end process;
end architecture;
