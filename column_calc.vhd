library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.vcomponents.all;
library UNIMACRO;
use UNIMACRO.vcomponents.all;

entity column_calc is
    Port (
        S0,S1,S2,S3 : in  STD_LOGIC_VECTOR (7 downto 0);
        clk : in STD_LOGIC;
        p0 : out STD_LOGIC_VECTOR (7 downto 0)
    );
end column_calc;

architecture Behavioral of column_calc is

    component mult2x3 is 
        port (
            a, b : in  STD_LOGIC_VECTOR (7 downto 0);
            clk : in STD_LOGIC;
            c : out  STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    component xoreg is
        port(
            a, b : in  STD_LOGIC_VECTOR (7 downto 0);
            clk : in STD_LOGIC;
            c : out  STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    signal temp0 : STD_LOGIC_VECTOR (7 downto 0);
    signal hold0 : STD_LOGIC_VECTOR (7 downto 0);

begin

    STAGE0: mult2x3
        port map(
            a  => S2,
            b  => S3,
            clk => clk,
            c  => temp0 );

    STAGE1: xoreg
        port map(
            a  => S0,
            b  => S1,
            clk => clk,
            c  => hold0 );	

    STAGE2: xoreg
        port map(
            a  => hold0,
            b  => temp0,
            clk => clk,
            c  => p0 );	

end Behavioral;
