--fall 2012 midterm1 q3
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity up_down_counter is
  port(clk, reset, up, dn : in std_logic;
       count : out std_logic_vector(7 downto 0));
end entity;

architecture behavioural of up_down_counter is
begin
  process(clk)
    variable internal_count : signed(7 downto 0);
  begin
    if (rising_edge(clk)) then
      if (reset = '1') then
        internal_count := (others => '0');
      elsif (up = '1') then
        if (dn = '0') then
          internal_count := internal_count + 1;
        end if;
      elsif (dn = '1') then
        --we already know that up is not 1
        internal_count := internal_count - 1;
      end if;
    end if;
    count <= std_logic_vector(internal_count);
  end process;
end architecture;
