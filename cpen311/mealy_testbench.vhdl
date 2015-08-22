-- testbench for summer 2015 assignment 2 question 2

library ieee;
use ieee.std_logic_1164.all;

entity mealy_testbench is
end mealy_testbench;

architecture stimulus of mealy_testbench is

    --Declare the DUT
    component mealy is
        port (a, b, clk : in std_logic;
              z        : out std_logic);
    end component;

    --Signals that connect to the ports of the DUT
    signal in_a   : std_logic;
    signal in_b   : std_logic;
    signal in_clk : std_logic;
    signal out_z  : std_logic;
    constant WAIT_TIME : time := 5ns;

begin

    --Instantiate the DUT
    DUT: mealy
         port map (a => in_a, b => in_b, clk => in_clk, z => out_z);

    test : process
    begin
        in_a <= '0';
        in_b <= '0';
        in_clk <= '0';
        wait for WAIT_TIME;
        in_clk <= '1';
        wait for WAIT_TIME;
        --flip-flop now has value 0

        in_a <= '0';
        in_b <= '0';
        in_clk <= '0';
        wait for WAIT_TIME;
        in_clk <= '1';
        wait for WAIT_TIME;
        assert (out_z = '0')
            report "assert 1 failed"
            severity error;

        in_a <= '1';
        in_b <= '0';
        in_clk <= '0';
        wait for WAIT_TIME;
        assert (out_z = '1')
            report "assert 2 failed"
            severity error;
        in_clk <= '1';
        wait for WAIT_TIME;
        assert (out_z = '1')
            report "assert 3 failed"
            severity error;

        in_a <= '1';
        in_b <= '1';
        in_clk <= '0';
        wait for WAIT_TIME;
        assert (out_z = '1')
            report "assert 4 failed"
            severity error;
        in_clk <= '1';
        wait for WAIT_TIME;
        assert (out_z = '0')
            report "assert 5 failed"
            severity error;

        in_a <= '0';
        in_b <= '1';
        in_clk <= '0';
        wait for WAIT_TIME;
        assert (out_z = '1')
            report "assert 6 failed"
            severity error;
        in_clk <= '1';
        wait for WAIT_TIME;
        assert (out_z = '0')
            report "assert 7 failed"
            severity error;

       wait; --done
    end process;
end architecture;
