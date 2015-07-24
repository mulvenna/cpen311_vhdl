-- testbench for spring 2014 final question 5
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity your_circuit_testbench is
end entity;

architecture stimulus of your_circuit_testbench is
  component your_circuit is
    port(clk, resetn : in std_logic;
       n : in std_logic_vector(4 downto 0);
       colour : out std_logic_vector(2 downto 0);
       x, y : out std_logic_vector(7 downto 0);
       plot : out std_logic);
    end component;

  signal in_clk : std_logic := '0';
  signal in_resetn, out_plot : std_logic;
  signal in_n : std_logic_vector(4 downto 0);
  signal out_colour : std_logic_vector(2 downto 0);
  signal out_x, out_y : std_logic_vector(7 downto 0);

  constant HALF_CLK_PERIOD : time := 5ns; --assume HALF_CLK_PERIOD > TIME_AFTER_EDGE;
  constant TIME_AFTER_EDGE : time := 2ns; --used to set inputs and assert outputs after a clock edge

  constant COLOUR_WHITE : std_logic_vector(2 downto 0) := "111";
begin
  DUT : your_circuit port map(clk => in_clk, resetn => in_resetn, 
                              n => in_n, colour => out_colour, 
                              x => out_x, y => out_y, plot => out_plot);

  clk_gen : process
  begin
    wait for HALF_CLK_PERIOD;
    in_clk <= not in_clk;
  end process;

  test : process
  begin
    in_n <= "00100"; --assume the user does not change the input n while the lines are being drawn
    in_resetn <= '0'; --async active-low reset
    wait for TIME_AFTER_EDGE;
    in_resetn <= '1';
    --start by drawing first line from (0,0) to (n,n)
    for i in 0 to 4 loop
      wait until rising_edge(in_clk);
      wait for TIME_AFTER_EDGE;
      assert(out_plot = '1')
        report "plot was not 1 while drawing the first line"
        severity error;
      assert(out_colour = COLOUR_WHITE)
        report "colour was not white while drawing the first line"
        severity error;
      assert(unsigned(out_x) = i)
        report "while drawing first line, x was not " & integer'image(i)
        severity error;
      assert(unsigned(out_y) = i)
        report "while drawing first line, y was not " & integer'image(i)
        severity error;
    end loop;
    --continue to draw second line to (0,2n)
    for i in 3 downto 0 loop
      wait until rising_edge(in_clk);
      wait for TIME_AFTER_EDGE;
      assert(out_plot = '1')
        report "plot was not 1 while drawing the second line"
        severity error;
      assert(out_colour = COLOUR_WHITE)
        report "colour was not white while drawing the second line"
        severity error;
      assert(unsigned(out_x) = i)
        report "while drawing second line, x was not " & integer'image(i)
        severity error;
      assert(unsigned(out_y) = (2*4)-i)
        report "while drawing second line, y was not " & integer'image((2*4)-i)
        severity error;
    end loop;
    --after both lines are both done, wait a few cycles to check that the screen is held constant
    for i in 0 to 10 loop
      wait until rising_edge(in_clk);
      wait for TIME_AFTER_EDGE;
      assert(out_plot = '0')
        report "plot was not 0 after lines were completed"
        severity error;
    end loop;
    
    --until the reset line goes high/low/? and then the process repeats
    --do not need to worry about clearing the screen
    in_n <= "11111"; --draw the largest possible lines
    in_resetn <= '0'; --async active-low reset
    wait for TIME_AFTER_EDGE;
    in_resetn <= '1';
    --start by drawing first line from (0,0) to (n,n)
    for i in 0 to 31 loop
      wait until rising_edge(in_clk);
      wait for TIME_AFTER_EDGE;
      assert(out_plot = '1')
        report "plot was not 1 while drawing the first line"
        severity error;
      assert(out_colour = COLOUR_WHITE)
        report "colour was not white while drawing the first line"
        severity error;
      assert(unsigned(out_x) = i)
        report "while drawing first line, x was not " & integer'image(i)
        severity error;
      assert(unsigned(out_y) = i)
        report "while drawing first line, y was not " & integer'image(i)
        severity error;
    end loop;
    --continue to draw second line to (0,2n)
    for i in 30 downto 0 loop
      wait until rising_edge(in_clk);
      wait for TIME_AFTER_EDGE;
      assert(out_plot = '1')
        report "plot was not 1 while drawing the second line"
        severity error;
      assert(out_colour = COLOUR_WHITE)
        report "colour was not white while drawing the second line"
        severity error;
      assert(unsigned(out_x) = i)
        report "while drawing second line, x was not " & integer'image(i)
        severity error;
      assert(unsigned(out_y) = (2*31)-i)
        report "while drawing second line, y was not " & integer'image((2*31)-i)
        severity error;
    end loop;

    report "Tests completed"
      severity note;
    wait; --done
  end process;
end architecture;
