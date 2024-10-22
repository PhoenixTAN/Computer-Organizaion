LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY SevenSegLEDNixietude Is
	PORT(  Mode: IN STD_LOGIC; --Select Counter mode1 or Display mode0
		   CLK: IN STD_LOGIC; --100Hz Clock Signal		   
		   Bit1: INTEGER RANGE 0 TO 15;
		   BitSelect: IN STD_LOGIC_VECTOR( 2 DOWNTO 0 ); --Select the number you want to control
		   SEL: BUFFER STD_LOGIC_VECTOR( 2 DOWNTO 0 );
		   Display: IN STD_LOGIC_VECTOR( 3 DOWNTO 0 ); --Control the value the ONE LED
		   Sel3_8Decoder:OUT STD_LOGIC_VECTOR( 2 DOWNTO 0 ); --Control the input of the 3-8 decoder
		   LED7S: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 ) --Seven SEG LED
		   );
END ENTITY SevenSegLEDNixietude;

ARCHITECTURE experiment2 OF SevenSegLEDNixietude IS
BEGIN
	
	PROCESS(CLK)
	VARIABLE DividerVar: INTEGER := 0; 
	VARIABLE DividerVarLED: INTEGER ; 
	VARIABLE Bit0: INTEGER := 0;
	VARIABLE Bit1: INTEGER := 0;
	VARIABLE Bit2: INTEGER := 0;
	VARIABLE Bit3: INTEGER := 0;
	
	TYPE HexToBin IS ARRAY(15 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	CONSTANT LookUpTable: HexToBin:=(x"8E", x"86", x"A1", x"C6",
									 x"83", x"88", x"90", x"80", 
									 x"F8", x"82", x"92", x"99", 
									 x"B0", x"A4", x"F9", x"C0"
									);
									
	BEGIN
		
		IF CLK'EVENT AND CLK = '1' THEN  --1k
										
			--Scan the LEDs
			case Sel( 2 DOWNTO 0 ) IS
				WHEN "000" => LED7s <= LookUpTable(Bit0); Sel3_8Decoder <= SEL; SEL <= "001"; 
				WHEN "001" => LED7s <= LookUpTable(Bit1); Sel3_8Decoder <= SEL; SEL <= "010"; 
				WHEN "010" => LED7s <= LookUpTable(Bit2); Sel3_8Decoder <= SEL; SEL <= "011";
				WHEN "011" => LED7s <= LookUpTable(Bit3); Sel3_8Decoder <= SEL; SEL <= "000";
				WHEN OTHERS => NULL;
			END CASE;			
			
			IF Mode = '1'	THEN --Counter mode
				DividerVar := DividerVar + 1;
				IF DividerVar = 100 THEN --Count 1 Every 100 times
					DividerVar := 0;
					Bit0 := Bit0 + 1;
					IF Bit0 = 16 THEN
						Bit1 := Bit1 + 1; Bit0 := 0;
					END IF;
					IF Bit1 = 16 THEN
						Bit2 := Bit2 + 1; Bit1 := 0;
					END IF;
					IF Bit2 = 16 THEN
						Bit3 := Bit3 + 1; Bit2 := 0;
					END IF;
					IF Bit3 = 16 THEN
						Bit3 := 0; Bit2 :=0; Bit1 := 0; Bit0 := 0;
					END IF;
				END IF;
								
				
			ELSE DividerVar := 0;
			
			END IF;
			
			IF Mode = '0' THEN --Display mode
				
			END IF;			
		
		END IF;
	
	END PROCESS;
	
END ARCHITECTURE experiment2;