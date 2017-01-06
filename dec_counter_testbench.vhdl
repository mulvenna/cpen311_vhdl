-- testbench for fall 2007 final q6
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dec_counter_testbench is
end entity;

architecture stimulus of dec_counter_testbench is
  component dec_counter is
    port(clk, reset, en : in std_logic;
         div10 : out std_logic;
         dec_out : out std_logic_vector(9 downto 0));
  end component;

  signal in_clk : std_logic := '0'; --must initialize for clk_gen
  signal in_reset, in_en, out_div10 : std_logic;
  signal out_dec_out : std_logic_vector(9 downto 0);

  constant HALF_CLK_PERIOD : time := 5ns; --assume HALF_CLK_PERIOD > TIME_AFTER_EDGE
  constant TIME_AFTER_EDGE : time := 2ns;
begin
  DUT : dec_counter port map(clk => in_clk, reset => in_reset, en => in_en,
                         div10 => out_div10, dec_out => out_dec_out);

  clk_gen : process
  begin
    wait for HALF_CLK_PERIOD;
    in_clk <= not in_clk;
  end process;

  test : process
  begin
    in_reset <= '1';
    wait for TIME_AFTER_EDGE;
    in_reset <= '0';
    wait for TIME_AFTER_EDGE;
    assert(out_dec_out = "0000000001")
      report "expected dec_out=0000000001"
      severity error;
    assert(out_div10 = '1')
      report "expected div10=1"
      severity error;
    in_en <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_dec_out = "0000000010")
      report "expected dec_out=0000000010"
      severity error;
    assert(out_div10 = '1')
      report "expected div10=1"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_dec_out = "0000000100")
      report "expected dec_out=0000000100"
      severity error;
    assert(out_div10 = '1')
      report "expected div10=1"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_dec_out = "0000001000")
      report "expected dec_out=0000001000"
      severity error;
    assert(out_div10 = '1')
      report "expected div10=1"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_dec_out = "0000010000")
      report "expected dec_out=0000010000"
      severity error;
    assert(out_div10 = '1')
      report "expected div10=1"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_dec_out = "0000100000")
      report "expected dec_out=0000100000"
      severity error;
    assert(out_div10 = '0')
      report "expected div10=0"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_dec_out = "0001000000")
      report "expected dec_out=0001000000"
      severity error;
    assert(out_div10 = '0')
      report "expected div10=0"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_dec_out = "0010000000")
      report "expected dec_out=0010000000"
      severity error;
    assert(out_div10 = '0')
      report "expected div10=0"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_dec_out = "0100000000")
      report "expected dec_out=0100000000"
      severity error;
    assert(out_div10 = '0')
      report "expected div10=0"
      severity error; 
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_dec_out = "1000000000")
      report "expected dec_out=1000000000"
      severity error;
    assert(out_div10 = '0')
      report "expected div10=0"
      severity error; 
    wait until rising_edge(in_clk);
        wait for TIME_AFTER_EDGE;
    assert(out_dec_out = "0000000001")
      report "expected dec_out=0000000001"
      severity error;
    assert(out_div10 = '1')
      report "expected div10=1"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_dec_out = "0000000010")
      report "expected dec_out=0000000010"
      severity error;
    assert(out_div10 = '1')
      report "expected div10=1"
      severity error;
    in_en <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_dec_out = "0000000010")
      report "expected dec_out=0000000010"
      severity error;
    assert(out_div10 = '1')
      report "expected div10=1"
      severity error;
    
    report "Tests completed"
      severity note;
    wait; --done

  end process;
end architecture;
