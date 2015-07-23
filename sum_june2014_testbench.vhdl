-- testbench for summer 2014 final exam question 5
library IEEE;
use IEEE.std_logic_1164.all;

entity your_circuit_testbench is
end entity;

architecture stimulus of your_circuit_testbench is
  component your_circuit is
    port(clk : in std_logic;
       data : in std_logic_vector(15 downto 0);
       start : in std_logic;
       sum : out std_logic_vector(31 downto 0);
       done : out std_logic);
  end component;

  signal in_clk : std_logic := '0'; --must initialize for clk_gen
  signal in_start, out_done : std_logic;
  signal in_data : std_logic_vector(15 downto 0);
  signal out_sum : std_logic_vector(31 downto 0);

  constant HALF_CLK_PERIOD : time := 5ns; --assume HALF_CLK_PERIOD > TIME_AFTER_EDGE
  constant TIME_AFTER_EDGE : time := 2ns; --used to change an input or assert an output just after an edge
begin
  DUT : your_circuit port map(clk => in_clk, data => in_data, start => in_start, sum => out_sum, done => out_done);

  clk_gen : process
  begin
    wait for HALF_CLK_PERIOD;
    in_clk <= not in_clk;
  end process;

  test : process
  begin
    in_start <= '0';
    in_data <= (others => '-');
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    in_start <= '1';
    in_data <= "0000000000000001"; --test one word
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_done = '0')
      report "done was not 0"
      severity error;
    in_start <= '0';
    in_data <= "0000000000000001"; --the only word being added is also one
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_done = '0')
      report "done was not 0"
      severity error;
    in_data <= (others => '-');
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_done = '1')
      report "done was not 1"
      severity error;
    assert(out_sum = "00000000000000000000000000000001")
      report "sum was not 1"
      severity error;

    in_start <= '1';
    in_data <= "0000000000000100"; --test four words
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_done = '0')
      report "done was not 0"
      severity error;
    in_start <= '0';
    in_data <= "1111111111111111"; --each word will be 65535
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_done = '0')
      report "done was not 0"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_done = '0')
      report "done was not 0"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_done = '0')
      report "done was not 0"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_done = '0')
      report "done was not 0"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_done = '1')
      report "done was not 1"
      severity error;
    assert(out_sum = "00000000000000111111111111111100") --sum should be 65535*4=262140
      report "sum error"
      severity error;

    report "Tests completed"
      severity note;
    wait; --done
  end process;
end architecture;
