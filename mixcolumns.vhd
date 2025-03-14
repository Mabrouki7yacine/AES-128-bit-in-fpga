library ieee;
use ieee.std_logic_1164.all;

entity mixcolumns is
    port (
        cipher_in : in std_logic_vector(127 downto 0);
        clk : in std_logic;
        cipher_out : out std_logic_vector(127 downto 0)
    );
end mixcolumns;

architecture behavioral of mixcolumns is
    type matrix_4x4 is array (0 to 3, 0 to 3) of std_logic_vector(7 downto 0);
    signal temp_in : matrix_4x4 ;
    signal  temp_out : matrix_4x4;
begin

    -- Assigning the input vector to the matrix
    gen_assign_input: for i in 0 to 3 generate
        temp_in(0, i) <= cipher_in((i+1)*8-1 downto i*8);
        temp_in(1, i) <= cipher_in((i+1)*8-1 + 32 downto i*8 + 32);
        temp_in(2, i) <= cipher_in((i+1)*8-1 + 64 downto i*8 + 64);
        temp_in(3, i) <= cipher_in((i+1)*8-1 + 96 downto i*8 + 96);
    end generate;

    -- Generating the mixcolumn instances
    gen_mixcolumn: for i in 0 to 3 generate
        mxc_inst0: entity work.column_calc
        port map(
            S0  => temp_in(2, i),
            S1  => temp_in(3, i),
            S2  => temp_in(0, i),
            S3  => temp_in(1, i),
            clk => clk,
            p0  => temp_out(0, i)
        );

        mxc_inst1: entity work.column_calc
        port map(
            S0  => temp_in(0, i),
            S1  => temp_in(3, i),
            S2  => temp_in(1, i),
            S3  => temp_in(2, i),
            clk => clk,
            p0  => temp_out(1, i)
        );

        mxc_inst2: entity work.column_calc
        port map(
            S0  => temp_in(0, i),
            S1  => temp_in(1, i),
            S2  => temp_in(2, i),
            S3  => temp_in(3, i),
            clk => clk,
            p0  => temp_out(2, i)
        );

        mxc_inst3: entity work.column_calc
        port map(
            S0  => temp_in(2, i),
            S1  => temp_in(1, i),
            S2  => temp_in(3, i),
            S3  => temp_in(0, i),
            clk => clk,
            p0  => temp_out(3, i)
        );
    end generate;

    -- Reconstruct the output cipher from the temp_out matrix
    gen_assign_output: for i in 0 to 3 generate
        cipher_out((i+1)*8-1 downto i*8) <= temp_out(0, i);
        cipher_out((i+1)*8-1 + 32 downto i*8 + 32) <= temp_out(1, i);
        cipher_out((i+1)*8-1 + 64 downto i*8 + 64) <= temp_out(2, i);
        cipher_out((i+1)*8-1 + 96 downto i*8 + 96) <= temp_out(3, i);
    end generate;
    
end architecture behavioral;
