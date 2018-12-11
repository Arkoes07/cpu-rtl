library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity datapath is
	port(
		clk_d :in std_logic;
		constant_in_d: in std_logic_vector(15 downto 0);
		data_in_d: in std_logic_vector(15 downto 0);
		RW_d,MB_d,MD_d: in std_logic;
		DA_d,AA_d,BA_d: in std_logic_vector(2 downto 0);
		FS_d: in std_logic_vector(3 downto 0);
		N_d,Z_d: out std_logic;
		address_out_d,data_out_d: out std_logic_vector(15 downto 0);
		jump_address_d: out std_logic_vector(15 downto 0)
	);
end datapath;
architecture d_structural of datapath is
	signal F_hasilfu,B_hasilrf,bus_A_d,bus_B_d,bus_D_d : std_logic_vector(15 downto 0);
	--deklarasi component
	component register_file is
	port(
		clk_rf : in std_logic;
		RW_rf : in std_logic;
		DA_rf,AA_rf,BA_rf : in std_logic_vector(2 downto 0);
		D_rf : in std_logic_vector(15 downto 0);
		A_rf,B_rf : out std_logic_vector(15 downto 0)
	);
	end component register_file;
	component function_unit is
	port(
		A_fu,B_fu: in std_logic_vector(15 downto 0);
		FS_fu: in std_logic_vector(3 downto 0);
		F_fu: out std_logic_vector(15 downto 0);
		N_fu,Z_fu: out std_logic
	);
	end component function_unit;
begin
	RF : register_file
	port map (	clk_rf => clk_d,
			RW_rf => RW_d,
			DA_rf => DA_d,
			AA_rf => AA_d,
			BA_rf => BA_d,
			D_rf => bus_D_d,
			A_rf => bus_A_d,
			B_rf => B_hasilrf);

	address_out_d <= bus_A_d;
	jump_address_d <= bus_A_d;
	bus_B_d <= constant_in_d when MB_d = '1' else B_hasilrf;
	data_out_d <= bus_B_d;

	FU : function_unit 
	port map (	A_fu => bus_A_d,
			B_fu => bus_B_d,
			FS_fu => FS_d,
			F_fu => F_hasilfu,
			N_fu => N_d,
			Z_fu => Z_d);
	
	bus_D_d <= data_in_d when MD_d = '1' else F_hasilfu;

end d_structural;