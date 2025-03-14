library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC is
    Port ( clk : in STD_LOGIC;
    sel : out STD_LOGIC;
    clk_sb : out STD_LOGIC;
    clk_mc : out STD_LOGIC;
    clk_ak : out STD_LOGIC;
    en : out STD_LOGIC);
end PC;

architecture Behavioral of PC is
    signal a : unsigned(1 downto 0) := (others => '0');
    signal c,d,e,f,g : std_logic := '0';
    signal b : std_logic_vector(1 downto 0);
begin
    count : process(clk)
    begin
        if falling_edge(clk) then
            a <= a + 1;
        end if;
    end process;
   
    selection : process(clk)
    begin
        if falling_edge(clk) then
            g <= '1';
        end if;
    end process;
    sel <= g;
   
    b <= std_logic_vector(a);
    c <= b(0) nor b(1);
    d <= b(0) xor b(1);
    e <= b(0) and b(1);
    en <= c;
    --en_out <= b(0) nor b(1);
    clk_sb <= clk and c ;    
    clk_mc <= clk and d ;    
    clk_ak <= clk and e ;    
    --check : process(c)
    --begin
    --    if rising_edge(c) then
    --        if b = "1010" then
    --            b <= "0000";
    --        else
    --            b <= b + 1;
    --        end if;
    --    end if;
    --end process;
    --e <= std_logic_vector(b);
    --f <= e(2) nand e(0);
    --g <= e(3) and e(1);
    --sel_out <= f and g ;
   
end Behavioral;