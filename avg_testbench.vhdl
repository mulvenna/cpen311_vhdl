-- testbench for spring/summer 2014 final exam question 4
library IEEE;
use IEEE.std_logic_1164.all;

entity avg_testbench is
end entity;

architecture stimulus of avg_testbench is
  component avg is
    port (clk, reset : in std_logic;
          instream : in std_logic_vector(7 downto 0);
          valid : out std_logic;
          outstream : out std_logic_vector(7 downto 0));
  end component;

  signal in_clk : std_logic := '0'; -- must be initialized for clk_gen to work
  signal in_reset, out_valid : std_logic;
  signal in_instream : std_logic_vector(7 downto 0);
  signal out_outstream : std_logic_vector(7 downto 0);

  type byte_array is array (0 to 9) of std_logic_vector(7 downto 0);
  constant outstream_array : byte_array := ("00000100", "00000101",
                                            "00000100", "00000011",
                                            "00000010", "00000001",
                                            "00000010", "00000100",
                                            "00000101", "00000101");
  constant instream_array : byte_array := ("00000110", "00000001",
                                           "00000000", "00000001",
                                           "00000010", "00001000",
                                           "00000110", "00000100",
                                           "00000101", "00000000");

  constant HALF_CLK_PERIOD : time := 5ns; -- assume TIME_AFTER_EDGE < HALF_CLK_PERIOD
  constant TIME_AFTER_EDGE : time := 2ns; -- used to set inputs or assert shortly after an edge
begin
  DUT : avg port map(clk => in_clk, reset => in_reset, instream => in_instream, 
                     valid => out_valid, outstream => out_outstream);

  clk_gen : process
  begin
    wait for HALF_CLK_PERIOD;
    in_clk <= not in_clk;
  end process;

  reset_pulse : process
  begin
    in_reset <= '0';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    wait for HALF_CLK_PERIOD; --this extra delay is to more closely match the example waveform in the problem statement
    in_reset <= '1';
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    wait for HALF_CLK_PERIOD;
    in_reset <= '0';
    wait;
  end process;

  test : process
  begin
    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    wait for HALF_CLK_PERIOD;
    in_instream <= "00000010";

    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_valid = '0')
      report "valid was not 0"
      severity error;
    wait for HALF_CLK_PERIOD;
    in_instream <= "00000101";

    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_valid = '0')
      report "valid was not 0"
      severity error;
    wait for HALF_CLK_PERIOD;
    in_instream <= "00000011";

    wait until rising_edge(in_clk);
    wait for TIME_AFTER_EDGE;
    assert(out_valid = '0')
      report "valid was not 0"
      severity error;
    wait for HALF_CLK_PERIOD;
    in_instream <= "00000110";

    --outstream should be valid after four elements have been received
    for i in 0 to 9 loop
      wait until rising_edge(in_clk);
      wait for TIME_AFTER_EDGE;
      assert(out_valid = '1')
        report "valid was not 1 at loop iteration " & integer'image(i)
        severity error;
      assert(out_outstream = outstream_array(i))
        report "outstream value error at loop iteration " & integer'image(i)
        severity error;
      wait for HALF_CLK_PERIOD;
      in_instream <= instream_array(i);
    end loop;

    report "Tests completed"
      severity note;
    wait; -- done
  end process;
end architecture;
