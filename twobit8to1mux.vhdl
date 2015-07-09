-- summer 2015 assignment 1 question 1
library IEEE;
use IEEE.std_logic_1164.all;

entity mux is
  port(a,b,c,d,e,f,g,h : in std_logic_vector(1 downto 0);
       sel             : in std_logic_vector(2 downto 0);
       outm            : out std_logic_vector(1 downto 0));
end entity;

--when sel="000", outm has value of a,
--when sel="001", outm has value of b,
--...
--when sel="111", outm has value of h
architecture behavioural of mux is
begin
  process(sel, a, b, c, d, e, f, g, h)
  begin
    case sel is
      when "000"  => outm <= a;
      when "001"  => outm <= b;
      when "010"  => outm <= c;
      when "011"  => outm <= d;
      when "100"  => outm <= e;
      when "101"  => outm <= f;
      when "110"  => outm <= g;
      when others => outm <= h;
    end case;
  end process;
end behavioural;
