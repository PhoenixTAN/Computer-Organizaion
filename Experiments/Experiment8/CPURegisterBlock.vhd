--CPU Register Block
--General Register: R0~R3
--Special Function Register: PC, IR, MDR, MAR
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY CPURegister IS
	PORT(
		--CLK: IN STD_LOGIC;
		Reboot: IN STD_LOGIC; --
		DataSource: IN STD_LOGIC; --'0': come from ACC; '1' come from M_data_in	
		RA: IN STD_LOGIC_VECTOR( 1 DOWNTO 0 ); --	
		Wt: IN STD_LOGIC; --
		Rd: IN STD_LOGIC; --
				
		PCIn: IN STD_LOGIC;
		PCADC: IN STD_LOGIC;
		PCSUB: IN STD_LOGIC;
		PCRST: IN STD_LOGIC; --
		IRIn: IN STD_LOGIC;
		ACC_Data_in: IN STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		Data_TO_ALU: BUFFER STD_LOGIC_VECTOR( 15 DOWNTO 0 );
		M_Data_in: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 ); 
		M_Address: BUFFER STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		M_Data_Out: BUFFER STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		LEDOutput: BUFFER STD_LOGIC_VECTOR( 31 DOWNTO 0 );  --PC; General Register; ROM Instruction; 
		
		IRDATA: BUFFER STD_LOGIC_VECTOR( 15 DOWNTO 0 );	
		PSWDATA: BUFFER STD_LOGIC_VECTOR( 15 DOWNTO 0 )	
		
		--Ready: BUFFER STD_LOGIC --To Controller
		--OutputAddr: BUFFER STD_LOGIC_VECTOR( 7 DOWNTO 0 )
		
		);
END ENTITY CPURegister;

ARCHITECTURE MyCPURegister OF CPURegister IS
	SIGNAL delay: STD_LOGIC_VECTOR( 10 DOWNTO 0 );
	SHARED VARIABLE PC: STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := "00000000";
	SHARED VARIABLE IR: STD_LOGIC_VECTOR( 15 DOWNTO 0 ) := "0000000000000000";
--	SHARED VARIABLE MDR: STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := "00000000";
--	SHARED VARIABLE MAR: STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := "00000000";
	SHARED VARIABLE PSW: STD_LOGIC_VECTOR( 15 DOWNTO 0 ) := "0000000000000000";
	SHARED VARIABLE R0: STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := "00000000";
	SHARED VARIABLE R1: STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := "00000000";
	SHARED VARIABLE R2: STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := "00000000";
	SHARED VARIABLE R3: STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := "00000000";
	
	SHARED VARIABLE P0READY: STD_LOGIC;
	SHARED VARIABLE P1READY: STD_LOGIC;
	SHARED VARIABLE P2READY: STD_LOGIC;
	
BEGIN
		
--	P0: PROCESS(Reboot)
--	BEGIN
--		P0READY := '0';
--		IF Reboot = '0' THEN
--			PC := "00000000";
--			IR := "0000000000000000";
--			R0 := "00000000";
--			R1 := "00000000";
--			R2 := "00000000";
--			R3 := "00000000";
----			MDR := "00000000";
----			MAR := "00000000";			
--		ELSE
--			NULL;
--		END IF;		
--	END PROCESS P0;
		
	P1: PROCESS(Reboot,IRin,PCRST,PCADC,PCSUB) --Reboot, PC, IR	
	BEGIN
		--IF CLK'EVENT AND CLK = '0' THEN 			
			IF Reboot = '0' THEN
			PC := "00000000";
			IR := "0000000000000000";
--			MDR := "00000000";
--			MAR := "00000000";			
			ELSE
				NULL;
			END IF;	
			
			IF PCRST = '0'  THEN
				PC := "00000000";
			ELSIF PCADC = '0' THEN
				PC := PC + 1; 				 					
			ELSIF PCSUB = '0' THEN			
				PC := PC - 1; 													
			END IF;
			
			M_Address <= PC;
			
			IF IRin = '0' THEN
				IR := M_Data_In;
				IRDATA <= IR;
			ELSE
				NULL;
			END IF;	
					
			Data_To_ALU( 15 DOWNTO 8 ) <= PC;
		--END IF; --CLK EVENT
		
	END PROCESS P1;
	
	P2: PROCESS(RA,WT,RD,Reboot) --General Register Block	
	BEGIN
		IF Reboot = '0' THEN
			R0 := "00000000";
			R1 := "00000000";
			R2 := "00000000";
			R3 := "00000000";
--			MDR := "00000000";
--			MAR := "00000000";			
		ELSE
			NULL;
		END IF;	
		
		--IF CLK'EVENT AND CLK = '0' THEN
			--R0-------------------------------------------------
			IF RA = "00" THEN -- Register R0				
				IF Wt = '0' AND Rd = '1' THEN --Write
					IF DATASource = '0' THEN
						R0 := ACC_Data_in;
					ELSE
						R0 := M_Data_in( 11 DOWNTO 4);
					END IF;
				--END IF; --Write
				ELSIF Wt = '1' AND Rd = '0' THEN --Read
					LEDOutput( 31 DOWNTO 24 ) <= R0;
					Data_TO_ALU( 7 DOWNTO 0 ) <= R0;
				ELSE NULL; --Read
				END IF;
				
			END IF; --R0
			-----------------------------------------------------
			
			--R1-------------------------------------------------
			IF RA = "01" THEN -- Register R1
				
				IF Wt = '0' AND Rd = '1' THEN --Write
					IF DATASource = '0' THEN
						R1 := ACC_Data_in;
					ELSE
						R1 := M_Data_in( 11 DOWNTO 4 );
					END IF;	
				--END IF; --Write			
				ELSIF Wt = '1' AND Rd = '0' THEN --Read
					LEDOutput( 23 DOWNTO 16 ) <= R1;
					Data_TO_ALU( 7 DOWNTO 0 ) <= R1;
				ELSE NULL; --Read
				END IF;
				
			END IF; --R1
			-----------------------------------------------------

			--R2-------------------------------------------------
			IF RA = "10" THEN -- Register R2
				
				IF Wt = '0' AND Rd = '1' THEN --Write
					IF DATASource = '0' THEN
						R2 := ACC_Data_in;
					ELSE
						R2 := M_Data_in( 11 DOWNTO 4);
					END IF;			
				--END IF; --Write			
				ELSIF Wt = '1' AND Rd = '0' THEN --Read
					LEDOutput( 15 DOWNTO 8 ) <= R2;
					Data_TO_ALU( 7 DOWNTO 0 ) <= R2;
				ELSE NULL; --Read
				END IF;
				
			END IF; --R2
			-----------------------------------------------------

			--R3-------------------------------------------------
			IF RA = "11" THEN -- Register R3
				
				IF Wt = '0' AND Rd = '1' THEN --Write
					IF DATASource = '0' THEN
						R3 := ACC_Data_in;
					ELSE
						R3 := M_Data_in( 11 DOWNTO 4);
					END IF;			
				--END IF; --Write			
				ELSIF Wt = '1' AND Rd = '0' THEN --Read
					LEDOutput( 7 DOWNTO 0 ) <= R3;
					Data_TO_ALU( 7 DOWNTO 0 ) <= R3;
				ELSE NULL; --Read				
				END IF;
				
			END IF; --R3
			-----------------------------------------------------

		--END IF;	--CLK EVENT
				
	END PROCESS P2;
		
END ARCHITECTURE MyCPURegister;		