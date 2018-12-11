library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity shifter is
	port(
		B_s : in std_logic_vector(15 downto 0);
		H_select_s : in std_logic_vector(1 downto 0);
		H_s : out std_logic_vector(15 downto 0)
	);
end shifter;
architecture shifter_behavioral of shifter is
begin
	with H_select_s select H_s <= 
		B_s			when "00",
		'0' & B_s(15 downto 1)	when "01",
		B_s(14 downto 0) & '0'	when others;
end shifter_behavioral;	
