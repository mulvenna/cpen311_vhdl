-- summer 2015 midterm question 2
library IEEE;
use IEEE.std_logic_1164.all;

entity fsm is
  port(a, en, clk, rst : in std_logic;
       f : out std_logic);
end entity;

architecture behavioural of fsm is
  --this solution does not use enumerated types
  constant SA : std_logic_vector(1 downto 0) := "00";
  constant SB : std_logic_vector(1 downto 0) := "01";
  constant SC : std_logic_vector(1 downto 0) := "10";
  signal curr_state : std_logic_vector(1 downto 0);
begin
  process(clk, rst)

  begin
    --next state logic
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
          when others =>
            curr_state <= SA;
        end case;
      end if;
    end if;
  end process;
  
  --output logic
  --with this choice of state encoding,
  --the output can just be bit 0 of the current state
  f <= curr_state(0);
end architecture;
