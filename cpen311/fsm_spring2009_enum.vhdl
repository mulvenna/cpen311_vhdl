-- spring 2009 midterm q2
library IEEE;
use IEEE.std_logic_1164.all;

entity state_machine is
  port(clk, x : in std_logic;
       y : out std_logic);
end state_machine;

--note that there is no reset input and that problem statement does not specify a default starting state
--the testbench will work for any starting state

--this solution uses an enumerated type to represent the state
architecture behavioural of state_machine is
  type state_type is (A, B, C, D);
begin
  process(clk)
    variable state : state_type := A; --arbitrarily choosing state A as starting state
  begin
    if (rising_edge(clk)) then
      --determine new state
      case state is
        when A =>
          if (x = '1') then
            state := B;
          else
            state := D;
          end if;
        when B =>
          if (x = '0') then
            state := D;
          end if;
        when C =>
          if (x = '1') then
            state := B;
          end if;
        when D =>
          if (x = '1') then
            state := C;
          else
            state := A;
          end if;
      end case;
      
      --determine output
      case state is
        when A => y <= '1';
        when B => y <= '0';
        when C => y <= '0';
        when D => y <= '1';
      end case;
    end if;
  end process;
end architecture;
