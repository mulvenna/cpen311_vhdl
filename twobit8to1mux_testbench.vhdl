-- testbench for summer 2015 assignment 1 question 1

library ieee;
use ieee.std_logic_1164.all;

entity mux_testbench is
end mux_testbench;

architecture stimulus of mux_testbench is

    --Declare the DUT
    component mux is
        port (a, b, c, d, e, f, g, h : in std_logic_vector(1 downto 0);
              sel                    : in std_logic_vector(2 downto 0);
              outm                   : out std_logic_vector(1 downto 0));
    end component;

    --Signals that connect to the ports of the DUT
    signal in_a, in_b, in_c, in_d, in_e, in_f, in_g,
           in_h : std_logic_vector(1 downto 0);
    signal in_sel : std_logic_vector(2 downto 0);
    signal out_outm : std_logic_vector(1 downto 0);
    constant WAIT_TIME : time := 5ns;

begin

    --Instantiate the DUT
    DUT: mux
         port map (a => in_a, b => in_b, c => in_c, d => in_d,
                   e => in_e, f => in_f, g => in_g, h => in_h,
                   sel => in_sel, outm => out_outm);

    test : process
    begin
        in_a <= "00";
        in_b <= "XX";
        in_c <= "XX";
        in_d <= "XX";
        in_e <= "XX";
        in_f <= "XX";
        in_g <= "XX";
        in_h <= "XX";
        in_sel <= "000";
        wait for WAIT_TIME;
        assert (out_outm = "00")
            report "did not read 00 when sel=000 and a=00"
            severity error;

        in_a <= "XX";
        in_b <= "01";
        in_sel <= "001";
        wait for WAIT_TIME;
        assert (out_outm = "01")
            report "did not read 01 when sel=001 and b=01"
            severity error;

        in_b <= "XX";
        in_c <= "10";
        in_sel <= "010";
        wait for WAIT_TIME;
        assert (out_outm = "10")
            report "did not read 10 when sel=010 and c=10"
            severity error;
        
        in_c <= "XX";
        in_d <= "11";
        in_sel <= "011";
        wait for WAIT_TIME;
        assert (out_outm = "11")
            report "did not read 11 when sel=011 and d=11"
            severity error;

        in_d <= "XX";
        in_e <= "10";
        in_sel <= "100";
        wait for WAIT_TIME;
        assert (out_outm = "10")
            report "did not read 10 when sel=100 and e=10"
            severity error;

        in_e <= "XX";
        in_f <= "01";
        in_sel <= "101";
        wait for WAIT_TIME;
        assert (out_outm = "01")
            report "did not read 01 when sel=101 and f=01"
            severity error;

        in_f <= "XX";
        in_g <= "00";
        in_sel <= "110";
        wait for WAIT_TIME;
        assert (out_outm = "00")
            report "did not read 00 when sel=110 and g=00"
            severity error;

        in_g <= "XX";
        in_h <= "11";
        in_sel <= "111";
        wait for WAIT_TIME;
        assert (out_outm = "11")
            report "did not read 11 when sel=111 and h=11"
            severity error;

       report "Tests completed without errors"
           severity note;

       wait; --done
    end process;
end architecture;
