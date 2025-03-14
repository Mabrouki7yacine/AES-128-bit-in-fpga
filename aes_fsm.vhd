library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity aes_fsm is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           aes_block_clk : out STD_LOGIC;
           init_en : out STD_LOGIC;
           last_en : out STD_LOGIC
           );
end aes_fsm;

architecture Behavioral of aes_fsm is

    type state_type is (init, AES_block, last, idle);
    signal current_state, next_state: state_type;

    signal temp : STD_LOGIC := '0';
    signal counter: INTEGER range 0 to 36 := 0;


begin
    
    process(clk, rst, counter, current_state)
    begin
        if rst = '1' then
            current_state <= init;
            counter <= 0;
        elsif falling_edge(clk) then
            case current_state is
                when init =>
                    if counter = 0 then
                        current_state <= next_state;
                        counter <= 0;
                    else
                        counter <= counter + 1;
                    end if;
                when AES_block =>
                    if counter = 35 then
                        current_state <= next_state;
                        counter <= 0;
                    else
                        counter <= counter + 1;
                    end if;
                when last =>
                    if counter = 1 then
                        current_state <= next_state;
                        counter <= 0;
                    else
                        counter <= counter + 1;
                    end if;
                when idle =>
                        current_state <= next_state;
                when others =>
                    current_state <= idle;
            end case;
        end if;
    end process;

    process(current_state, clk, temp)
    begin
        case current_state is
            when init =>
                init_en <= clk;
                aes_block_clk <= '0';
                last_en <= '0';
                next_state <= AES_block;
            when AES_block =>
                init_en <= '0';
                aes_block_clk <= clk;
                last_en <= '0';
                next_state <= last;
            when last =>
                init_en <= '0';
                aes_block_clk <= '0';
                last_en <= clk;
                next_state <= idle;
            when idle =>
                init_en <= '0';
                aes_block_clk <= '0';
                last_en <= '0';
                next_state <= idle;
            when others =>
                init_en <= '0';
                aes_block_clk <= '0';
                last_en <= '0';
                next_state <= idle;
        end case;
    end process;

end Behavioral;
