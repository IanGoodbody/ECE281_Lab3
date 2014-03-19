--This module updates the seven segement display codes
--Author: Captain Silva
--Editor: Ian Goodbod
--Company: USAFA
--This file is the origional "bad" code, the updated code is in file nexys2_sseg.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nexys2_sseg_raw is
	--No value for the generic object, must be given in the complent declartation
	--Would not hurt to define it here though
	generic ( CLOCK_IN_HZ : integer );
	port ( clk   : in std_logic; -- 50 MHz clock
	       reset : in std_logic;
		   sseg0 : in std_logic_vector(7 downto 0);
	      sseg1 : in std_logic_vector(7 downto 0);
		   sseg2 : in std_logic_vector(7 downto 0);
		   sseg3 : in std_logic_vector(7 downto 0);
		   sel   : out std_logic_vector(3 downto 0); -- Select sseg channel (active low) --
		   sseg  : out std_logic_vector(7 downto 0)); -- Output data
end nexys2_sseg_raw;

architecture behavioral of nexys2_sseg_raw is
	--With 50MHz clock, there will be a 50,000 tick clock and 1 ms
	constant TICKS_IN_MS : integer := CLOCK_IN_HZ / 1E3;
	
	type state_type is (s0, s1, s2, s3);
	--Must declare signals -See line 45
	signal state_reg, state_next : state_type;
	signal count_reg, count_next : unsigned(20 downto 0) := (others => 'U');
	signal sseg_reg, sseg_next : std_logic_vector(7 downto 0) := (others => 'U');
	signal sel_reg, sel_next : std_logic_vector(3 downto 0) := (others => 'U');
begin
	--Sets the output conditions to unsigned values
	--Will remain that way until the system is reset
	sseg <= sseg_reg;
	sel <= sel_reg;

	process (clk) is
	begin
		if rising_edge(clk) then
			if reset = '1' then --Reset everything
				--Note reset is tied to ground, values must be declared
				count_reg <= (others => '0');
				state_reg <= s0;
				sseg_reg <= (others => '0');
				sel_reg <= (others => '0'); --Problems with active low, should be set to ones to select nothing
			else --Set the register values to their next states on every clock cycle
				count_reg <= count_next;
				state_reg <= state_next;
				sseg_reg <= sseg_next;
				sel_reg <= sel_next;
			end if;
		end if;
	end process;

	--Reset the counter if it has been maxed out
	--Otherwise count up one on every lock cycle (with a change in count_reg)
	count_next <= (others => '0') when count_reg = TICKS_IN_MS else
	              count_reg + 1;
	
	--Should set all the next values
	process (state_reg, count_reg) is
	begin
		--state_next is set twice in this proces
		state_next <= state_reg;
		
		if count_reg = TICKS_IN_MS then
			--Must account for others
			--Move up a floor every 50,000 clock cycles, then go from floor 4 to 1
			case (state_reg) is
				when s0 =>
					state_next <= s1;
				when s1 =>
					state_next <= s2;
				when s2 =>
					state_next <= s3;
				when s3 =>
					state_next <= s0;
			end case;
		end if;
	end process;
	
	process (state_next, sseg_reg, sel_reg, sseg0, sseg1, sseg2, sseg3) is
	begin
		--These signals are set twice, and otherwise are unnecessary
		--It would maintain a state but the process takes care of that for us
		--If these are removed so could the "sseg_reg" and "sel_reg" on the sensitivity list
		sseg_next <= sseg_reg;
		sel_next <= sel_reg;
		
		--Must account for others
		case (state_next) is
				when s0 =>
					sseg_next <= sseg0;
					sel_next <= "1110"; --And that is what active low means
				when s1 =>
					sseg_next <= sseg1;
					sel_next <= "1101";
				when s2 =>
					sseg_next <= sseg2;
					sel_next <= "1011";
				when s3 =>
					sseg_next <= sseg3;
					sel_next <= "0111";
			end case;
	end process;
end behavioral;
