library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity cpu is
	port(
		clk : in std_logic;
		rst : in std_logic;
		from_memory : in std_logic_vector(7 downto 0);
		---outs
		to_memory	: out std_logic_vector(7 downto 0);
		address		: out std_logic_vector(7 downto 0);
		write_en 	: out std_logic
		
		);
end entity;

architecture arch of cpu is

component control_unit is
	port (
			clk				: in std_logic;
			ir 				: in std_logic_vector(7 downto 0);
			rst 			: in std_logic;
			ccr_result 		: in std_logic_vector(3 downto 0);
			-- outs
			ir_load 		: out std_logic;
			mar_load 		: out std_logic;
			pc_load 		: out std_logic;
			pc_inc 			: out std_logic;
			a_load 			: out std_logic;
			b_load 			: out std_logic;
			alu_sel 		: out std_logic;
			ccr_load 		: out std_logic;
			bus1_sel 		: out std_logic_vector(1 downto 0); --sel
			bus2_sel		: out std_logic_vector(1 downto 0); --sel
			write_en		: out std_logic
		);

end component;

component data_path is
	port (
			clk				: in std_logic;
			rst				: in std_logic;
			ir_load 		: in std_logic;
			mar_load 		: in std_logic;
			pc_load 		: in std_logic;
			pc_inc 			: in std_logic;
			a_load 			: in std_logic;
			b_load 			: in std_logic;
			alu_sel 		: in std_logic;
			ccr_load 		: in std_logic;
			bus1_sel 		: in std_logic_vector(1 downto 0); --sel
			bus2_sel		: in std_logic_vector(1 downto 0); --sel
			from_memory		: in std_logic_vector(7 downto 0);
			--outputs
			ir 				: out std_logic_vector(7 downto 0);
			address 		: out std_logic_vector(7 downto 0); -- memory address
			ccr_result 		: out std_logic_vector(3 downto 0);
			to_memory 		: out std_logic_vector(7 downto 0) -- memory data
	 );
end component;	
--signals
signal ir_load 		:  std_logic;
signal ir 			:  std_logic_vector(7 downto 0);
signal mar_load 	:  std_logic;
signal pc_load 		:  std_logic;
signal pc_inc 		:  std_logic;
signal a_load 		:  std_logic;
signal b_load 		:  std_logic;
signal alu_sel 		:  std_logic;
signal ccr_load 	:  std_logic;
signal ccr_result 	:  std_logic_vector(3 downto 0);
signal bus1_sel 	:  std_logic_vector(1 downto 0); 
signal bus2_sel		:  std_logic_vector(1 downto 0); 

begin
--control unit
control_unit_module : control_unit port map (
											clk			=> clk,
											ir 			=> ir,
											rst 		=> rst,
											ccr_result 	=> ccr_result,
											-- outs     =>
											ir_load 	=> ir_load, 
											mar_load 	=> mar_load,
											pc_load 	=> pc_load,
											pc_inc 		=> pc_inc,	
											a_load 		=> a_load,
											b_load 		=> b_load, 	
											alu_sel 	=> alu_sel,
											ccr_load 	=> ccr_load,
											bus1_sel 	=> bus1_sel,
											bus2_sel	=> bus2_sel,
											write_en	=> write_en
											);
--data path

data_path_module : data_path port map 		(
											clk			=> clk,			
											rst			=> rst,			
											ir_load 	=> ir_load, 	
											mar_load 	=> mar_load, 	
											pc_load 	=> pc_load,
											pc_inc 		=> pc_inc, 		
											a_load 		=> a_load, 		
											b_load 		=> b_load,		
											alu_sel 	=> alu_sel, 	
											ccr_load 	=> ccr_load, 	
											bus1_sel 	=> bus1_sel,	
											bus2_sel	=> bus2_sel,	
											from_memory	=> from_memory,	
											--outputs   => --outputs
											ir 			=> ir, 			
											address 	=> address, 	
											ccr_result 	=> ccr_result, 	
											to_memory 	=> to_memory 	
											);
end architecture;