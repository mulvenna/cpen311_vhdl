-- summer 2015 midterm question 2
library IEEE;
use IEEE.std_logic_1164.all;

entity fsm is
  port(a, en, clk, rst : in std_logic;
       f : out std_logic);
end entity;

architecture behavioural of fsm is
    --this solution uses enumerated types
    type state is (SA, SB, SC);
    signal curr_state : state;
begin
  --next state logic (sequential)
  process(clk, rst)
  begin
    if (rst = '1') then
      curr_state <= SA; --ASSUMPTION: reset does not require en=1
    elsif (rising_edge(clk)) then
      if (en = '1') then
        case curr_state is
          when SA =>
            if (a = '1') then
              curr_state <= SB;
            end if;
          when SB =>
            if (a = '1') then
              curr_state <= SA;
            else
              curr_state <= SC;
            end if;
          when SC =>
            if (a = '1') then
              curr_state <= SB;
            else
              curr_state <= SA;
            end if;
        end case;
      end if;
    end if;
  end process;
  
  --output logic (combinational)
  process(curr_state)
  begin
    case curr_state is
      when SA => f <= '0';
      when SB => f <= '1';
      when SC => f <= '0';
    end case;
  end process;
end architecture;
