--My LED Block
LIBRARY IEEE;
USE IEEE.STD_lOGIC_1164.ALL;
USE IEEE.STD_lOGIC_UNSIGNED.ALL;

ENTITY MyLED IS
	PORT(
		CLK: IN STD_LOGIC;		
		DataInput: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 );
		BitSelect: BUFFER STD_LOGIC_VECTOR( 2 DOWNTO 0 );
		BitSelect1: BUFFER STD_LOGIC_VECTOR( 2 DOWNTO 0 );
		LED7S: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 )
	);
END ENTITY MyLED;

ARCHITECTURE LED OF MyLED IS 
BEGIN
	
	P1: PROCESS(CLK) --7 SEG LEDS PROCESS
	VARIABLE Divider: INTEGER := 0;
	VARIABLE LEDDATA: STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	BEGIN
	IF CLK'EVENT AND CLK = '1' THEN
		IF Divider = 4 THEN --1KHz 4 LEDs  1000/5/4=50Hz
			Divider := 0;
			CASE BitSelect1( 2 DOWNTO 0 ) IS
				WHEN "000" => LEDDATA := DATAINPUT( 3 DOWNTO 0 ); BitSelect <= BitSelect1; BitSelect1 <= "001";
				WHEN "001" => LEDDATA := DATAINPUT( 7 DOWNTO 4 ); BitSelect <= BitSelect1; BitSelect1 <= "010";
				WHEN "010" => LEDDATA := DATAINPUT( 11 DOWNTO 8 ); BitSelect <= BitSelect1; BitSelect1 <= "011";
				WHEN "011" => LEDDATA := DATAINPUT( 15 DOWNTO 12 ); BitSelect <= BitSelect1; BitSelect1 <= "000";
--				WHEN "100" => BitSelect <= BitSelect1; BitSelect1 <= "101";
--				WHEN "101" => BitSelect <= BitSelect1; BitSelect1 <= "110";
--				WHEN "110" => BitSelect <= BitSelect1; BitSelect1 <= "111";
--				WHEN "111" => BitSelect <= BitSelect1; BitSelect1 <= "000";
				WHEN OTHERS => NULL;
			END CASE;
				
			CASE LEDDATA( 3 DOWNTO 0 ) IS
				WHEN "0000" => LED7S <= x"3F"; --0
				WHEN "0001" => LED7S <= x"06"; --1
				WHEN "0010" => LED7S <= x"5B"; --2
				WHEN "0011" => LED7S <= x"4F"; --3
				WHEN "0100" => LED7S <= x"66"; --4
				WHEN "0101" => LED7S <= x"6D"; --5
				WHEN "0110" => LED7S <= x"7D"; --6
				WHEN "0111" => LED7S <= x"07"; --7
				WHEN "1000" => LED7S <= x"7F"; --8
				WHEN "1001" => LED7S <= x"6F"; --9
				WHEN "1010" => LED7S <= x"77"; --A
				WHEN "1011" => LED7S <= x"7C"; --B
				WHEN "1100" => LED7S <= x"39"; --C
				WHEN "1101" => LED7S <= x"5E"; --D
				WHEN "1110" => LED7S <= x"79"; --E
				WHEN "1111" => LED7S <= x"71"; --F
				WHEN OTHERS => NULL;
			END CASE;

		ELSE
			Divider := Divider + 1;
		END IF;
	
	END IF;	
	END PROCESS P1;

END ARCHITECTURE LED;