LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY CPURegister IS
	PORT(
		CLK: IN STD_LOGIC;
--		RA: IN STD_LOGIC_VECTOR( 1 DOWNTO 0 ); --	
--		Wt: IN STD_LOGIC; --
--		Rd: IN STD_LOGIC; --		
		RST: IN STD_LOGIC; --
		HLInput: IN STD_LOGIC; --
		M: IN STD_LOGIC_VECTOR( 1 DOWNTO 0 ); --S2S3
		Data: IN STD_LOGIC_VECTOR( 3 DOWNTO 0 ); --K9K10K11K12
--		LEDOutput: buffer STD_LOGIC_VECTOR( 15 DOWNTO 0 )
		OutputAddr: BUFFER STD_LOGIC_VECTOR( 7 DOWNTO 0 )
		);
END ENTITY CPURegister;

ARCHITECTURE MyCPURegister OF CPURegister IS
	SIGNAL delay: STD_LOGIC_VECTOR( 10 DOWNTO 0 );
BEGIN
		
	P1: PROCESS(CLK,RST,M) --PC
	VARIABLE PC: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	--VARIABLE Divider: INTEGER := 0;
	BEGIN
		IF RST = '0' THEN
			PC := "00000000";
		ELSIF CLK'EVENT AND CLK = '0' THEN 
--			delay <= delay + 1;
--			IF M = "00" THEN
--				CASE HLINPUT IS
--					WHEN '0' => PC( 3 DOWNTO 0 ) := Data;
--					WHEN '1' => PC( 7 DOWNTO 4 ) := Data;
--					WHEN OTHERS => NULL;
--				END CASE;
--			ELSIF M = "01" AND delay = "0" THEN
--				PC := PC + 1; 
--				 					
--			ELSIF M = "10" AND delay = "0" THEN			
--				PC := PC - 1; 
				
			IF M = "00" THEN
				CASE HLINPUT IS
					WHEN '0' => PC( 3 DOWNTO 0 ) := Data;
					WHEN '1' => PC( 7 DOWNTO 4 ) := Data;
					WHEN OTHERS => NULL;
				END CASE;
			ELSIF M = "01" THEN
				PC := PC + 8; 				 					
			ELSIF M = "10" THEN			
				PC := PC - 8; 													
			END IF; --CLK EVENT
	
		END IF; --RST
		OutputAddr <= PC;
	END PROCESS P1;
	
--	P2: PROCESS(CLK) --Register Block
--	VARIABLE R0: STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := "00000000";
--	VARIABLE R1: STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := "00000000";
--	VARIABLE R2: STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := "00000000";
--	VARIABLE R3: STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := "00000000";
--	BEGIN
--		IF CLK'EVENT AND CLK = '1' THEN
--			--R0-------------------------------------------------
--			IF RA = "00" THEN -- Register R0
--				IF Wt = '0' AND Rd = '1' THEN --Write
--					CASE HLINPUT IS
--						WHEN '0' => R0( 3 DOWNTO 0 ) := Data;
--						WHEN '1' => R0( 7 DOWNTO 4 ) := Data;
--						WHEN OTHERS => NULL;
--					END CASE;			
--				--END IF; --Write
--			
--				ELSIF Wt = '1' AND Rd = '0' THEN --Read
--					LEDOutput( 7 DOWNTO 0 ) <= R0;
--				ELSE NULL; --Read
--				END IF;
--			END IF; --R0
--			-----------------------------------------------------
--			
--			--R1-------------------------------------------------
--			IF RA = "01" THEN -- Register R1
--				IF Wt = '0' AND Rd = '1' THEN --Write
--					CASE HLINPUT IS
--						WHEN '0' => R1( 3 DOWNTO 0 ) := Data;
--						WHEN '1' => R1( 7 DOWNTO 4 ) := Data;
--						WHEN OTHERS => NULL;
--					END CASE;			
--				--END IF; --Write
--			
--				ELSIF Wt = '1' AND Rd = '0' THEN --Read
--					LEDOutput( 7 DOWNTO 0 ) <= R1;
--				ELSE NULL; --Read
--				END IF;
--			END IF; --R1
--			-----------------------------------------------------
--			--R2-------------------------------------------------
--			IF RA = "10" THEN -- Register R2
--				IF Wt = '0' AND Rd = '1' THEN --Write
--					CASE HLINPUT IS
--						WHEN '0' => R2( 3 DOWNTO 0 ) := Data;
--						WHEN '1' => R2( 7 DOWNTO 4 ) := Data;
--						WHEN OTHERS => NULL;
--					END CASE;			
--				--END IF; --Write
--			
--				ELSIF Wt = '1' AND Rd = '0' THEN --Read
--					LEDOutput( 7 DOWNTO 0 ) <= R2;
--				ELSE NULL; --Read
--				END IF;
--			END IF; --R2
--			-----------------------------------------------------
--			--R3-------------------------------------------------
--			IF RA = "11" THEN -- Register R3
--				IF Wt = '0' AND Rd = '1' THEN --Write
--					CASE HLINPUT IS
--						WHEN '0' => R3( 3 DOWNTO 0 ) := Data;
--						WHEN '1' => R3( 7 DOWNTO 4 ) := Data;
--						WHEN OTHERS => NULL;
--					END CASE;			
--				--END IF; --Write
--			
--				ELSIF Wt = '1' AND Rd = '0' THEN --Read
--					LEDOutput( 7 DOWNTO 0 ) <= R3;
--				ELSE NULL; --Read
--				
--				END IF;
--			END IF; --R3
--			-----------------------------------------------------
--	
--		END IF;	--CLK EVENT
--	END PROCESS P2;
		
END ARCHITECTURE MyCPURegister;		