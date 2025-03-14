library ieee;
use ieee.std_logic_1164.all;

entity shift_rows is
	port (
		input_128 : in std_logic_vector(127 downto 0);
		output_128 : out std_logic_vector(127 downto 0)
	);
end shift_rows;
--shift_rows
architecture behavioral of shift_rows is
	signal temp_128 : std_logic_vector(127 downto 0);
begin

	temp_128(007 downto 000) <= input_128(007 downto 000);
	temp_128(015 downto 008) <= input_128(015 downto 008);
	temp_128(023 downto 016) <= input_128(023 downto 016);
	temp_128(031 downto 024) <= input_128(031 downto 024);
	temp_128(039 downto 032) <= input_128(047 downto 040);
	temp_128(047 downto 040) <= input_128(055 downto 048);
	temp_128(055 downto 048) <= input_128(063 downto 056);
	temp_128(063 downto 056) <= input_128(039 downto 032);
	temp_128(071 downto 064) <= input_128(087 downto 080);
	temp_128(079 downto 072) <= input_128(095 downto 088);
	temp_128(087 downto 080) <= input_128(071 downto 064);
	temp_128(095 downto 088) <= input_128(079 downto 072);
	temp_128(103 downto 096) <= input_128(127 downto 120);
	temp_128(111 downto 104) <= input_128(103 downto 096);
	temp_128(119 downto 112) <= input_128(111 downto 104);
	temp_128(127 downto 120) <= input_128(119 downto 112);

	output_128 <= temp_128;
	
end architecture behavioral;
