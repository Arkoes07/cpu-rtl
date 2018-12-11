library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity program_counter is
	port(
		clk_pc : in std_logic;
		control_pc: in std_logic_vector(2 downto 0);
		branch_address_pc,jump_address_pc: in std_logic_vector(15 downto 0);
		instruction_address_pc: out std_logic_vector(15 downto 0)
 	);
end program_counter;
architecture pc_dataflow of program_counter is
	signal PC_register : std_logic_vector(15 downto 0):=X"0000";
begin
	process
	begin
		wait until clk_pc='1' and clk_pc'event;
		case control_pc is
			when "100" => PC_register <= PC_register + jump_address_pc;
			when "010" => PC_register <= PC_register + branch_address_pc;
			when others => PC_register <= PC_register + '1';
		end case;
	end process;
	instruction_address_pc <= PC_register;end pc_dataflow;
