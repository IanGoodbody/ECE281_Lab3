-------------------------------------------------------------------------------
--
-- Title       : Clock_Divider
-- Design      : Soda_Machine
-- Author      : USAFA
-- Company     : DFEC
--
-------------------------------------------------------------------------------
--
-- File        : Clock_Divider.vhd
-- Generated   : Thu Jun 23 14:07:10 2011
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
-------------------------------------------------------------------------------
--
-- Description : 
-- ClockBus(0) is   50.0Mhz      20.0ns
-- ClockBus(1) is   25.0 Mhz     40.0ns
-- ClockBus(2) is   12.5Mhz      80.0ns
-- ClockBus(3) is    6.3Mhz     160.0ns
-- ClockBus(4) is    3.1Mhz     320.0ns
-- ClockBus(5) is    1.6Mhz     640.0ns   
-- ClockBus(6) is  781.3Khz       1.3us
-- ClockBus(7) is  390.6Khz       2.6us
-- ClockBus(8) is  195.3Khz       5.1us
-- ClockBus(9) is   97.7KHz      10.2us
-- ClockBus(10) is  48.8Khz      20.5us
-- ClockBus(11) is  24.4Khz      41.0us
-- ClockBus(12) is  12.2Khz      81.9us
-- ClockBus(13) is   6.1Khz     163.8us
-- ClockBus(14) is   3.1Khz     327.7us
-- ClockBus(15) is   1.5Khz     655.4us
-- ClockBus(16) is 762.9hz        1.3ms
-- ClockBus(17) is 381.5Hz        2.6ms 
-- ClockBus(18) is 190.7Hz        5.2ms    
-- ClockBus(19) is  95.4Hz       10.5ms
-- ClockBus(20) is  47.7Hz       21.0ms
-- ClockBus(21) is  23.8Hz       42.0ms
-- ClockBus(22) is  11.9Hz       83.9ms
-- ClockBus(23) is   6.0Hz      167.8ms
-- ClockBus(24) is   3.0Hz      335.5ms
-- ClockBus(25) is   1.5Hz      671.1ms
-- ClockBus(26) is    .745Hz      1.3s
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Clock_Divider is
	 port(
		 clk : in STD_LOGIC;
		 clockbus : out STD_LOGIC_VECTOR(26 downto 0)
	     );
end Clock_Divider;

--}} End of automatically maintained section

architecture Clock_Divider of Clock_Divider is

signal clockbus_sig: std_logic_vector(26 downto 0);

begin
--Problem with continuouts clock reset
	process (clk) 
		variable resetclk : std_logic := '1';
	begin								   
		if resetclk = '1' then	
			clockbus_sig <= (others => '0');
			resetclk := '0';
		elsif rising_edge(clk) then	
			clockbus_sig <= clockbus_sig + 1;
		end if;
		clockbus <= clockbus_sig;
	end process;

end Clock_Divider;
