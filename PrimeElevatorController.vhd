----------------------------------------------------------------------------------
-- Company: USAFA/DFEC
-- Engineer: Ian Goodbody
-- 
-- Create Date:    02:06:26 03/17/2014 
-- Design Name: 		Lab 3
-- Module Name:    PrimeElevatorController - Behavioral 
-- Description: 	 Controlls an elevatyor that goes only to prime number floors 
-- like a bad middleschool math problem.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PrimeElevatorController is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           stop : in  STD_LOGIC;
           up_down : in  STD_LOGIC;
           floor : out  STD_LOGIC_VECTOR (7 downto 0));
end PrimeElevatorController;

architecture Behavioral of PrimeElevatorController is

--Below you create a new variable type! You also define what values that 
--variable type can take on. Now you can assign a signal as 
--"floor_state_type" the same way you'd assign a signal as std_logic 

--Edit floor states so there are 8 options, they will be made prime later in the output phase
type floor_state_type is (floor1, floor2, floor3, floor4, floor5, floor6, floor7, floor8);

--Here you create a variable "floor_state" that can take on the values
--defined above. Neat-o!
signal floor_state : floor_state_type;

begin
---------------------------------------------
--Below you will code your next-state process
---------------------------------------------

--This line will set up a process that is sensitive to the clock
floor_state_machine: process(clk) -- No reset signal in sensitivity list therefore the reset is syncronyous 
begin
	--clk'event and clk='1' is VHDL-speak for a rising edge
	if clk'event and clk='1' then
		--reset is active high and will return the elevator to floor1
		--Question: is reset synchronous or asynchronous?
		if reset='1' then
			floor_state <= floor1;
		--now we will code our next-state logic
		else
			case floor_state is
				--when our current state is floor1
				when floor1 =>
					--if up_down is set to "go up" and stop is set to 
					--"don't stop" which floor do we want to go to?
					if (up_down='1' and stop='0') then 
						--floor2 right?? This makes sense!
						floor_state <= floor2;
					--otherwise we're going to stay at floor1
					else
						floor_state <= floor1;
					end if;
					
				--when our current state is floor2
				when floor2 => 
					--if up_down is set to "go up" and stop is set to 
					--"don't stop" which floor do we want to go to?
					if (up_down='1' and stop='0') then 
						floor_state <= floor3; 			
					--if up_down is set to "go down" and stop is set to 
					--"don't stop" which floor do we want to go to?
					elsif (up_down='0' and stop='0') then 
						floor_state <= floor1;
					--otherwise we're going to stay at floor2
					else
						floor_state <= floor2;
					end if;
					
				when floor3 =>
					--Moving down and not stopping
					if (up_down = '0' and stop = '0') then 
						-- Move down to floor 2
						floor_state <= floor2;
					--Moving up and not stopping
					elsif (up_down = '1' and stop = '0') then
						--Move to floor 4
						floor_state <= floor4;	
					--no matter what if it is stopped
					else
						floor_state <= floor3;
					end if;
					
				--When the current state is floor 4
				when floor4 =>
					--Moving down and not stopping
					if (up_down = '0' and stop = '0') then 
						-- Move down a floor
						floor_state <= floor3;
					--Moving up and not stoping
					elsif (up_down = '1' and stop = '0') then
						--Move up a floor
						floor_state <= floor5;	
					--no matter what if it is stopped
					else
						floor_state <= floor4;
					end if;
					
				when floor5 =>
					--Moving down and not stopping
					if (up_down = '0' and stop = '0') then 
						-- Move down a floor
						floor_state <= floor4;
					--Moving up and not stoping
					elsif (up_down = '1' and stop = '0') then
						--Move up a floor
						floor_state <= floor6;	
					--no matter what if it is stopped
					else
						floor_state <= floor5;
					end if;
					
				when floor6 =>
					--Moving down and not stopping
					if (up_down = '0' and stop = '0') then 
						-- Move down a floor
						floor_state <= floor5;
					--Moving up and not stoping
					elsif (up_down = '1' and stop = '0') then
						--Move up a floor
						floor_state <= floor7;	
					--no matter what if it is stopped
					else
						floor_state <= floor6;
					end if;
					
				when floor7 =>
					--Moving down and not stopping
					if (up_down = '0' and stop = '0') then 
						-- Move down a floor
						floor_state <= floor6;
					--Moving up and not stoping
					elsif (up_down = '1' and stop = '0') then
						--Move up a floor
						floor_state <= floor8;	
					--no matter what if it is stopped
					else
						floor_state <= floor7;
					end if;
					
				when floor8 =>
					--The only moving condition is going down and not stopped
					if (up_down = '0' and stop = '0') then 
						--Move down to floor 7
						floor_state <= floor7;
					--For any other case stay at the same floor
					else 
						floor_state <= floor8;
					end if;
				
				--This line accounts for phantom states
				when others =>
					floor_state <= floor1;
			end case;
		end if;
	end if;
end process;

-- Here is where I make the outputs whatever prime numbers I please,
-- The output is formatted so each nibble corresponds with a binary digit
floor <= "00000010" when (floor_state = floor1) else --2
			"00000011" when (floor_state = floor2) else --3
			"00000101" when (floor_state = floor3) else --5
			"00000111" when (floor_state = floor4) else --7
			"00010001" when (floor_state = floor5) else --11
			"00010011" when (floor_state = floor6) else --13
			"00010111" when (floor_state = floor7) else --17
			"00011001" when (floor_state = floor8) else --19
			"00000010"; --otherwise reset output to floor 1 or primue 2

end Behavioral;

