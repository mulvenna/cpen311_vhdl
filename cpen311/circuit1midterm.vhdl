-- midterm feb 2015, question 2

library IEEE;
use IEEE.std_logic_1164.all;

entity CIRCUIT1 is
  port ( A, B, D, CLK : in  std_logic;
         Y            : out std_logic);
end CIRCUIT1;

architecture ARCH of CIRCUIT1 is
  signal F, G, H, T : std_logic;
begin

  --MUX
  process (B, G, A)
  begin
    if (B = '1') then
      F <= G;
    else
      F <= A;
    end if;
  end process;

  --flip-flops
  process (CLK)
  begin
    if (rising_edge(CLK)) then
      T <= F;
      H <= D;
    end if;
  end process;

  --AND gate
  G <= H and T;

  --tristate buffer
  process (G, H)
  begin
    if (H = '1') then
      Y <= G;
    else
      Y <= 'Z';
    end if;
  end process;

end ARCH;
