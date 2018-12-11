library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity simple_cpu is
	port( 
		clk_cpu: in std_logic;
		instruction_in_cpu: in std_logic_vector(15 downto 0);
		data_in_cpu: in std_logic_vector(15 downto 0);
		address_data_out_cpu: out std_logic_vector(15 downto 0);
		data_out_cpu: out std_logic_vector(15 downto 0);
		address_instruction_out_cpu: out std_logic_vector(15 downto 0);
		MW_cpu: out std_logic
	);
end simple_cpu;
architecture scpu_structural of simple_cpu is
	signal jumpaddr,const: std_logic_vector(15 downto 0);
	signal DA_cpu,AA_cpu,BA_cpu: std_logic_vector(2 downto 0);
	signal	FS_cpu: std_logic_vector(3 downto 0);
	signal	MB_cpu,MD_cpu,RW_cpu,N_cpu,Z_cpu: std_logic;
	component datapath is
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
	end component datapath;
	component control is
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
	end component control;
begin
	DATA : datapath 
	port map (	clk_d => clk_cpu,
			constant_in_d => const,
			data_in_d => data_in_cpu,
			RW_d => RW_cpu,
			MB_d => MB_cpu,
			MD_d => MD_cpu,
			DA_d => DA_cpu,
			AA_d => AA_cpu,
			BA_d => BA_cpu,
			FS_d => FS_cpu,
			N_d => N_cpu,
			Z_d => Z_cpu,
			address_out_d => address_data_out_cpu,
			data_out_d => data_out_cpu,
			jump_address_d => jumpaddr);
	CONT : control 
	port map (	clk_c => clk_cpu,
			N_c => N_cpu,
			Z_c => Z_cpu,
			instruction_in_c => instruction_in_cpu,
			jump_address_c => jumpaddr,
			instruction_address_c => address_instruction_out_cpu,
			constant_in_c => const,
			DA_c => DA_cpu,
			AA_c => AA_cpu,
			BA_c => BA_cpu,
			FS_c => FS_cpu,
			MB_c => MB_cpu,
			MD_c => MD_cpu,
			RW_c => RW_cpu,
			MW_c => MW_cpu);
end scpu_structural; 
