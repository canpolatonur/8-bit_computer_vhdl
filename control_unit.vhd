library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity control_unit is
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

end entity;

architecture arch of control_unit is

type state_type is (
					s_fetch_0, s_fetch_1, s_fetch_2, s_decode_3,
					s_lda_imm_4, s_lda_imm_5, s_lda_imm_6,
					s_lda_dir_4, s_lda_dir_5, s_lda_dir_6, s_lda_dir_7, s_lda_dir_8,
					s_ldb_imm_4, s_ldb_imm_5, s_ldb_imm_6,
					s_ldb_dir_4, s_ldb_dir_5, s_ldb_dir_6, s_ldb_dir_7, s_ldb_dir_8,
					s_sta_dir_4, s_sta_dir_5, s_sta_dir_6, s_sta_dir_7,
					s_add_ab_4,
					s_bra_4, s_bra_5, s_bra_6,
					s_beq_4, s_beq_5, s_beq_6, s_beq_7,
					
					);		
signal current_state, next_state : state_type;

------Commands
constant YUKLE_A_SBT : std_logic_vector(7 downto 0) := x"86";
constant YUKLE_A	 : std_logic_vector(7 downto 0) := x"87";
constant YUKLE_B_SBT : std_logic_vector(7 downto 0) := x"88";
constant YUKLE_B	 : std_logic_vector(7 downto 0) := x"89";
constant KAYDET_A	 : std_logic_vector(7 downto 0) := x"96";
constant KAYDET_B	 : std_logic_vector(7 downto 0) := x"97";

constant topla_ab	 : std_logic_vector(7 downto 0) := x"42";
constant cikar_ab	 : std_logic_vector(7 downto 0) := x"43";
constant and_ab		 : std_logic_vector(7 downto 0) := x"44";
constant or_ab		 : std_logic_vector(7 downto 0) := x"45";
constant arttir_a	 : std_logic_vector(7 downto 0) := x"46";
constant arttir_b	 : std_logic_vector(7 downto 0) := x"47";
constant dusur_a	 : std_logic_vector(7 downto 0) := x"48";
constant dusur_b	 : std_logic_vector(7 downto 0) := x"49";

constant atla	 		 	 : std_logic_vector(7 downto 0) := x"20";
constant atla_negatifse	 	 : std_logic_vector(7 downto 0) := x"21";
constant atla_pozitifse	 	 : std_logic_vector(7 downto 0) := x"22";
constant atla_esitse_sifir	 : std_logic_vector(7 downto 0) := x"23";
constant atla_degilse_sifir	 : std_logic_vector(7 downto 0) := x"24";
constant atla_overflow_varsa : std_logic_vector(7 downto 0) := x"25";
constant atla_overflow_yoksa : std_logic_vector(7 downto 0) := x"26";
constant atla_elde_varsa	 : std_logic_vector(7 downto 0) := x"27";
constant atla_elde_yoksa	 : std_logic_vector(7 downto 0) := x"28";

begin

-- current state
process(clk,rst)

	begin
		if(rst='1') then
			current_state <= s_fetch0;
		elsif(rising_edge(clk)) then
			current_state <= next_state;
		end if;
end process;

-- next state

process(current_state, ir, ccr_result)
	begin
		case current_state is
			when s_fetch_0 =>
				next_state <= s_fetch_1;
			when s_fetch_1 =>
				next_state <= s_fetch_2;
			when s_fetch_2 =>
				next_state <= s_decode_3;
			when s_decode_3 =>
				if(ir = YUKLE_A_SBT) then
					next_state <= s_lda_imm_4;
				elsif(ir = YUKLE_A) then
					next_state <= s_lda_dir_4;
				elsif(ir = YUKLE_b_SBT) then
					next_state <= s_ldb_imm_4;
				elsif(ir = YUKLE_b) then
					next_state <= s_ldb_dir_4;
				elsif(ir = KAYDET_A_A) then
					next_state <= s_sta_dir_4;
				elsif(ir = topla_ab) then
					next_state <= s_add_ab_4;
				elsif(ir = atla) then
					next_state <= s_bra_4;
				elsif(ir = atla_esitse_sifir) then
					if(ccr_result(2) = '1') --nzvc zero 2nd bit
						next_state <= s_beq_4;
					else
						next_state <= s_beq_7;
					end if;
				else
					next_state <= s_fetch_0;
				end if;
			when s_lda_imm_4 =>
				next_state <= s_lda_imm_5;
			when s_lda_imm_5 =>
				next_state <= s_lda_imm_6;
			when s_lda_imm_6 =>
				next_state <= s_fetch_0;
				------------------------------
			when s_lda_dir_4 =>
				next_state <= s_lda_dir_5;
			when s_lda_dir_5 =>
				next_state <= s_lda_dir_6;
			when s_lda_dir_6 =>
				next_state <= s_lda_dir_7;
			when s_lda_dir_7 =>
				next_state <= s_lda_dir_8;
			when s_lda_dir_8 =>
				next_state <= s_fetch_0;
				---------------------------
			when s_ldb_imm_4 =>
				next_state <= s_ldb_imm_5;
			when s_ldb_imm_5 =>
				next_state <= s_ldb_imm_6;
			when s_ldb_imm_6 =>
				next_state <= s_fetch_0;
				------------------------------
			when s_ldb_dir_4 =>
				next_state <= s_ldb_dir_5;
			when s_ldb_dir_5 =>
				next_state <= s_ldb_dir_6;
			when s_ldb_dir_6 =>
				next_state <= s_ldb_dir_7;
			when s_ldb_dir_7 =>
				next_state <= s_ldb_dir_8;
			when s_ldb_dir_8 =>
				next_state <= s_fetch_0;
				---------------------------
			when s_sta_dir_4 =>
				next_state <= s_sta_dir_5;
			when s_sta_dir_5 =>
				next_state <= s_sta_dir_6;
			when s_sta_dir_6 =>
				next_state <= s_sta_dir_7;
			when s_sta_dir_7 =>
				next_state <= s_fetch_0;
				------------------------------
			when s_add_ab_4 =>
				next_state <= s_fetch_0;
				------------------------------
			when s_bra_4 =>
				next_state <= s_bra_5;
			when s_bra_5 =>
				next_state <= s_bra_6;
			when s_bra_6 =>
				next_state <= s_fetch_0;
				------------------------------
			when s_beq_4 =>
				next_state <= s_beq_5;
			when s_beq_5 =>
				next_state <= s_beq_6;
			when s_beq_6 =>
				next_state <= s_fetch_0;
			when s_beq_7 =>
				next_state <= s_fetch_0;
			when others =>
				next_state <= s_fetch_0;
		end case;
end process;
---output logic
process(current_state)
	begin	
		
		mar_load <= '0';
		ir_load <= '0';
		pc_load<= '0';
		a_load <= '0';
		b_load <= '0';
		alu_sel <= (others =>'0');
		ccr_load <= '0';
		bus1_sel <= (others =>'0');
		bus2_sel <= (others =>'0');
		write_en <= '0';
		case current_state is
		
		when s_fetch_0 =>
				bus1_sel <= "00"; --pc
				bus2_sel <= "01";--- bus1
				mar_load <= '1';
			when s_fetch_1 =>
				pc_inc <= '1';
			when s_fetch_2 =>
				bus2_sel <= "10";
				ir_load <= '1';
			when s_decode_3 =>
				-----------------------------
			when s_lda_imm_4 =>
				bus1_sel <= "00"; --pc
				bus2_sel <= "01";--- bus1
				mar_load <= '1';
			when s_lda_imm_5 =>
				pc_inc <= '1';
			when s_lda_imm_6 =>
				bus2_sel <= "10";
				a_load <= '1';
				------------------------------
			when s_lda_dir_4 =>
				bus1_sel <= "00"; --pc
				bus2_sel <= "01";--- bus1
				mar_load <= '1';
			when s_lda_dir_5 =>
				pc_inc <= '1';
			when s_lda_dir_6 =>
				bus2_sel <= "10";
				mar_load <= '1';
			when s_lda_dir_7 =>
				--waiting
			when s_lda_dir_8 =>
				bus2_sel <= "10";
				a_load <= '1';
			
				------------------------------
			when s_ldb_imm_4 =>
				bus1_sel <= "00"; --pc
				bus2_sel <= "01";--- bus1
				mar_load <= '1';
			when s_ldb_imm_5 =>
				pc_inc <= '1';
			when s_ldb_imm_6 =>
				bus2_sel <= "10";
				b_load <= '1';
				------------------------------
			when s_lda_dir_4 =>
				bus1_sel <= "00"; --pc
				bus2_sel <= "01";--- bus1
				mar_load <= '1';
			when s_ldb_dir_5 =>
				pc_inc <= '1';
			when s_ldb_dir_6 =>
				bus2_sel <= "10";
				mar_load <= '1';
			when s_ldb_dir_7 =>
				--waiting
			when s_ldb_dir_8 =>
				bus2_sel <= "10";
				b_load <= '1';
			---------------------------------
			when s_sta_dir_4 =>
				bus1_sel <= "00"; --pc
				bus2_sel <= "01";--- bus1
				mar_load <= '1';
			when s_sta_dir_5 =>
				pc_inc <= '1';
			when s_sta_dir_6 =>
				bus2_sel <= "10";
				mar_load <= '1';
			when s_sta_dir_7 =>
				bus1_sel <= "01";
				write_en <= '1';
				------------------------------
			when s_add_ab_4 =>
				bus1_sel <= "01";
				bus2_sel <= "00";
				alu_sel <= "000"; -- toplama kodu
				a_load <= '1';
				ccr_load < '1';
				------------------------------
			when s_bra_4 =>
				bus1_sel <= "00"; --pc
				bus2_sel <= "01";--- bus1
				mar_load <= '1';
			when s_bra_5 =>
				--waiting
			when s_bra_6 =>
				bus1_sel <= "01";
				pc_load <= '1';
				------------------------------
			when s_beq_4 =>
				bus1_sel <= "00"; --pc
				bus2_sel <= "01";--- bus1
				mar_load <= '1';
			when s_beq_5 =>
				--waiting
			when s_beq_6 =>
				bus1_sel <= "01";
				pc_load <= '1';
			when s_beq_7 =>
				pc_inc <= '1';
			when others =>
				mar_load <= '0';
				ir_load <= '0';
				pc_load<= '0';
				a_load <= '0';
				b_load <= '0';
				alu_sel <= (others =>'0');
				ccr_load <= '0';
				bus1_sel <= (others =>'0');
				bus2_sel <= (others =>'0');
				write_en <= '0';
		end case;
end process;
end architecture;