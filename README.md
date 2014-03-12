ECE281_Lab3
===========

More advanced elevator controller

### Pre-lab

#### Summary

For the pre-lab the object was to fix coding errors in the provided shell code and to create an incomplete schematic for
the elevator control system. The main body of executable code is contained in the nexys2_ sseg.vhd file. IN the files 
provided, the nexys2_ sseg.vhd file is the edited file that will be implemented in later modules while the nexys2_ sseg_
raw.vhd provides the origional code for comparison. The assignment also required that we draw a schematic for the 
nexys2_ top_ shell.vhd circuit; however, schematics for both the top module and the nexys2_ sseg.vhd modle are provided 
here to aid in interpreting the changes made to the nexys2_sseg.vhd circuit.

#### Nexys2_top _shell.vhd
![alt text](https://raw.githubusercontent.com/IanGoodbody/ECE281_Lab3/master/Nexys2_top_schematic.jpg "Top Module")

#### nexys2_sseg.vhd
![alt text](https://raw.githubusercontent.com/IanGoodbody/ECE281_Lab3/master/nexys2_sseg_schematic.jpg "sseg Module")

#### VHDL Debugging

The first change made to the code was to add a default value to the genergic statment on line 14. Although this is
unnecessary, the value is constant throughout the file, and adding a dfault value prevents errors associated with not
defining it in the Top Module

Origional: Ln 14

  generic ( CLOCK_ IN_HZ : integer );
  
Modified: Ln 13

  generic ( CLOCK_ IN_HZ : integer := 50E6);
  
Next, the values for the internal signals had to be specifically specified. Although this capacity is accomplished by 
the reset switch, the top module has reset set to low. This change may be undone later in favor of initally activating
the reset in the top module

Origional: Ln 31-34

  signal state_ reg, state_ next : state_type;
	signal count_ reg, count_next : unsigned(20 downto 0) := (others => 'U');
	signal sseg_ reg, sseg_ next : std_ logic_vector(7 downto 0) := (others => 'U');
	signal sel_ reg, sel_ next : std_ logic_vector(3 downto 0) := (others => 'U');
	
Modified: Ln 29-32
    
  signal state_ reg, state_ next : state_type := S0;
	signal count_ reg, count_next : unsigned(20 downto 0) := (others => '0');
	signal sseg_ reg, sseg_ next : std_ logic_vector(7 downto 0) := (others => '0');
	signal sel_ reg, sel_ next : std_ logic_vector(3 downto 0) := "1110");
	
In the code for the reset function the output for sel_reg had to be changed ecause the output sel is an active low, or 
low hot thus a vector "0000" given by "others=>'0'" would be meaningless.

Origional: Ln 49

  sel_reg <= (others => '0');

Modified: Ln 46

  sel_reg <= "1110";
