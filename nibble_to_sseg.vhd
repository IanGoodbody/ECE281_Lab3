library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nibble_to_sseg is
	port ( nibble : in std_logic_vector(3 downto 0);
	       sseg   : out std_logic_vector(7 downto 0));
end nibble_to_sseg;

architecture behavioral of nibble_to_sseg is
	-- d.p., a, b, c, d, e, f, g
	constant SSEG_0 : std_logic_vector(7 downto 0) := not x"7E";
	constant SSEG_1 : std_logic_vector(7 downto 0) := not x"30";
	constant SSEG_2 : std_logic_vector(7 downto 0) := not x"6D";
	constant SSEG_3 : std_logic_vector(7 downto 0) := not x"79";
	constant SSEG_4 : std_logic_vector(7 downto 0) := not x"33";
	constant SSEG_5 : std_logic_vector(7 downto 0) := not x"5B";
	constant SSEG_6 : std_logic_vector(7 downto 0) := not x"5F";
	constant SSEG_7 : std_logic_vector(7 downto 0) := not x"70";
	constant SSEG_8 : std_logic_vector(7 downto 0) := not x"7F";
	constant SSEG_9 : std_logic_vector(7 downto 0) := not x"7B";
	constant SSEG_A : std_logic_vector(7 downto 0) := not x"77";
	constant SSEG_B : std_logic_vector(7 downto 0) := not x"1F";
	constant SSEG_C : std_logic_vector(7 downto 0) := not x"4E";
	constant SSEG_D : std_logic_vector(7 downto 0) := not x"3D";
	constant SSEG_E : std_logic_vector(7 downto 0) := not x"4F";
	constant SSEG_F : std_logic_vector(7 downto 0) := not x"47";
begin

	with nibble select
		sseg <= SSEG_0 when x"0",
		        SSEG_1 when x"1",
				SSEG_2 when x"2",
				SSEG_3 when x"3",
				SSEG_4 when x"4",
				SSEG_5 when x"5",
				SSEG_6 when x"6",
				SSEG_7 when x"7",
				SSEG_8 when x"8",
				SSEG_9 when x"9",
				SSEG_A when x"A",
				SSEG_B when x"B",
				SSEG_C when x"C",
				SSEG_D when x"D",
				SSEG_E when x"E",
				SSEG_F when others;
end behavioral;
