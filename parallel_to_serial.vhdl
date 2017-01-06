-- spring 2008 midterm1 q6
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity parallel_to_serial is
  port(clk, reset : in std_logic;
       data_input : in std_logic_vector(3 downto 0);
       serial_output : out std_logic);
end entity;

architecture behavioural of parallel_to_serial is
  signal data : std_logic_vector(3 downto 0);
  signal count : unsigned(2 downto 0);
begin
  process(clk, reset)
  begin
    if (reset = '1') then
      data <= "0000";
      count <= "100";
    elsif (rising_edge(clk)) then
      case count is
        when "000" =>
          serial_output <= data(0) xor data(1) xor data(2) xor data(3);
        when "001" =>
          serial_output <= data(3);
        when "010" =>
          serial_output <= data(2);
        when "011" =>
          serial_output <= data(1);
        when "100" =>
          data <= data_input;
          serial_output <= data_input(0); --use data_input(0) since data (signal) will not update until the end of the process
        when others =>
          count <= "100";
      end case;

      if (count = "000") then
        count <= "100";
      else
        count <= count - 1;
      end if;
    end if;
  end process;
end architecture;
