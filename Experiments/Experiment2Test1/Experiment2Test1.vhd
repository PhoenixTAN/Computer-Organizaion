--------------------------------------------------------
--Author info:
--	  Name: TAN ZiQi  ID; 2015112210 Class: ONE, IOT
--	  Copyright: 
--		  All rights reserved.
--    History:
--		Created on Oct 24, 2017.	
--------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY Experiment2Test1 Is
	PORT(  Mode: IN STD_LOGIC; 
		   --Select Counter mode1 or Display mode0
		   CLK: IN STD_LOGIC; --1kHz Clock Signal
		   CLR: IN STD_LOGIC; --Clear Signal		   		   
   		   SEL: BUFFER STD_LOGIC_VECTOR( 2 DOWNTO 0 ); 
		   Sel3_8Decoder: BUFFER STD_LOGIC_VECTOR( 2 DOWNTO 0 ); 
		   --Control the input of the 3-8 decoder
		   LED7S: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 ); 
		   --Seven SEG LED		   
		   BitSelect: IN STD_LOGIC_VECTOR( 1 DOWNTO 0 ); 
		   --Select the number you want to control		   
		   Display: IN STD_LOGIC_VECTOR( 3 DOWNTO 0 ) 
		   --Control the value that every LED displays
		   );
END ENTITY Experiment2Test1;

ARCHITECTURE experiment2 OF Experiment2Test1 IS
BEGIN
	
	PROCESS(CLK)
	--Variables initialize.
	VARIABLE DividerVar1: INTEGER := 0; --Frequency Divider Variable1
	VARIABLE DividerVar2: INTEGER := 0; --Frequency Divider Variable2
	VARIABLE Bit0: INTEGER := 0;
	VARIABLE Bit1: INTEGER := 0;
	VARIABLE Bit2: INTEGER := 0;
	VARIABLE Bit3: INTEGER := 0;
	VARIABLE num: INTEGER := 0;
	TYPE HexToBin IS ARRAY(15 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	CONSTANT LookUpTable: HexToBin:=(x"71", x"79", x"5E", x"39",
									 x"7C", x"77", x"6F", x"7F", 
									 x"07", x"7D", x"6D", x"66", 
									 x"4F", x"5B", x"06", x"3F"
									);									
	BEGIN --PROCESS BEGIN			
		IF CLK'EVENT AND CLK = '1' THEN  --1kHz Clock Signal	
			IF CLR = '1' THEN
				Bit3 := 0; Bit2 := 0; Bit0 := 0; Bit0 := 0;
			END IF;											
			--Scan the LEDs 
			--IF DividerVar1 = 5 THEN -- 1000/5 = 200Hz; 200/4 = 50Hz;
				 --DividerVar1 := 0;			
				CASE Sel( 2 DOWNTO 0 ) IS
					WHEN "000" => LED7s <= LookUpTable(Bit3); Sel3_8Decoder <= SEL; SEL <= "001"; 
					WHEN "001" => LED7s <= LookUpTable(Bit2); Sel3_8Decoder <= SEL; SEL <= "010"; 
					WHEN "010" => LED7s <= LookUpTable(Bit1); Sel3_8Decoder <= SEL; SEL <= "011";
					WHEN "011" => LED7s <= LookUpTable(Bit0); Sel3_8Decoder <= SEL; SEL <= "000";
					WHEN OTHERS => NULL;
				END CASE;
			--END IF;
			
			IF Mode = '1'	THEN -- 4 bit Hex Counter mode
				DividerVar2 := DividerVar2 + 1;				
				IF DividerVar2 = 1000 THEN --Count 1 Every 100 times
					DividerVar2 := 0;
					Bit0 := Bit0 + 1;
					--Carry Over----------------------------------------
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
					-----------------------------------------------------
				END IF;												
								
			END IF; --Mode1 END IF
			
			IF Mode = '0' THEN --Display mode
				CASE Display( 3 DOWNTO 0 ) IS
					WHEN "0000" => num := 0;
					WHEN "0001" => num := 1;
					WHEN "0010" => num := 2;
					WHEN "0011" => num := 3;
					WHEN "0100" => num := 4;
					WHEN "0101" => num := 5;
					WHEN "0110" => num := 6;
					WHEN "0111" => num := 7;
					WHEN "1000" => num := 8;
					WHEN "1001" => num := 9;
					WHEN "1010" => num := 10;
					WHEN "1011" => num := 11;
					WHEN "1100" => num := 12;
					WHEN "1101" => num := 13;
					WHEN "1110" => num := 14;
					WHEN "1111" => num := 15;
					WHEN OTHERS => NULL;
				END CASE;
				
				CASE BitSelect( 1 DOWNTO 0 ) IS
					WHEN "00" => Bit0 := num; 
					WHEN "01" => Bit1 := num; 
					WHEN "10" => Bit2 := num;
					WHEN "11" => Bit3 := num;
					WHEN OTHERS => NULL;
				END CASE;
			END IF; --Mode 0 END IF		
		
		END IF; --Clock Event END
	
	END PROCESS;
	
END ARCHITECTURE experiment2;

