library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity instruction_decoder is
	port(
		ins_in_id: in std_logic_vector(15 downto 0);
		DA_id,AA_id,BA_id: out std_logic_vector(2 downto 0);
		MB_id,MD_id,RW_id,MW_id,PL_id,JB_id,BC_id: out std_logic;
		FS_id: out std_logic_vector(3 downto 0)
	);
end instruction_decoder;
architecture id_dataflow of instruction_decoder is
begin
	DA_id <= ins_in_id(8 downto 6);
	AA_id <= ins_in_id(5 downto 3);
	BA_id <= ins_in_id(2 downto 0);
	MB_id <= ins_in_id(15);
	FS_id <= ins_in_id(12 downto 10) & (ins_in_id(9) and ( not (ins_in_id(15) and ins_in_id(14))));
	MD_id <= ins_in_id(13);
	RW_id <= not ins_in_id(14);
	MW_id <= (not ins_in_id(15)) and ins_in_id(14);
	PL_id <= ins_in_id(15) and ins_in_id(14);
	JB_id <= ins_in_id(13);
	BC_id <= ins_in_id(9);
end id_dataflow;
