LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY _7SegLEDNixietude Is
	PORT(  Mode: IN STD_LOGIC; --Select Counter mode1 or Display mode0
		   CLK: IN STD_LOGIC; --100Hz Clock Signal
		   DividerVar: INTEGER RANGE 0 TO 100; --Frequency Divider
		   BitSelcet: IN STD_LOGIC_VECTOR( 1 DOWNTO 0 ); --Select the number you want to control
		   Display: IN STD_LOGIC_VECTOR( 3 DOWNTO 0 ); --Control the value the ONE LED
		   LED7S: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 ) ); --Seven SEG LED
		   );
END ENTITY _7SegLEDNixietude;

ARCHITECTURE experiment2 OF _7SegLEDNixietude IS
BEGIN
	DividerVar <= 0; --Initialize the variable
	SIGNAL bit3, bit2, bit1, bit0: INTEGER RANGE 0 TO 15;
	TYPE HexToBin IS ARRAY(15 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	CONSTANT LookUpTable: HexToBin:=(x"0C", x"F9", x"A4", x"B0",
									x"99", x"92", x"82", x"F8", 
									x"80", x"90", x"88", x"83", 
									x"C6", x"A1", x"86", x"8E"
									);
	PROCESS(CLK)
	BEGIN
		IF CLK = '1'; THEN
			IF Mode = '1';	THEN --Counter mode
				DividerVar <= DividerVar + 1;
				IF DividerVar = 100; THEN --Count 1 Every 100 times
					
				
				
			ELSE
				DividerVar = 0;
			
			END IF;
			
			IF Mode = '0'; THEN --Display mode
		
			END IF;			
		
		END IF;
	
	END PROCESS;
	
END ARCHITECTURE experiment2;