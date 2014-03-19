ECE281_Lab3
===========

More advanced elevator controller

### Pre-lab

#### Summary

For the pre-lab the object was to fix coding errors in the provided shell code and to create an incomplete schematic for
the elevator control system. The main body of executable code is contained in the nexys2_sseg.vhd file. IN the files 
provided, the nexys2_sseg.vhd file is the edited file that will be implemented in later modules while the nexys2_sseg_
raw.vhd provides the origional code for comparison. The assignment also required that we draw a schematic for the 
nexys2_top_shell.vhd circuit; however, schematics for both the top module and the nexys2_sseg.vhd modle are provided 
here to aid in interpreting the changes made to the nexys2_sseg.vhd circuit.

#### Nexys2_top _shell.vhd
![alt text](https://raw.githubusercontent.com/IanGoodbody/ECE281_Lab3/master/Nexys2_top_schematic.jpg "Top Module")

#### nexys2_sseg.vhd
![alt text](https://raw.githubusercontent.com/IanGoodbody/ECE281_Lab3/master/nexys2_sseg_schematic.jpg "sseg Module")


### Main Lab

#### Code critique

The first portion of the main lab was to critique the code for the moore elevator controller shell provided in Computer Exercise 3. Although the vhdl shell code was implemented successfully in Computer Exercise 3 and successfully modified throughout the lab, there are a number of changes that would make the shell code more compact and effecient. (The unmodified shell code is provided in the repository (MooreElevatorController_Shell.vhd).

The first change would be to modify the clock parameter in the if condition on line 51:

Bad Code: Ln 51

	if clk'event and clk='1' then
	
Better Code:

	if rising_edge(clk) then
	
Although both clock conditions are valid and have the same effect, the modified verson is more compact and more straightforward for human readability.

A second possible change would be to place the check for the stop condition outside of the case statement rather than within the case statement for each individual case (only the declaration and second case in the case statment is provided for readability).

Bad Code: Ln 58 - 69

	case floor_state is
	...
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
					
Good Code:

	if stop = '1' then
		floor_state <= floor_state;
	else
		case floor_state is
			...
			--when our current state is floor2
			when floor2 => 
				--if up_down is set to "go up" and stop is set to 
				--"don't stop" which floor do we want to go to?
				if (up_down='1') then 
					floor_state <= floor3; 			
				--if up_down is set to "go down" and stop is set to 
				--"don't stop" which floor do we want to go to?
				else
					floor_state <= floor1;
				end if;
		...
		end case;
	...
	end if;
	
By adding the if statement to the top of the case block the case statement if conditions do not have to contain a check for the stop condition and ass seen above do not require the extra if term. This greatly simplifies coding the shell and makes the code more effecient as a stopped elevator defaults to not moving without the extra check.

#### Functionality design and implementation

The goal of the main lab was to create a fully functional elevator controller using the control circuits created in Computer Exercise 3.

In the process of carrying out the lab, the code critique step above was originally carried out on the nexys2_ sseg.vhd file rather than the MooreElevatorController_shell. Unfortunately, the changes made were neither effective nor necessary as the critique was not supposed to be made to the file, and upon using the modified file two of the four seven segment displays on the Nexys board were unlit. Consequently the origional file was implemented throughout the design with the file named "nexys2 _sseg _raw.vhd." The modified file was left in the repository as "nexys2 _sseg.vhd"

The Moore Machine (MooreElevatorController.vhd) was designed to move between 4 floors (1 to 4) using an "up_ down" and a "stop" control inputs. The output counter was routed to the rightmost digit while the other three nibbles and seven segment outputs were set to zero, the two inputs were controlled by switches on the Nexys board. The machine was tested by switching the up_down switch on (the up direction), allowing the machine to count from floor 1 to floor 4 while intermittently testing the stop switch (the numbers stopped counting when the switch was on), then switching the up _down switch off (the down direction) then allowing the counter to return from 4 to 1.

The Mealy machine (MealElevatorController.vhd) was implemented with the same basic framework as the Moore with the next floor displayed alongside the current floor. The design was implemented by wiring "next_floor" to a different seven segment display. This machine was tested similarly to that of the Moore with the addition of checking that the next _floor output was correct. While the machine was cycling up and down the "stop" input was tested to make sure the machine stopped counting when prompted, and the "up _down" switch was tested to ensure that the next floor output changed appropriately. On the "top" and "bottom" floors the next floor output gave either the current floor, indicating that there were no more possible moves in that direction, or the logical next move either up or down.

The Prime counter (PrimeElevatorController.vhd) was built off of the Moore machine and designed to go through 8 floors with designated prime number floor numbers. The prime counter implementation was unique from the Mooore machine in that it had to display multiple decimal digits from a binary output, and cycle through 8 different floors. The additional floors were created by expanding the values in the "floor_ state_type" and accounting for the additional states in the case statment. The multiple digit output was accomplished by making the output of the PrimeElevatorController an 8 bit number wich each nibble representing a decimal digit (ie *0010 0011* would correspond to a decimal 23). This method translated very easily to the seven segment display as the controller output simply had to be split and route each output nibble two different seven segment displays.

The next design (DiffInputElevatorController.vhd) utilized a binary input to control the movement of the elevator, where the user would input a binary number ("000" to "111" or 0 to 7)and the elevator would follow to that floor. The design was structured off of the origional moore elevator controller design, but instead of using up, down, and stop signals to determine direction, the design used the comparable properties of enumerated "floor_ state_type," which allows the software to determine if the "current" floor was "above," "below," or "on" the "target" floor (floor5 < floor7 indicates that floor5 is below floor7). These conditions were then used to determine the movement of the elevator. The top module was then configured to display the target floor as well as the current floor on the seven segment display to allow for easier testing.

The design was then tested by spot checking arbitrary floor values between 0 and 7, ensuring that the "target floor" output read as it was designed, then checking that the "current floor" display counted either up or down to the target floor.

Finally, the directional light functionality (LightedElevatorController.vhd) was implemented such that up was indicated by the LEDs sequentially turning on from right to left, down indicated by a LEDs turning off from left to right, and no motion indicated by all LEDs staying on. This function was added on top of the binary input machine using a new light controller module (LightController.vhd) that produced the LED pattern based on up_down and stop outputs produced by the elevator controller module.

The design was tested similarly to the binary input machine above with the addition of ensuring that the LED lighting sequence functioned as designed.


Documentation: None
