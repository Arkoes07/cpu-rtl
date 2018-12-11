library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity TB_loop_hitungderet is
end TB_loop_hitungderet;
architecture test of TB_loop_hitungderet is
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
	memI(0)<="1001100000000001";	-- R0 = 1
	memI(1)<="1001100001000111";	-- R1 = 7
	memI(2)<="1001100010000000";	-- R2 = 0
	memI(3)<="0000001000000000";	-- LOOP: R0++
	memI(4)<="1001100011000000";	-- R3 = 0
	memI(5)<="0000010010010000";	-- R2 += R0
	memI(6)<="0000110001001000";	-- R1--
	memI(7)<="0000101011011001";	-- R3 -= R1
	memI(8)<="1100001111011011";	-- PC-5 IF R3 <0
	memI(9)<="1001100011000111";	-- R3 = 7
	memI(10)<="0100000000011010";	-- M[R3] = R2
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
