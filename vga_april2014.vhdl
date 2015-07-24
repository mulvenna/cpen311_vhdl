-- spring 2014 final question 5
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity your_circuit is
  port(clk, resetn : in std_logic;
       n : in std_logic_vector(4 downto 0);
       colour : out std_logic_vector(2 downto 0);
       x, y : out std_logic_vector(7 downto 0);
       plot : out std_logic);
end entity;

--ASSUMPTION: We can read n during the reset
--ASSUMPTION: We need to be able to draw a second pair of lines by setting resetn low
--            and providing a new value for n.
--            Note that the instructor's solution 
--ASSUMPTION: We will not draw the same pixel twice for (n,n) which is part of both lines.
--            Note that the instructor's solution draws (n,n) twice which takes an extra cycle.
architecture behavioural of your_circuit is
  constant COLOUR_WHITE : std_logic_vector(2 downto 0) := "111";
begin
  colour <= COLOUR_WHITE;
  process(clk, resetn)
    constant NOT_DRAWING : std_logic_vector(1 downto 0) := "00";
    constant DRAWING_FIRST_LINE : std_logic_vector(1 downto 0) := "01";
    constant DRAWING_SECOND_LINE : std_logic_vector(1 downto 0) := "10";
    variable drawing_stage : std_logic_vector(1 downto 0) := NOT_DRAWING;
    variable internal_n : unsigned(4 downto 0);
    variable internal_x : unsigned(4 downto 0); --x has same range as n
    variable internal_y : unsigned(5 downto 0); --y has double the range of n
  begin
    if (resetn = '0') then --active-low async reset
      internal_n := unsigned(n);
      internal_x := (others => '1'); --internal_x and internal_y will both
      internal_y := (others => '1'); --overflow to draw the first pixel at (0,0)
      drawing_stage := DRAWING_FIRST_LINE;
    elsif (rising_edge(clk)) then
      if (drawing_stage = DRAWING_FIRST_LINE) then
        plot <= '1';
        internal_x := internal_x + 1;
        internal_y := internal_y + 1;
        if (internal_x = internal_n) then
          drawing_stage := DRAWING_SECOND_LINE;
        end if;
      elsif (drawing_stage = DRAWING_SECOND_LINE) then
        internal_x := internal_x - 1;
        internal_y := internal_y + 1;
        if (internal_x = "00000") then
          drawing_stage := NOT_DRAWING;
        end if;
      else
        plot <= '0';
      end if;
      x <= "000" & std_logic_vector(internal_x);
      y <= "00" & std_logic_vector(internal_y);
    end if;
  end process;
end architecture;
