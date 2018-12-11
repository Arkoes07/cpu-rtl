library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity register_file is
	port(
		clk_rf : in std_logic;
		RW_rf : in std_logic;
		DA_rf,AA_rf,BA_rf : in std_logic_vector(2 downto 0);
		D_rf : in std_logic_vector(15 downto 0);
		A_rf,B_rf : out std_logic_vector(15 downto 0)
	);
end register_file;

architecture register_file_dataflow of register_file is
	signal R0,R1,R2,R3,R4,R5,R6,R7: std_logic_vector(15 downto 0);
begin
	process
	begin
		wait until clk_rf='1' and clk_rf'event;
		if RW_rf = '1' then
			case DA_rf is
				when "000" => R0 <= D_rf;
				when "001" => R1 <= D_rf;
				when "010" => R2 <= D_rf;
				when "011" => R3 <= D_rf;
				when "100" => R4 <= D_rf;
				when "101" => R5 <= D_rf;
				when "110" => R6 <= D_rf;
				when others => R7 <= D_rf;
			end case;
		end if;
	end process;
	with AA_rf select A_rf <=
		R0 when "000",
		R1 when "001",
		R2 when "010",
		R3 when "011",
		R4 when "100",
		R5 when "101",
		R6 when "110",
		R7 when others;
	with BA_rf select B_rf <=
		R0 when "000",
		R1 when "001",
		R2 when "010",
		R3 when "011",
		R4 when "100",
		R5 when "101",
		R6 when "110",
		R7 when others;
end register_file_dataflow;
		
