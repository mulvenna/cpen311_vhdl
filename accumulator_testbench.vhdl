-- testbench for summer 2015 assignment 3 question 6
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity accumulator_testbench is
end entity;

architecture stimulus of accumulator_testbench is
  component accumulator is
    port(clk, reset, valid : in std_logic;
         data : in std_logic_vector(15 downto 0);
         sum : out std_logic_vector(15 downto 0));
  end component;
  
  signal in_clk, in_reset, in_valid : std_logic;
  signal in_data, out_sum : std_logic_vector(15 downto 0);

  constant LOOP_LIMIT : integer := 10;
  constant AMOUNT_PER_ITERATION : std_logic_vector(15 downto 0) := "0101010101010101";
  constant HALF_CLK_PERIOD : time := 5ns;
begin
  DUT : accumulator port map(clk => in_clk, reset => in_reset,
                            valid => in_valid, data => in_data,
                            sum => out_sum);

  test : process
    variable expected_sum : unsigned(15 downto 0);
  begin
    --sync reset
    --initialize
    in_reset <= '1';
    in_clk <= '0';
    wait for HALF_CLK_PERIOD;
    in_clk <= '1';
    wait for HALF_CLK_PERIOD;
    expected_sum := (others => '0');
    assert(out_sum = std_logic_vector(expected_sum))
      report "reset error, could not initialize with 0s"
      severity error;
    in_reset <= '0';

    --valid=1
    --sample and add some numbers
    --assume overflow does not happen
    in_valid <= '1';
    in_data <= AMOUNT_PER_ITERATION;
    for i in 0 to LOOP_LIMIT loop
      in_clk <= '0';
      wait for HALF_CLK_PERIOD;
      in_clk <= '1';
      wait for HALF_CLK_PERIOD;
      expected_sum := expected_sum + unsigned(in_data);
      assert(out_sum = std_logic_vector(expected_sum))
        report "sum error during loop iteration " & integer'image(i)
        severity error;
    end loop;

    --sync reset again
    --data line should be ignored when resetting
    in_reset <= '1';
    in_clk <= '0';
    wait for HALF_CLK_PERIOD;
    in_clk <= '1';
    wait for HALF_CLK_PERIOD;
    expected_sum := (others => '0');
    assert(out_sum = std_logic_vector(expected_sum))
      report "reset error, data line was not ignored"
      severity error;
    in_reset <= '0';

    --valid=0
    --should not accumulate
    in_valid <= '0';
    in_clk <= '0';
    wait for HALF_CLK_PERIOD;
    in_clk <= '1';
    wait for HALF_CLK_PERIOD;
    assert(out_sum = std_logic_vector(expected_sum))
      report "valid error, accumulated when valid=0"
      severity error;
    in_reset <= '0';

    report "Tests completed without errors"
      severity note;
    wait; --done
  end process;
end architecture;
