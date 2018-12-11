library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity branch_control is
	port(
		N_bc,Z_bc,PL_bc,JB_bc,BC_bc: in std_logic;
		control_bc: out std_logic_vector(2 downto 0)
	);
end branch_control;
architecture bc_dataflow of branch_control is
begin 
	control_bc(0) <= not PL_bc or (not JB_bc and (not BC_bc and (not Z_bc))) or (not JB_bc and (BC_bc and (not N_bc))); --increment
	control_bc(1) <= (PL_bc and (not JB_bc) and (not BC_bc) and Z_bc) or (PL_bc and (not JB_bc) and BC_bc and N_bc); --branch
	control_bc(2) <= PL_bc and JB_bc; --jump
end bc_dataflow;