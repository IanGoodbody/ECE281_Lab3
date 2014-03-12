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

#### VHDL Debugging

The first change made to the code was to add a default value to the generic statement on line 14. Although this is
unnecessary, the value is constant throughout the file, and adding a default value prevents errors associated with not
defining it in the Top Module

Original: Ln 14

  	generic ( CLOCK_IN_HZ : integer );
  
Modified: Ln 13

  	generic ( CLOCK_IN_HZ : integer := 50E6);
  
Next, the values for the internal signals had to be specifically specified. Although this capacity is accomplished by 
the reset switch, the top module has reset set to low. This change may be undone later in favor of initially activating
the reset in the top module

Original: Ln 31-34

  	signal state_reg, state_next : state_type;
	signal count_reg, count_next : unsigned(20 downto 0) := (others => 'U');
	signal sseg_reg, sseg_next : std_logic_vector(7 downto 0) := (others => 'U');
	signal sel_reg, sel_next : std_logic_vector(3 downto 0) := (others => 'U');
	
Modified: Ln 29-32
    
  	signal state_reg, state_ next : state_type := S0;
	signal count_reg, count_next : unsigned(20 downto 0) := (others => '0');
	signal sseg_reg, sseg_ next : std_logic_vector(7 downto 0) := (others => '0');
	signal sel_reg, sel_ next : std_logic_vector(3 downto 0) := "1110");
	
In the code for the reset function the output for sel_reg had to be changed because the output "sel" is an active low, 
or low hot thus a vector "0000" given by "others=>'0'" would be meaningless.

Original: Ln 49

  	sel_reg <= (others => '0');

Modified: Ln 46

  	sel_reg <= "1110";
  	
After the process a type mismatch occured in setting "next_count" variable. The program checks if "count_reg" is 
equivlent to "TICKS_IN_MS", which compares an unsigned number to an integer. The situation was rectified using an 
to_integer conversion

Original: Ln 61

	count_next <= (others => '0') when count_reg = TICKS_IN_MS else
	
Modified: Ln 58

	count_next <= (others => '0') when to_integer(count_reg) = TICKS_IN_MS else

Line 86 in the second process statement was deemed redundant and removed as the state_next signal would later be set in
the case statement.

The while statement in the same process statement also needed to be modified to account for all cases, and to avoid 
creating unwanted memory.

Original: Ln 80-81

	when s3 =>
		state_next <= s0;

Modified: Ln 74-75

	when others =>
		state_next <= s0;
		
Similar changes had to be made in the next process statement. The signal assignments on lines 91 and 92 were deemed 
redundant and removed, and the last case in the case statement was changed to account for all possibilities. With this 
modification the sensitivity list signals "sseg_reg" and "sel_reg" were removed as thy no longer contributed to the 
output.

Original: Ln 86-109

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

Modified: Ln 80-96

	process (state_next, sseg0, sseg1, sseg2, sseg3) is
	begin
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
			when others =>
				sseg_next <= sseg3;
				sel_next <= "0111";
		end case;
	end process;


The modified code was then used to create the schematic above. Checking over the sequence of this circuit seemed to validate that the modified code could be effectively synthesized without major bugs.
