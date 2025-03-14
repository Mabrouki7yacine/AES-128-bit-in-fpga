library ieee;
use ieee.std_logic_1164.all;
library UNISIM;
use UNISIM.VComponents.all;

entity sub_byte is
	port (
	    input_data : in std_logic_vector(127 downto 0);
	    output_data : out std_logic_vector(127 downto 0);
		clk : in std_logic
	);
end sub_byte;

architecture behavioral of sub_byte is
	signal temp : std_logic_vector(127 downto 0);
begin

	gen : for i in 0 to 15 generate
		sbox_inst : entity work.sbox
			port map(
				input_byte  => input_data((i + 1)*8 - 1 downto i*8),
				output_byte => temp((i + 1)*8 - 1 downto i*8)
			);		
	end generate gen;
	

	process(clk)
	begin
		if rising_edge(clk)then
            output_data <= temp;
		end if;
	end process;
    
end architecture behavioral;