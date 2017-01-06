-- summer 2015 assignment 3 question 2
library IEEE;
use IEEE.std_logic_1164.all;

entity ushift is
  port(clk, load, dir : in std_logic;
       par_in         : in std_logic_vector(3 downto 0);
       outsig         : out std_logic);
end entity;

--parallel load instead of shifting when load=1
--shift in 0 to MSB when dir=0, shift in 0 to LSB when dir=1
--outsig is output of LSB of register
architecture behavioural of ushift is
begin
  process(clk)
    variable reg_value : std_logic_vector(3 downto 0);
  begin
    if rising_edge(clk) then
      if (load = '1') then
        --parallel load
        reg_value := par_in;
      elsif (dir = '1') then
        --shift left
        reg_value := reg_value(2 downto 0) & '0';
      else
        --shift right
        reg_value := '0' & reg_value(3 downto 1);
      end if;
      --output is LSB
      outsig <= reg_value(0);
    end if;
  end process;
end architecture;
