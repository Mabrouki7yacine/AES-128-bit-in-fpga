library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.vcomponents.all;
library UNIMACRO;
use UNIMACRO.vcomponents.all;

entity mult2x3 is
    Port ( a,b : in  STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           c : out  STD_LOGIC_VECTOR (7 downto 0));
end mult2x3;

architecture Behavioral of mult2x3 is

    signal p,o,n : STD_LOGIC_VECTOR (7 downto 0);
    signal shifted_byte, conditional_xor: STD_LOGIC_VECTOR (7 downto 0);
begin

shifted_byte <= a(6 downto 0) & "0";
conditional_xor <= "000" & a(7) & a(7) & "0" & a(7) & a(7);
n <= shifted_byte xor conditional_xor;
	
process(b)
begin
    if b(7) = '0' then
        o <= b xor b(6 downto 0) & '0';
    else
        o <= b xor b(6 downto 0) & '0' xor "00011011";
    end if;
end process;

p <= n xor o;

-- register
process(clk)
begin
    if rising_edge(clk) then
        c <= p;
    end if;
end process;

end Behavioral;

