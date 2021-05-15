library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity alu is
	port (
			a			: in std_logic_vector( 7 downto 0);
			b			: in std_logic_vector(7 downto 0);
			alu_sel 	: in std_logic_vector(2 downto 0);
			--outs
			nzvc 		: out std_logic_vector(3 downto 0);
			alu_result 	: out std_logic_vector(7 downto 0)
	 );
end entity;

architecture arch of alu is

signal sum_unsigned : std_logic_vector(8 downto 0);--carry icin
signal alu_signal 	: std_logic_vector(7 downto 0);
signal toplama_overflow : std_logic;
signal cikarma_overflow : std_logic;

begin

process(alu_sel,a,b)
begin
	sum_unsigned <= (others => '0');
	
	case alu_sel is
		when "000" => 
			alu_signal <= a + b;
			sum_unsigned <= ('0' & a) + ('0' & b);
		when "001" => 
			alu_signal <= a - b;
			sum_unsigned <= ('0' & a) - ('0' & b);
		when "010" => 
			alu_signal <= a and b;
		when "011" => 
			alu_signal <= a or b;
		when "100" => 
			alu_signal <= a + x"01";
		when "101" => 
			alu_signal <= a - x"01";
		when others => 
			alu_signal <= (others => '0');
			sum_unsigned <= (others => '0');
	end case;
	
end process;

alu_result <= alu_signal;

--nzvc

nzvc(3) <= alu_signal(7);
nzvc(2) <= '0' when alu_signal = x"00" else '0';

toplama_overflow <= (not(a(7)) and not(b(7)) and alu_signal(7)) or (a(7)and b(7) and not(alu_signal(7)));
cikarma_overflow <= (not(a(7)) and (b(7)) and alu_signal(7)) or (a(7)and not(b(7)) and not(alu_signal(7)));

nzvc(1) <= 	toplama_overflow when (alu_sel = "000") else
			cikarma_overflow when (alu_sel = "001") else '0';
			
nzvc(0) <=	sum_unsigned(8) when (alu_sel = "000") else
			sum_unsigned(8) when (alu_sel = "001") else '0';
			
end architecture;