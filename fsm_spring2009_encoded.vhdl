-- spring 2009 midterm q2
library IEEE;
use IEEE.std_logic_1164.all;

entity state_machine is
  port(clk, x : in std_logic;
       y : out std_logic);
end state_machine;

--note that there is no reset input and that problem statement does not specify a default starting state
--the testbench will work for any starting state

--this solution uses manual state encoding
architecture behavioural of state_machine is
  constant A : std_logic_vector(1 downto 0) := "01";
  constant B : std_logic_vector(1 downto 0) := "00";
  constant C : std_logic_vector(1 downto 0) := "10";
  constant D : std_logic_vector(1 downto 0) := "11";
  signal state : std_logic_vector(1 downto 0);
begin
  --next state logic
  process(clk)
  begin
    if (rising_edge(clk)) then
      case state is
        when A =>
          if (x = '1') then
            state <= B;
          else
            state <= D;
          end if;
        when B =>
          if (x = '0') then
            state <= D;
          end if;
        when C =>
          if (x = '1') then
            state <= B;
          end if;
        when D =>
          if (x = '1') then
            state <= C;
          else
            state <= A;
          end if;
        when others =>
          state <= A; --arbitrary choice of state for after first rising edge
      end case;
    end if;
  end process;
  
  --output logic
  --the choice of state encoding allows output y to simply be bit 0 of the current state
  y <= state(0);
end architecture;
