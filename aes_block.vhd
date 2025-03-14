library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.vcomponents.all;
library UNIMACRO;
use UNIMACRO.vcomponents.all;

entity aes_block is
    Port (
        clk : in std_logic;
        data_in, key : in std_logic_vector(127 downto 0);
        data_out : out std_logic_vector(127 downto 0)
        );
end aes_block;

architecture Behavioral of aes_block is
signal block_in : std_logic_vector(127 downto 0);
signal cipher_out : std_logic_vector(127 downto 0);
signal addkey_output : std_logic_vector(127 downto 0);
signal subbox_output : std_logic_vector(127 downto 0);
signal shiftrows_output : std_logic_vector(127 downto 0);
signal mixcolumns_output : std_logic_vector(127 downto 0);
signal reg_out : std_logic_vector(127 downto 0) := (others => '0');
signal clk_sb, clk_mc, clk_ak , enable, sel: std_logic;
begin
    
    mux_route: entity work.ok
    port map (
        a => data_in,
        b => cipher_out,
        sel => sel,
        c => block_in
    );

    byte_sub: entity work.sub_byte
    port map (
        input_data => block_in,
        output_data => subbox_output,
        clk => clk_sb
    );

    shifting_rows: entity work.shift_rows
    port map (
        input_128 => subbox_output,
        output_128 => shiftrows_output
    );

    mix_columns: entity work.mixcolumns
    port map (
        cipher_in => shiftrows_output,
        clk => clk_mc,
        cipher_out => mixcolumns_output
    );

    addkey_output <= mixcolumns_output xor key;
   
    process(clk_ak, reg_out)
    begin
            if rising_edge(clk_ak) then
                reg_out <= addkey_output;
            end if;
    end process;
   
    process(enable)
    begin
        if enable = '1' then
                cipher_out <= reg_out;
        else
             cipher_out <= (others => 'Z');
        end if;
    end process;
   
    control : entity work.PC
    port map (
        clk => clk,
        clk_sb => clk_sb,
        clk_mc => clk_mc,
        clk_ak => clk_ak,
        en => enable,
        sel => sel
    );
 
    data_out <=  reg_out;  

end Behavioral;
