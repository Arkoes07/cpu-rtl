library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity arithmetic_logic_unit is
	port(
		A_alu,B_alu: in std_logic_vector(15 downto 0);
		G_select_alu: in std_logic_vector(3 downto 0);
		G_alu: out std_logic_vector(15 downto 0)
	);
end arithmetic_logic_unit;

architecture alu_behavioral of arithmetic_logic_unit is
begin
	with G_select_alu select G_alu <=
		A_alu	when "0000",
		A_alu + '1' 	when "0001",
		A_alu + B_alu	when "0010",
		A_alu + B_alu+ '1' 	when "0011",
		A_alu + not B_alu 	when "0100",
		A_alu + not B_alu + '1' when "0101",
		A_alu - '1'	when "0110",
		A_alu	 	when "0111",
		A_alu and B_alu when "1000",
		A_alu or B_alu	when "1001",
		A_alu xor B_alu when "1010",
		not A_alu  	when others;
end alu_behavioral;
