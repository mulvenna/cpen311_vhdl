-- testbench for midterm feb 2015 question 2

library ieee;
use ieee.std_logic_1164.all;

entity circuit1_testbench is
end circuit1_testbench;

architecture stimulus of circuit1_testbench is

    --Declare the DUT
    component circuit1 is
        port (a, b, d, clk : in std_logic;
              y            : out std_logic);
    end component;

    --Signals that connect to the ports of the DUT
    signal in_a   : std_logic;
    signal in_b   : std_logic;
    signal in_d   : std_logic;
    signal in_clk : std_logic;
    signal out_y  : std_logic;
    constant WAIT_TIME : time := 5ns;

begin

    --Instantiate the DUT
    DUT: circuit1
         port map (a => in_a,
                   b => in_b,
                   d => in_d,
                   clk => in_clk,
                   y => out_y);

    test : process
    begin
        in_a <= '0';
        in_b <= '0';
        in_d <= '0';
        in_clk <= '0';
        wait for WAIT_TIME;
        in_clk <= '1';
        wait for WAIT_TIME;
        --flip-flops: top = 0, bottom = 0
        assert (out_y = 'Z')
            report "assert 1 failed"
            severity error;

        in_a <= '1';
        in_clk <= '0';
        wait for WAIT_TIME;
        in_clk <= '1';
        wait for WAIT_TIME;
        --flip-flops: top = 1, bottom = 0
        assert (out_y = 'Z')
            report "assert 2 failed"
            severity error;

        in_a <= '0';
        in_d <= '1';
        in_clk <= '0';
        wait for WAIT_TIME;
        in_clk <= '1';
        wait for WAIT_TIME;
        --flip-flops: top = 0, bottom = 1
        assert (out_y = '0')
            report "assert 3 failed"
            severity error;

        in_a <= '1';
        in_clk <= '0';
        wait for WAIT_TIME;
        in_clk <= '1';
        wait for WAIT_TIME;
        --flip-flops: top = 1, bottom = 1
        assert (out_y = '1')
            report "assert 4 failed"
            severity error;

        in_a <= 'X';
        in_b <= '1';
        in_d <= '1';
        in_clk <= '0';
        wait for WAIT_TIME;
        in_clk <= '1';
        wait for WAIT_TIME;
        --flip-flops: top = 1, bottom = 1
        assert (out_y = '1')
            report "assert 5 failed"
            severity error;

        in_d <= '0';
        in_clk <= '0';
        wait for WAIT_TIME;
        in_clk <= '1';
        wait for WAIT_TIME;
        --flip-flops: top = 1, bottom = 0
        assert (out_y = 'Z')
            report "assert 6 failed"
            severity error;

        in_d <= '1';
        in_clk <= '0';
        wait for WAIT_TIME;
        in_clk <= '1';
        wait for WAIT_TIME;
        --flip-flops: top = 0, bottom = 1
        assert (out_y = '0')
            report "assert 7 failed"
            severity error;

        report "Tests completed without errors"
            severity note;

        wait; --done
    end process;
end architecture;
