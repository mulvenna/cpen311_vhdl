-- summer 2014 final exam question 5
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity your_circuit is
  port(clk : in std_logic;
       data : in std_logic_vector(15 downto 0);
       start : in std_logic;
       sum : out std_logic_vector(31 downto 0);
       done : out std_logic);
end your_circuit;

architecture behavioural of your_circuit is
begin
  process(clk)
    variable word_count : unsigned(15 downto 0) := (others => '0');
    variable internal_sum : unsigned(31 downto 0) := (others => '0');
    variable next_done : std_logic := '0';
  begin
    if (rising_edge(clk)) then
      if (next_done = '1') then
        next_done := '0';
        done <= '1';
      else
        done <= '0';
      end if;

      if (start = '1') then
        word_count := unsigned(data);
        internal_sum := (others => '0');
      else
        if (word_count = "0000000000000001") then
          next_done := '1'; --will set done to high next cycle
        else
          next_done := '0';
        end if;

        if (word_count > 0) then
          word_count := word_count - 1;
          internal_sum := internal_sum + unsigned(data);
        end if;
      end if;
      
      sum <= std_logic_vector(internal_sum);
    end if;
  end process;
end architecture;
