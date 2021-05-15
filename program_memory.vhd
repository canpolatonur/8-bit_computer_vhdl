library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity program_memory is
	port(
		clk : in std_logic;
		address : in std_logic_vector(7 downto 0);
		data_out : out std_logic_vector(7 downto 0)
	);

end entity;

architecture arch of program_memory is

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

type rom_type is array(0 to 127) of std_logic_vector(7 downto 0);
constant rom: rom_type := ( --yazilim kodu burasi
							0 => YUKLE_A_SBT;
							1 => x"0F";
							2 => KAYDET_A;
							3 => x"80";
							4 => atla;
							5 => x"00";
							others => x"00";
							);
--sinyaller
signal enable std_logic;
begin
process(address)
	if(address >= x"00" and address <= x"7F") then
		enable <= '1';
	else
		enable <= '0';
	end if;
end process;

process(clk)
begin
		if(rising_edge(clk)) then
			if (enable = '1') then
				data_out <= ROM(to_integer(unsigned (address))); --roma erismek icin integere ceviriliyor
			end if;
		end if;
		
end process;

end architecture;