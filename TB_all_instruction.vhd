library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity TB_all_instruction is
end TB_all_instruction;
architecture test of TB_all_instruction is
	--penghubung antara memory dan cpu
	signal clock: std_logic:='1';
	signal data_address: std_logic_vector(15 downto 0);
	signal data_to_mem: std_logic_vector(15 downto 0);
	signal data_from_mem: std_logic_vector(15 downto 0);
	signal mem_write: std_logic;
	signal ins_address: std_logic_vector(15 downto 0);
	signal ins_from_mem: std_logic_vector(15 downto 0);
	--deklarasi memory
	type mem is array(32767 downto 0) of std_logic_vector(15 downto 0);
	signal memD,memI : mem;
	signal addrD,addrI : integer range 0 to 32767;
	signal ins_addr,data_addr: std_logic_vector(14 downto 0);
	--deklarasi cpu
	component simple_cpu is
		port( 
		clk_cpu: in std_logic;
		instruction_in_cpu: in std_logic_vector(15 downto 0);
		data_in_cpu: in std_logic_vector(15 downto 0);
		address_data_out_cpu: out std_logic_vector(15 downto 0);
		data_out_cpu: out std_logic_vector(15 downto 0);
		address_instruction_out_cpu: out std_logic_vector(15 downto 0);
		MW_cpu: out std_logic
	);
	end component simple_cpu;
begin
	process
	begin
		wait for 50 ns;
		clock <= not clock;
	end process;
	--component cpu
	CPU : simple_cpu
	port map (	clk_cpu => clock,
			instruction_in_cpu => ins_from_mem,
			data_in_cpu => data_from_mem,
			address_data_out_cpu => data_address,
			data_out_cpu => data_to_mem,
			address_instruction_out_cpu => ins_address,
			MW_cpu => mem_write);
	--instruction memory
	ins_addr <= ins_address(14 downto 0);
	addrI <= conv_integer(ins_addr);
	process
	begin
		wait until clock='0' and clock'event;
		ins_from_mem <= memI(addrI);
	end process;
	memI(0) 	<= "1001100000000111";  -- RO = 7 	  (LDI)
	memI(1) 	<= "0000000001000000";	-- R1 = R0 	  (MOV A)
	memI(2) 	<= "0000001000000000";	-- R0++ 	  (INC)
	memI(3) 	<= "0000010010000001";	-- R2 = R0+1 	  (ADD)
	memI(4) 	<= "0001011011010000";	-- R3 = NOT R2 	  (NOT)
	memI(5) 	<= "0001001100010011";	-- R4 = R2 OR R3  (OR)
	memI(6) 	<= "0001000101010011";	-- R5 = R2 AND R3 (AND)
	memI(7) 	<= "0001010110011100";	-- R6 = R3 XOR R4 (XOR)
	memI(8) 	<= "0000101111001001";	-- R7 = R1 - R1   (SUB)
	memI(9) 	<= "1100000000111101";	-- PC+5 IF R7 = 0 (BZ)
	memI(10)	<= "0001110111000111";	-- SHL R7 	  (SHL)
	memI(11) 	<= "1001100001000011";	-- R1 = 3 	  (LDI)
	memI(12) 	<= "0001101111000111";	-- SHR R7 	  (SHR)
	memI(13) 	<= "1110000000001000";	-- PC+3 	  (JUMP)
	memI(14) 	<= "0000110111111000"; 	-- R7-- 	  (DEC)
	memI(15) 	<= "1100001111111011";	-- PC-5 IF R7 < 0 (BN)
	memI(16) 	<= "0001100001000111";	-- R1 = R7 	  (MOV B)
	memI(17) 	<= "1000010001001010";	-- R1 += 2	  (ADI)
	memI(18) 	<= "0100000000010000";	-- M[R2] = R0 	  (STORE)
	memI(19) 	<= "0010000001010000";	-- R1 = M[R2] 	  (LOAD)
	--data memory
	data_addr <= data_address(14 downto 0);
	addrD <= conv_integer(data_addr);
	process
	begin
		wait until clock='0' and clock'event;
		wait for 25 ns;
		if mem_write = '1' then
			memD(addrD) <= data_to_mem;
		else
			data_from_mem <= memD(addrD);
		end if;
	end process;
end test;	