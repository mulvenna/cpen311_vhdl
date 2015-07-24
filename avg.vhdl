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
    variable sample_count : unsigned(1 downto 0) := "00";
    variable sample1, sample2, sample3, sample4 : unsigned(7 downto 0);
  begin
    if(rising_edge(clk)) then
      --synchronous reset
      if(reset = '1') then
        --we don't need to set each sample variable to zero because the outstream will not
        --be considered valid until after four samples have been collected
        sample_count := "00";
      end if;

      --outstream is only valid after the 4th element is sampled
      if (sample_count = "11") then
        valid <= '1';
      else
        valid <= '0';
        sample_count := sample_count + 1;
      end if;

      --shift values, discard oldest sample
      sample4 := sample3;
      sample3 := sample2;
      sample2 := sample1;
      sample1 := unsigned(instream);

      --note that the four sample variables were specified as unsigned instead of
      --std_logic_vector so that they can be used with the "+" operator
      --the calculated average value is cast to a std_logic_vector and assigned to outstream
      outstream <= std_logic_vector((sample1 + sample2 + sample3 + sample4) / 4); 
    end if;
  end process;
end architecture;
