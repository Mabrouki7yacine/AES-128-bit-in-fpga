library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.vcomponents.all;
library UNIMACRO;
use UNIMACRO.vcomponents.all;
use IEEE.NUMERIC_STD.ALL;

entity main is
    Port (
        clk : in std_logic;
        data_in : in std_logic_vector(127 downto 0);
	cipher_text : out std_logic_vector(127 downto 0)
        );
end main;

architecture Behavioral of main is
signal block_in, block_out, data_out : std_logic_vector(127 downto 0);
--signal data_in : std_logic_vector(127 downto 0):= x"30313233343536373839616263646566";
signal addkey_init, addkey_last : std_logic_vector(127 downto 0);
signal subbox_output : std_logic_vector(127 downto 0);
signal shiftrows_output : std_logic_vector(127 downto 0);
signal init_key : std_logic_vector(127 downto 0) := X"30313233343536373839616263646566";
signal last_key : std_logic_vector(127 downto 0) := X"e062aeb9aae721032569d159f1062171";
signal key : std_logic_vector(127 downto 0);
signal a : unsigned(1 downto 0) := (others => '0');
signal b : std_logic_vector(1 downto 0);
signal c : std_logic;
signal d : unsigned(3 downto 0) := (others => '0');
signal init_clk, aes_clk, last_clk: std_logic;
begin

    -- first add round key
    addkey_init <= data_in xor init_key;
   
    store_in : process(init_clk, addkey_init)
    begin
            if rising_edge(init_clk) then
                block_in <= addkey_init;
            end if;
    end process;

    rounds_1_to_9 : entity work.aes_block
    port map (
        data_in => block_in,
        key => key,
        clk => aes_clk,
        data_out => block_out
    );

    byte_sub_last_round: entity work.sub_byte
    port map (
        input_data => block_out,
        output_data => subbox_output,
        clk => last_clk
    );

    shifting_rows_last_round: entity work.shift_rows
    port map (
        input_128 => subbox_output,
        output_128 => shiftrows_output
    );
    -- last add round key
    addkey_last <= shiftrows_output xor last_key;
   
    store_out :process(last_clk, addkey_last)
    begin
            if rising_edge(last_clk) then
                data_out <= addkey_last;
            end if;
    end process; 

    controlling: entity work.aes_fsm
    port map (
        clk => clk,
        rst => '0',
        aes_block_clk => aes_clk,
        init_en => init_clk,
        last_en => last_clk
    );
    
    process(aes_clk, a)
    begin
        if falling_edge(aes_clk) then
            a <= a + 1;
        end if;
    end process;
    b <= std_logic_vector(a);
    c <= b(0) nor b(1);
    
    process(c, d)
    begin
        if falling_edge(c) then
            d <= d + 1;
        end if;
    end process;
        
    -- each key is associated to each round  
    process(d)
    begin
        case d is
            when "0000" =>
                key <= x"30313233343536373839616263646566";
            when "0001" =>
                key <= x"9c5dc722ac6cf5119859c326a060a244";
            when "0010" =>
                key <= x"9bd61f95078bd8b7abe72da633beee80";
            when "0011" =>
                key <= x"2e10f2c0b5c6ed55b24d35e219aa1844";
            when "0100" =>
                key <= x"8a00f8b2a4100a7211d6e727a39bd2c5";
            when "0101" =>
                key <= x"ab23a47321235cc1853356b394e5b194";
            when "0110" =>
                key <= x"14b439fcbf979d8f9eb4c14e1b8797fd";
            when "0111" =>
                key <= x"9eea7f928a5e466e35c9dbe1ab7d1aaf";
            when "1000" =>
                key <= x"c50b7fe05be10072d1bf461ce4769dfd";
            when "1001" =>
                key <= x"4a858fba8f8ef05ad46ff02805d0b634";            
            when others =>
                key <= x"00000000000000000000000000000000";
        end case;
    end process;
    cipher_text <= data_out;

end Behavioral;
