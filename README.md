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

The first portion of the main lab was to critique the code for the moore elevator controller shell provided in Computer Exercise 3. Although the vhdl shell code was implemented successfully in Computer Exercise 3 and successfully modified throughout the lab, there are a number of changes that would make the shell code more compact and effecient. (The unmodified shell code is provided in the repository).

The first change would be to modify the clock parameter in the if condition on line 51:

Origional:

	if clk'event and clk='1' then
	
Modified

	if rising_edge(clk) then
	
Although both clock conditions are valid and have the same effect, the modified verson is more compact and more straightforward for human readability.

A second possible change would be to place the check for the stop condition outside of the case statement rather than within the case statement for each individual case (only the first case in teh case statment is provided for readability).

Oritional: Ln 58 - 69

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
					
Modified:

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

In the process of carrying out the lab, the code critique step above was carried out on the nexys2_sseg.vhd file. Unfortunately, the changes made were neither effective nor necessary as the critique was not supposed to be made to the file, and upon using the modified file two of the four seven segment displays on the Nexys board were unlit. Consequently the origional file was implemented throughout the design with the file named "nexys2 _sseg _raw.vhd." The modified file was left in the repository as "nexys2 _sseg.vhd"

The Moore Machine was implemented using an up/down and stop control inputs which were then wired to the input switches. The output counter was routed to the rightmost digit while the other three nibbles and seven segment outputs were set to zero. The machine was tested by switching the up_down switch on, allowing the machine to count from floor 1 to floor 4 while intermittently testing the stop switch (the numbers stopped counting when the switch was on), then switching the up _down switch off (direction down) then allowing the counter to return from 4 to 1.

The Mealy machine was implemented with the same basic framework as the Moore, except the next_floor output was wired to a different seven segment display. This machine was tested similarly to that of the Moore with the addition of checking that the next _floor output was correct. While the machine was cycling up and down the stop input was tested to make sure the machine stopped counting when prompted, and the up _down switch was tested to ensure that the next floor output changed appropriately. On the "top " and "bottom" floors the next floor output gave either the current floor, indicating that there were no more possible moves in that direction, or the only logical next move either up or down.

The Prime counter was built off of the Moore machine and was tested in an identical manner, provided that the design only cycled through prime numbers. The prime counter implementation was unique in that it had to display multiple decimal digits from a binary output. This was accomplished by making the output of the PrimeElevatorController correspond to a decimal number whee each nibble of the output represented the appropriate decimal digit. This method translated very easily to the seven segment display as the controller output simply had to be split and routed to two different segment displays.

The next design utalized a binary input to control the movement of the elevator. The design was structured off of the origional moore elevator controller design, but in stead of using signals to determine direction, the comparable properties of enumerated floor_ state_type which allows the software to determine if the "current" floor was "above," "below," or "on" the "target" floor. These conditions were then used to determine the movement of the elevaator. The top module was then configured to display the target floor as well as the current floor on the seven segment display to allow for easier testing.

The design was tested by spot checking arbitrary floor values between 0 and 7, ensuring that the "target floor" output read as it was designed, then checking that the "current floor" display counted either up or down to the target floor.

Finally, the directional light functionality was implementated such that up was indicated by the LEDs sequentally turning on from right to left, down indicated by a LEDs turning off from left to right, and no motion indicated by all LEDs staying on. This function was added on top of the binary input machine using a new light controller module that produced the LED pattern based on up_down and stop outputs produced by the elevator controller module.

The design was tested similarly to the binary input machine above with the addition of ensuring that the LED lighting sequence functioned as designed.


Documentation: None
