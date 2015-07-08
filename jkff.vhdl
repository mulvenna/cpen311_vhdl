--summer 2015 assignment 2, question 1

library ieee;
use ieee.std_logic_1164.all;

entity JKFF is
  port ( J, K, CLK : in std_logic;
         Q         : out std_logic);
end JKFF;

architecture BEHAVIOURAL of JKFF is
  signal Q_INTERNAL : std_logic;
begin
  Q <= Q_INTERNAL;
  process (CLK)
  begin
    if (rising_edge(CLK)) then
      if (J = '1' and K = '1') then
        Q_INTERNAL <= not Q_INTERNAL;
      elsif (J = '0' and K = '1') then
        Q_INTERNAL <= '0';
      elsif (J = '1' and K = '0') then
        Q_INTERNAL <= '1';
      end if;
    end if;
  end process;
end BEHAVIOURAL;
