-- summer 2014 midterm question 4
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bridge is
  port(clk, load, drive, shift : in std_logic;
       bus1 : in std_logic_vector(15 downto 0);
       bus2 : out std_logic);
end entity;

architecture stimulus of bridge is
  signal register_value : std_logic_vector(15 downto 0);
begin
  --next state logic
  process(clk)
  begin
    if (rising_edge(clk)) then
      if (load = '1') then
        register_value <= bus1;
      elsif (shift = '1') then
        register_value <= '0' & register_value(15 downto 1);
      end if;
    end if;
  end process;

  --output logic
  process(drive, register_value)
  begin
    if (drive = '1') then
      bus2 <= register_value(0);
    else
      bus2 <= 'Z';
    end if;
  end process;
end architecture;
