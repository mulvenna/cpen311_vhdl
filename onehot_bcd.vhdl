-- summer 2014 midterm question 1
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity onehot_bcd is
  port(clk, reset : std_logic;
       cnt : out std_logic_vector(3 downto 0));
end entity;

architecture behavioural of onehot_bcd is
  signal onehot : std_logic_vector(9 downto 0);
begin
  --next state logic
  process(clk)
  begin
    if(rising_edge(clk)) then
      if(reset = '1') then
        onehot <= "0000000001";
      else
        onehot <= onehot(8 downto 0) & onehot(9);
      end if;
    end if;
  end process;
  
  --output logic
  process(onehot)
  begin
    case onehot is
      when "0000000001" => cnt <= "0000";
      when "0000000010" => cnt <= "0001";
      when "0000000100" => cnt <= "0010";
      when "0000001000" => cnt <= "0011";
      when "0000010000" => cnt <= "0100";
      when "0000100000" => cnt <= "0101";
      when "0001000000" => cnt <= "0110";
      when "0010000000" => cnt <= "0111";
      when "0100000000" => cnt <= "1000";
      when "1000000000" => cnt <= "1001";
      when others       => cnt <= "0000";
    end case;
  end process;
end architecture;
