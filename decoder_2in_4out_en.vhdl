-- summer 2015 assignment 1 question 3
library IEEE;
use IEEE.std_logic_1164.all;

entity decoder is
  port(en : in std_logic;
       w  : in std_logic_vector(1 downto 0);
       y  : out std_logic_vector(3 downto 0));
end entity;

--when w is "00" and en is '1', output y is "0001"
--...
--when w is "11" and en is '1', output y is "1000"
--when en is '0', output y is "0000"
architecture behavioural of decoder is
begin
  process(en, w)
  begin
    if (en = '1') then
      case w is
        when "00"   => y <= "0001";
        when "01"   => y <= "0010";
        when "10"   => y <= "0100";
        when others => y <= "1000";
      end case;
    else
      y <= "0000";
    end if;
  end process;
end behavioural;
