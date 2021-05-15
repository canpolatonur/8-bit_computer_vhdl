library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity data_path is
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
end entity;

architecture arch of data_path is

component alu is
	port (
			a			: in std_logic_vector( 7 downto 0);
			b			: in std_logic_vector(7 downto 0);
			alu_sel 	: in std_logic_vector(2 downto 0);
			--outs
			nzvc 		: out std_logic_vector(3 downto 0);
			alu_result 	: out std_logic_vector(7 downto 0)
	 );
end component;

--signals
signal bus1			 : std_logic_vector(7 downto 0);
signal bus2 		 : std_logic_vector(7 downto 0);
signal alu_result	 : std_logic_vector(7 downto 0);
signal ir			 : std_logic_vector(7 downto 0);-- portla cakisiyor
signal mar			 : std_logic_vector(7 downto 0);
signal pc			 : std_logic_vector(7 downto 0);
signal a_reg		 : std_logic_vector(7 downto 0);
signal b_reg		 : std_logic_vector(7 downto 0);
signal ccr_in		 : std_logic_vector(3 downto 0);
signal ccr			 : std_logic_vector(3 downto 0);

begin 

--bus1 mux

bus1 <= pc	  when bus1_sel = "00" else --hoca <= yapti
		a_reg when bus1_sel = "01" else
		b_reg when bus1_sel = "10" else (others => '0');
--bus2 mux

bus2 <= alu_result  when bus2_sel = "00" else
		bus1 	    when bus2_sel = "01" else
		from_memory when bus2_sel = "10" else (others => '0');

--ir register
process(clk,rst)
begin
	if (rst = '1') then
		ir <= (others => '0');
	elsif (rising_edge(clk)) then
		if(ir_load = '1') then
			ir <= bus2;
		end if;
	end if;
end process;

--mar register
process(clk,rst)
begin
	if (rst = '1') then
		mar <= (others => '0');
	elsif (rising_edge(clk)) then
		if(mar_load = '1') then
			mar <= bus2;
		end if;
	end if;
end process;
address <= mar;

--pc register
process(clk,rst)
begin
	if (rst = '1') then
		pc <= (others => '0');
	elsif (rising_edge(clk)) then
		if(pc_load = '1') then
			pc <= bus2;
		elsif(pc_inc ='1') then
			pc = pc + "00000001";
		end if;
	end if;
end process;

--a register
process(clk,rst)
begin
	if (rst = '1') then
		a_reg <= (others => '0');
	elsif (rising_edge(clk)) then
		if(a_load = '1') then
			a_reg <= bus2;
		end if;
	end if;
end process;

--b register
process(clk,rst)
begin
	if (rst = '1') then
		b_reg <= (others => '0');
	elsif (rising_edge(clk)) then
		if(b_load = '1') then
			b_reg <= bus2;
		end if;
	end if;
end process;

-- alu

alu_u : alu port map 
				(
				a			=> b_reg,
				b			=> bus1,
				alu_sel 	=> alu_sel,
				--outs      
				nzvc 		=> ccr_in,
                alu_result 	=> alu_result
				);

--ccr register
process(clk,rst)
begin
	if (rst = '1') then
		ccr <= (others => '0');
	elsif (rising_edge(clk)) then
		if(ccr_load = '1') then
			ccr <= ccr_in;
		end if;
	end if;
end process;
ccr_result <= ccr;

-- bellege gidecek sinyal

to_memory <= bus1;

end architecture;