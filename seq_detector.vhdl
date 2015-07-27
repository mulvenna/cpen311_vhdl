-- fall 2007 final q4
library IEEE;
use IEEE.std_logic_1164.all;

entity seq_detector is
  port(clk, serial_in : in std_logic;
       z : out std_logic);
end entity;

architecture behavioural of seq_detector is
begin
  process(clk)
    variable data : std_logic_vector(2 downto 0);
  begin
    if (rising_edge(clk)) then
      data := serial_in & data(2) & data(1);
      z <= (not data(2) and data(1) and not data(0))
             or (data(2) and not data(1) and data(0));
    end if;
  end process;
end architecture;
