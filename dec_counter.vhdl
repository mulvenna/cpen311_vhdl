-- fall 2007 final q6
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dec_counter is
  port(clk, reset, en : in std_logic;
       div10 : out std_logic;
       dec_out : out std_logic_vector(9 downto 0));
end entity;

architecture behavioural of dec_counter is
  signal count : unsigned(3 downto 0);
begin
  --next state logic (sequential)
  process(clk, reset)
  begin
    if (reset = '1') then
      count <= "0000";
    elsif (rising_edge(clk)) then
      if (en = '1') then
        if (count >= "1001") then
          count <= "0000";
        else
          count <= count + 1;
        end if;
      end if;
    end if;
  end process;
  
  --output logic (combinational)
  process(count)
  begin
    case count is
      when "0000" => 
        dec_out <= "0000000001";
        div10 <= '1';
      when "0001" => 
        dec_out <= "0000000010";
        div10 <= '1';
      when "0010" => 
        dec_out <= "0000000100";
        div10 <= '1';
      when "0011" => 
        dec_out <= "0000001000";
        div10 <= '1';
      when "0100" => 
        dec_out <= "0000010000";
        div10 <= '1';
      when "0101" => 
        dec_out <= "0000100000";
        div10 <= '0';
      when "0110" => 
        dec_out <= "0001000000";
        div10 <= '0';
      when "0111" => 
        dec_out <= "0010000000";
        div10 <= '0';
      when "1000" => 
        dec_out <= "0100000000";
        div10 <= '0';
      when "1001" => 
        dec_out <= "1000000000";
        div10 <= '0';
      when others => --"when others" is required
        dec_out <= "0000000000";
        div10 <= '0'; 
    end case;
  end process;
end architecture;
