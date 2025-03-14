library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xoreg is
    Port ( a,b : in STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           c : out STD_LOGIC_VECTOR (7 downto 0));
end xoreg;

architecture Behavioral of xoreg is
signal temp : std_logic_vector (7 downto 0);
begin
    temp <= a xor b; 
    process(clk)
    begin 
        if rising_edge(clk) then
            c <= temp;
        end if;
    end process;
end Behavioral;