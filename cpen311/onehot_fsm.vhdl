-- summer 2008 midterm q4
library IEEE;
use IEEE.std_logic_1164.all;

entity onehot_fsm is
  port(reset, clk, w : in std_logic; --async active-high reset
       z : out std_logic);
end entity;

architecture behavioural of onehot_fsm is
  constant S0 : std_logic_vector(3 downto 0) := "0001";
  constant S1 : std_logic_vector(3 downto 0) := "0010";
  constant S2 : std_logic_vector(3 downto 0) := "0100";
  constant S3 : std_logic_vector(3 downto 0) := "1000";
  signal state : std_logic_vector(3 downto 0);
begin
  --next state logic
  process(reset, clk)
  begin
    if (reset = '1') then
      state <= S0; 
    elsif (rising_edge(clk)) then
      case state is
        when S0 =>
          if (w = '1') then
            state <= S1;
          end if;
        when S1 =>
          if (w = '1') then
            state <= S2;
          else
            state <= S3;
          end if;
        when S2 =>
          state <= S0;
        when S3 =>
          if (w = '1') then
            state <= S0;
          end if;
        when others => --must include "when others" since not every 4-bit std_logic_vector is covered
          state <= S0; --if current state is not defined in our model, next state is S0
      end case;
    end if;
  end process;
  
  --output logic
  --z is high for states S0 and S2
  --for this choice of state encoding, z is high when state="0001" or state="0100"
  --so z is high when either bit 0 or bit 2 of state is high
  z <= state(0) or state(2);
end architecture;
