----------------------------------------------------------------------------------
-- Company: USAFA/DFEC
-- Engineer: Silva
-- 
-- Create Date:    10:33:47 07/07/2012 
-- Design Name: 
-- Module Name:    MooreElevatorController_Silva - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
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

entity MealyElevatorController is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           stop : in  STD_LOGIC;
           up_down : in  STD_LOGIC;
           floor : out  STD_LOGIC_VECTOR (3 downto 0);
			  nextfloor : out std_logic_vector (3 downto 0));
end MealyElevatorController;

architecture Behavioral of MealyElevatorController is

type floor_state_type is (floor1, floor2, floor3, floor4);

signal floor_state : floor_state_type;

begin

---------------------------------------------------------
--Code your Mealy machine next-state process below
--Question: Will it be different from your Moore Machine?
---------------------------------------------------------
floor_state_machine: process(clk)
begin
	--On rising edge of clock
	if rising_edge(clk) then
	--The code will be the same as the moore machine as this process
	--represents the input logic!!! That was a lot of hitting my head against things
	--for nothing
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
				
--COMPLETE THE NEXT STATE LOGIC ASSIGNMENTS FOR FLOORS 3 AND 4
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
				--When the current state is floor 2
				when floor4 =>
					--The only moving condition is going down and not stopped
					if (up_down = '0' and stop = '0') then 
						--Move down to floor 3
						floor_state <= floor3;
					--For any other case stay at the same floor
					else 
						floor_state <= floor4;
					end if;
				
				--This line accounts for phantom states
				when others =>
					floor_state <= floor1;
			end case;
		end if;
	end if;
end process;

-----------------------------------------------------------
--Code your Ouput Logic for your Mealy machine below
--Remember, now you have 2 outputs (floor and nextfloor)
-----------------------------------------------------------
floor <= "0001" when (floor_state = floor1) else
			"0010" when (floor_state = floor2) else
			"0011" when (floor_state = floor3) else
			"0100" when (floor_state = floor4) else
			"0001";
--The nextfloor output is dependent on the mealy machine inputs
nextfloor <= "0001" when (floor_state = floor2 and up_down = '0') else
				 "0010" when ((floor_state = floor1) or (floor_state = floor3 and up_down = '0')) else
				 "0011" when ((floor_state = floor2 and up_down = '1') or (floor_state = floor4)) else
				 "0100" when (floor_state = floor3 and up_down = '1') else
				 "0001";

end Behavioral;

