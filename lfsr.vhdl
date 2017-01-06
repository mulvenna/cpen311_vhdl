-- summer 2015 assignment 3 question 5
library IEEE;
use IEEE.std_logic_1164.all;

entity lfsr is
  port(clk, reset : in std_logic;
       outs : out std_logic);
end entity;

architecture behavioural of lfsr is
begin
  process(clk, reset)
    variable reg_value : std_logic_vector(5 downto 0);
  begin
    if(reset = '1') then
      reg_value := "000000";
    elsif(rising_edge(clk)) then
      reg_value := reg_value(4 downto 0) & (reg_value(5) xnor reg_value(4));
    end if;
    outs <= reg_value(5);
  end process;
end architecture;
