----------------------------------------------------------------------------------
-- Company: USAFA/DFECE
-- Engineer: Ian Goodbody
-- 
-- Create Date:    23:24:15 03/18/2014 
-- Module Name:    LightController - Behavioral 
-- Project Name:   Lab 3
-- Description: Controls the flashing LED sequence for the LighedElevatorController system
-- Takes in two inputs to determine if it is stopped or if it is moving up or down. Yes I
-- problably just made this harder than it needed to be but I feel very good about myself
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LightController is
    Port ( clk : in STD_LOGIC;
			  up_down : in  STD_LOGIC;
           stop : in  STD_LOGIC;
           LED_Out : out  STD_LOGIC_VECTOR (7 downto 0));
end LightController;

architecture Behavioral of LightController is

type stack_type is (stack0, stack1, stack2, stack3, stack4, stack5, stack6, stack7, stack8);

signal led_reg: stack_type := stack1;

begin

LightCont: process(clk)
begin
	if clk'event and clk = '1' then 
		if stop = '1' then
		--Keeps LEDs on
			led_reg <= stack8;
		else
			if up_down = '1' then
			--Sequences the LED's up from right to left
				case led_reg is
					when stack1 => led_reg <= stack2;
					when stack2 => led_reg <= stack3;
					when stack3 => led_reg <= stack4;
					when stack4 => led_reg <= stack5;
					when stack5 => led_reg <= stack6;
					when stack6 => led_reg <= stack7;
					when stack7 => led_reg <= stack8;
					when stack8 => led_reg <= stack1;
					when others => led_reg <= stack1;
				end case;
			else
			--Sequences the LED's down from left to right
				case led_reg is
					when stack1 => led_reg <= stack8;
					when stack2 => led_reg <= stack1;
					when stack3 => led_reg <= stack2;
					when stack4 => led_reg <= stack3;
					when stack5 => led_reg <= stack4;
					when stack6 => led_reg <= stack5;
					when stack7 => led_reg <= stack6;
					when stack8 => led_reg <= stack7;
					when others => led_reg <= stack8;
				end case;
			end if;
		end if;
	end if;
end process;

--Assign states the LED output code
LED_out <= "00000000" when led_reg = stack0 else
			  "00000001" when led_reg = stack1 else
			  "00000011" when led_reg = stack2 else
			  "00000111" when led_reg = stack3 else
			  "00001111" when led_reg = stack4 else
			  "00011111" when led_reg = stack5 else
			  "00111111" when led_reg = stack6 else
			  "01111111" when led_reg = stack7 else
			  "11111111" when led_reg = stack8 else
			  "10101010";

end Behavioral;

