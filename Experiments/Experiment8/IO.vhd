--I/O Adapter
--supplementary module
LIBRARY IEEE;
LIBRARY IEEE;
USE IEEE.STD_lOGIC_1164.ALL;

ENTITY IO IS 
	PORT(
		CLK: IN STD_LOGIC; 
--		K1: IN STD_LOGIC; --RA1
--		K2: IN STD_LOGIC; --RA0
--		K3: IN STD_LOGIC; --WT
--		K4: IN STD_LOGIC; --RD
--		K5: IN STD_LOGIC; --MAIN SWITCH
--		K6: IN STD_LOGIC; 
--		K7: IN STD_LOGIC; 
--		K8: IN STD_LOGIC; 
--		K9: IN STD_LOGIC; 
--		K10: IN STD_LOGIC; 
--		K11: IN STD_LOGIC; 
--		K12: IN STD_LOGIC; 
		S1: IN STD_LOGIC; --Reboot
--		S2: IN STD_LOGIC; --PC M1
--		S3: IN STD_LOGIC; --PC M2
--		S4: IN STD_LOGIC; --PC RST
		S5: IN STD_LOGIC; --Execute automatically
		
		
		LED: IN STD_LOGIC_VECTOR( 3 DOWNTO 0 );
		LED1: OUT STD_LOGIC_VECTOR( 3 DOWNTO 0 );
		--LED1 STATE0
		--LED2 STATE1
		--LED3 STATE2
		--LED4 STATE3
		
		--LED7S
		DataInput: IN STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		BitSelect: BUFFER STD_LOGIC_VECTOR( 2 DOWNTO 0 );
		BitSelect1: BUFFER STD_LOGIC_VECTOR( 2 DOWNTO 0 );
		LED7S: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		CB: BUFFER STD_LOGIC_VECTOR( 9 DOWNTO 0 )
		
	);
END ENTITY IO;

ARCHITECTURE KDistribution OF IO IS
BEGIN
	P1: PROCESS(CLK) 
	BEGIN
--		CB(0) <= K1;
--		CB(1) <= K2;
--		CB(2) <= K3;
--		CB(3) <= K4;
--		CB(4) <= K5;
		--5ms~10ms
		CB(5) <= S1;
--		CB(6) <= S2;
--		CB(7) <= S3;
--		CB(8) <= S4;
		CB(9) <= S5;
	
	END PROCESS P1;
	
	P2: PROCESS(CLK) --7 SEG LEDS PROCESS
	VARIABLE Divider: INTEGER := 0;
	VARIABLE LEDDATA: STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	BEGIN
	IF CLK'EVENT AND CLK = '1' THEN
		IF Divider = 2 THEN --1KHz 8 LEDs  1000/3/8=40Hz
			Divider := 0;
			CASE BitSelect1( 2 DOWNTO 0 ) IS
				WHEN "000" => LEDDATA := DATAINPUT( 31 DOWNTO 28 ); BitSelect <= BitSelect1; BitSelect1 <= "001";
				WHEN "001" => LEDDATA := DATAINPUT( 27 DOWNTO 24 ); BitSelect <= BitSelect1; BitSelect1 <= "010";
				WHEN "010" => LEDDATA := DATAINPUT( 23 DOWNTO 20 ); BitSelect <= BitSelect1; BitSelect1 <= "011";
				WHEN "011" => LEDDATA := DATAINPUT( 19 DOWNTO 16 ); BitSelect <= BitSelect1; BitSelect1 <= "100";
				WHEN "100" => LEDDATA := DATAINPUT( 15 DOWNTO 12 ); BitSelect <= BitSelect1; BitSelect1 <= "101";
				WHEN "101" => LEDDATA := DATAINPUT( 11 DOWNTO 8 ); BitSelect <= BitSelect1; BitSelect1 <= "110";
				WHEN "110" => LEDDATA := DATAINPUT( 7 DOWNTO 4 ); BitSelect <= BitSelect1; BitSelect1 <= "111";
				WHEN "111" => LEDDATA := DATAINPUT( 3 DOWNTO 0 ); BitSelect <= BitSelect1; BitSelect1 <= "000";
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
	END PROCESS P2;
	
END ARCHITECTURE KDistribution;