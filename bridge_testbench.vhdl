-- testbench for summer 2014 midterm question 4
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bridge_testbench is
end entity;

architecture stimulus of bridge_testbench is
  component bridge is
    port(clk, load, drive, shift : in std_logic;
         bus1 : in std_logic_vector(15 downto 0);
         bus2 : out std_logic);
  end component;

  signal in_clk : std_logic := '0'; --must initialize for clk_gen
  signal in_load, in_drive, in_shift, out_bus2 : std_logic;
  signal in_bus1 : std_logic_vector(15 downto 0);

  constant HALF_CLK_PERIOD : time := 5ns; --assume HALF_CLK_PERIOD > TIME_AFTER_EDGE
  constant TIME_AFTER_EDGE : time := 2ns;
begin
  DUT : bridge port map(clk => in_clk, load => in_load, drive => in_drive,
                 shift => in_shift, bus1 => in_bus1, bus2 => out_bus2);

  clk_gen : process
  begin
    wait for HALF_CLK_PERIOD;
    in_clk <= not in_clk;
  end process;

  test : process
  begin
    --bridge circuit serializes data onto a single-bit bus
    --on rising clk edge, if load is high, value on bus1 loaded into reg
    --while drive is low, bus2 is high-impedance/Z (independent of clock)
    in_load <= '1';
    in_shift <= '0';
    in_bus1 <= "1010101010101010";
    wait until rising_edge(in_clk);
    in_drive <= '0';
    wait for TIME_AFTER_EDGE;
    assert(out_bus2 = 'Z')
      report "expected bus2=Z while drive=0 (not synchronized to clock)"
      severity error;
    --any time that drive is high (independent of clk), reg bit 0 is driven to bus2
    in_drive <= '1';
    wait for TIME_AFTER_EDGE;
    assert(out_bus2 = '0')
      report "expected bus2=0 while drive=1 (not synchronized to clock)"
      severity error;
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_bus2 = '0')
      report "expected bus2=0 due to register value not being shifted"
      severity error;
    --on rising clk edge, if shift is high, value on reg is shifter to right
    --ASSUMPTION: we don't care what value is shifted in since it isn't used to serialize
    in_load <= '0';
    in_shift <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_bus2 = '1')
      report "expected bus2=1 due to register value being shifted"
      severity error;

    --if both load and shift are high on rising edge, load in new value and ignore shift
    in_load <= '1';
    in_bus1 <= "0000111100000001";
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_bus2 = '1')
      report "expected bus2=1 for new value, shift should be ignored"
      severity error;
    in_load <= '0';
    --continue shifting the first half of the data
    for i in 1 to 7 loop
      wait until rising_edge(in_clk);
      wait for TIME_AFTER_EDGE;
      assert(out_bus2 = '0')
        report "expected bus2=0"
        severity error;
    end loop;
    --check the 1's in the third quarter of the data
    for i in 8 to 11 loop
      wait until rising_edge(in_clk);
      wait for TIME_AFTER_EDGE;
      assert(out_bus2 = '1')
        report "expected bus2=1"
        severity error;
    end loop;
    --check the 0's in the fourth quarter of the data
    for i in 12 to 15 loop
      wait until rising_edge(in_clk);
      wait for TIME_AFTER_EDGE;
      assert(out_bus2 = '0')
        report "expected bus2=0"
        severity error;
    end loop;

    report "Tests completed"
      severity note;
    wait; --done
  end process;
end architecture;
