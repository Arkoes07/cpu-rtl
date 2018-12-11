library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity function_unit is
	port(
		A_fu,B_fu: in std_logic_vector(15 downto 0);
		FS_fu: in std_logic_vector(3 downto 0);
		F_fu: out std_logic_vector(15 downto 0);
		N_fu,Z_fu: out std_logic
	);
end function_unit;
architecture fu_structural of function_unit is
	signal G_hasilalu,H_hasilshifter: std_logic_vector(15 downto 0);
	signal MF_select_fu: std_logic;
	--deklarasikan component
	component arithmetic_logic_unit is	
	port(
		A_alu,B_alu: in std_logic_vector(15 downto 0);
		G_select_alu: in std_logic_vector(3 downto 0);
		G_alu: out std_logic_vector(15 downto 0)
	);
	end component arithmetic_logic_unit;
	component shifter is
	port(
		B_s : in std_logic_vector(15 downto 0);
		H_select_s : in std_logic_vector(1 downto 0);
		H_s : out std_logic_vector(15 downto 0)
	);
	end component shifter;
begin
	ALU : arithmetic_logic_unit
	port map ( 	A_alu => A_fu,
			B_alu => B_fu,
			G_select_alu => FS_fu,
			G_alu => G_hasilalu );

	SH : shifter
	port map ( 	B_s => B_fu,
			H_select_s => FS_fu(1 downto 0),
			H_s => H_hasilshifter );

	N_fu <= '1' when G_hasilalu(15) = '1' else '0';
	Z_fu <= '1' when G_hasilalu = X"0000";

	MF_select_fu <= FS_fu(3) and FS_fu(2);
	F_fu <= G_hasilalu when MF_select_fu = '0' else H_hasilshifter;
end fu_structural;

