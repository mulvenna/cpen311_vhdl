-- spring/summer 2014 final exam question 4
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity avg is
  port (clk, reset : in std_logic;
        instream : in std_logic_vector(7 downto 0);
        valid : out std_logic;
        outstream : out std_logic_vector(7 downto 0));
end entity;

architecture behavioural of avg is
begin
  process(clk)
    variable samples : integer;
    variable sample1, sample2, sample3, sample4 : unsigned(7 downto 0);
  begin
    if(rising_edge(clk)) then
      if(reset = '1') then
        samples := 1;
        valid <= '0';
        outstream <= (others => '0');
        sample4 := (others => '0');
        sample3 := (others => '0');
        sample2 := (others => '0');
        sample1 := unsigned(instream);
      else
        samples := samples + 1;
        if (samples > 3) then
          valid <= '1';
        else
          valid <= '0';
        end if;

        sample4 := sample3;
        sample3 := sample2;
        sample2 := sample1;
        sample1 := unsigned(instream);

        outstream <= std_logic_vector((sample1 + sample2 + sample3 + sample4) / 4); --edited
      end if;
    end if;
  end process;
end architecture;
