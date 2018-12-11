library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity control is
	port(
		clk_c: in std_logic;
		N_c,Z_c: in std_logic;
		instruction_in_c: in std_logic_vector(15 downto 0);
		jump_address_c: in std_logic_vector(15 downto 0);
		instruction_address_c: out std_logic_vector(15 downto 0);
		constant_in_c: out std_logic_vector(15 downto 0);
		DA_c,AA_c,BA_c: out std_logic_vector(2 downto 0);
		FS_c: out std_logic_vector(3 downto 0);
		MB_c,MD_c,RW_c,MW_c: out std_logic
	);
end control;
architecture c_structural of control is
	signal branch_address_c : std_logic_vector(15 downto 0);
	signal control_bckepc : std_logic_vector(2 downto 0);
	signal PL_c,JB_c,BC_c : std_logic;
	component instruction_decoder is
	port(
		ins_in_id: in std_logic_vector(15 downto 0);
		DA_id,AA_id,BA_id: out std_logic_vector(2 downto 0);
		MB_id,MD_id,RW_id,MW_id,PL_id,JB_id,BC_id: out std_logic;
		FS_id: out std_logic_vector(3 downto 0)
	);
	end component instruction_decoder;
	component branch_control is
	port(
		N_bc,Z_bc,PL_bc,JB_bc,BC_bc: in std_logic;
		control_bc: out std_logic_vector(2 downto 0)
	);
	end component branch_control;
	component program_counter is
	port(
		clk_pc : in std_logic;
		control_pc: in std_logic_vector(2 downto 0);
		branch_address_pc,jump_address_pc: in std_logic_vector(15 downto 0);
		instruction_address_pc: out std_logic_vector(15 downto 0)
 	);
	end component program_counter;
begin
	ID : instruction_decoder
	port map (	ins_in_id => instruction_in_c,
			DA_id => DA_c,
			AA_id => AA_c,
			BA_id => BA_c,
			MB_id => MB_c,
			MD_id => MD_c,
			RW_id => RW_c,
			MW_id => MW_c,
			PL_id => PL_c,
			JB_id => JB_c,
			BC_id => BC_c,
			FS_id => FS_c);
	BC : branch_control
	port map (	N_bc => N_c,
			Z_bc => Z_c,
			PL_bc => PL_c,
			JB_bc => JB_c,
			BC_bc => BC_c,
			control_bc => control_bckepc);
	branch_address_c <= "1111111111" & instruction_in_c(8 downto 6) & instruction_in_c(2 downto 0) when instruction_in_c(8) = '1'
		else "0000000000" & instruction_in_c(8 downto 6) & instruction_in_c(2 downto 0);
	PC : program_counter
	port map (	clk_pc => clk_c,
			control_pc => control_bckepc,
			branch_address_pc => branch_address_c,
			jump_address_pc => jump_address_c,
			instruction_address_pc => instruction_address_c);
	constant_in_c <= "0000000000000" & instruction_in_c(2 downto 0);	 
end c_structural;
