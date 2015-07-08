-- testbench for summer 2015 assignment 2 question 3

library ieee;
use ieee.std_logic_1164.all;

entity jkff_testbench is
end jkff_testbench;

architecture stimulus of jkff_testbench is

    --Declare the DUT
    component jkff is
        port (J, K, CLK : in std_logic;
              Q        : out std_logic);
    end component;

    --Signals that connect to the ports of the DUT
    signal in_j   : std_logic;
    signal in_k   : std_logic;
    signal in_clk : std_logic;
    signal out_q  : std_logic;
    constant WAIT_TIME : time := 5ns;

begin

    --Instantiate the DUT
    DUT: jkff
         port map (J => in_j, K => in_k, CLK => in_clk, Q => out_q);

    test : process
    begin
        in_j <= '0';
        in_k <= '1';
        in_clk <= '0';
        wait for WAIT_TIME;
        in_clk <= '1';
        wait for WAIT_TIME;
        --assert out_q is 0
        assert (out_q = '0')
            report "Q was not set to 0"
            severity error;

        in_j <= '0';
        in_k <= '0';
        in_clk <= '0';
        wait for WAIT_TIME;
        in_clk <= '1';
        wait for WAIT_TIME;
        --assert out_q is 0 (previous value)
        assert (out_q = '0')
            report "Q did not stay at 0"
            severity error;

        in_j <= '1';
        in_k <= '0';
        in_clk <= '0';
        wait for WAIT_TIME;
        in_clk <= '1';
        wait for WAIT_TIME;
        --assert out_q is 1
        assert (out_q = '1')
            report "Q was not set to 1"
            severity error;

        in_j <= '0';
        in_k <= '0';
        in_clk <= '0';
        wait for WAIT_TIME;
        in_clk <= '1';
        wait for WAIT_TIME;
        --assert out_q is 1 (previous value)
        assert (out_q = '1')
            report "Q did not stay at 1"
            severity error;

        in_j <= '1';
        in_k <= '1';
        in_clk <= '0';
        wait for WAIT_TIME;
        in_clk <= '1';
        wait for WAIT_TIME;
        --assert out_q is 0 (inverse of previous value)
        assert (out_q = '0')
            report "Q did not invert to 0"
            severity error;

        in_clk <= '0';
        wait for WAIT_TIME;
        in_clk <= '1';
        wait for WAIT_TIME;
        --assert out_q is 1 (inverse of previous value)
        assert (out_q = '1')
            report "Q did not invert to 1"
            severity error;

       wait; --done
    end process;
end architecture;
