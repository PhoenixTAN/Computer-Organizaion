--Controller Unit
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Controller IS 
	PORT(
		CLK: IN STD_LOGIC;
		Reboot: BUFFER STD_LOGIC;	
		
		--IO interface
		CBIN: IN STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		
		--CPURegister control
		DataSource: BUFFER STD_LOGIC;
		RA: BUFFER STD_LOGIC_VECTOR( 1 DOWNTO 0 ); 
		WT: BUFFER STD_LOGIC; 
		RD: BUFFER STD_LOGIC; 
				
		--PC control	
		PCin: BUFFER STD_LOGIC;
		PCADC: BUFFER STD_LOGIC;
		PCSUB: BUFFER STD_LOGIC;
		PCRST: BUFFER STD_LOGIC;
		
		--IR control
		IRin: BUFFER STD_LOGIC;
		
		--ALU control
		ALUControl: BUFFER STD_LOGIC_VECTOR( 2 DOWNTO 0 );
		ALUCin: BUFFER STD_LOGIC;
		ALUWT: BUFFER STD_LOGIC;
		ALUSEL: BUFFER STD_LOGIC;
		
		--Memory Control
		ROMRead_Write: BUFFER STD_LOGIC;
		IRDATA: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 );	
		PSWDATA: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 );	

		--IO interface
		LEDDATAIN: IN STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		LEDDATAOUT: BUFFER STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		
		--Status of State Machine
		LEDSTATE: OUT STD_LOGIC_VECTOR( 3 DOWNTO 0 )
		
	);
END ENTITY Controller;

ARCHITECTURE MyController OF Controller IS
	SIGNAL delay: STD_LOGIC_VECTOR( 10 DOWNTO 0 );
	SHARED VARIABLE IR: STD_LOGIC_VECTOR( 15 DOWNTO 0 );
BEGIN
	
	LEDDATAOUT <= LEDDATAOUT;
	
	P2: PROCESS(CLK,CBIN(4)) --FINITE STATE MACHINE
	VARIABLE STATE: INTEGER := 0;
	BEGIN
		IF CBIN(4) = '0' THEN
			Reboot <= '0'; --CPU Registers return to 0.
			
			--Control signals return to 0.
			RA <= "00";
			WT <= '0';
			RD <= '0';
			PCin <= '1';
			PCADC <= '1';
			PCSUB <= '1';
			PCRST <= '1';		
			IRin <= '1';	
			ALUControl <= "000";
			ALUCin <= '0';
			ALUWT <= '0';
			ALUSEL <= '0';
		ELSE
			NULL;
		END IF;
		
		IF  CLK = '1' THEN --AND S5 = '0'
			IRin <= '1';
			PCin <= '1';
			PCADC <= '1';
			PCSUB <= '1';
			PCRST <= '1';
			RD <= '0';
			WT <= '0';
			
--			IF S4 = '0' THEN
--				delay <= delay + 1;
--			END IF;
			IR := IRDATA;
			CASE STATE IS
				WHEN 0 => --Get the Instruction
					
					ROMRead_Write <= '0'; --Read Signal
					IRin <= '0';
					--IF delay = "0" THEN																		
						STATE := STATE + 1;
					--END IF;
					LEDSTATE <= "1000";										
										
				WHEN 1 =>  --Get the Operand and analysize the Instruction
					CASE IR( 15 DOWNTO 12 ) IS
						WHEN "0000" => NULL;
						WHEN "0001" => -- Load Data: R0 <- Immediate number
							RA <= IR( 1 DOWNTO 0 );
							DataSource <= '1';
							RD <= '1';
							WT <= '0';
														
						--WHEN "0010" =>
						WHEN "0111" => --XOR
							RA <= IR( 11 DOWNTO 10 );
							ALUSEL <= '0';
							WT <= '1';
							RD <= '0';							
							ALUWT <= '1';
														
							RA <= IR( 9 DOWNTO 8 );
							ALUSEL <= '1';
														
						WHEN "1000" => --Shr
						
						WHEN OTHERS => NULL;
						
					END CASE;
					STATE := STATE + 1;
					LEDSTATE <= "0100";	
				WHEN 2 =>   --Execute the Instruction
					CASE IR( 15 DOWNTO 12 ) IS
						WHEN "0000" => NULL;
						WHEN "0001" => NULL; -- Load Data: R0 <- Immediate number							
						--WHEN "0010" =>
						WHEN "0111" => --XOR
							ALUControl <= "011";
							ALUWT <= '0';
							DataSource <= '0';
							RA <= IR( 7 DOWNTO 6 );
							RD <= '1';
							WT <= '0';
							
						WHEN "1000" => --Shr
						
						WHEN OTHERS => NULL;
						
					END CASE;
					STATE := STATE + 1;
					LEDSTATE <= "0010";	
				WHEN 3 =>--Display the LED7s
					PCADC <= '0';
					STATE := 0; 
					LEDSTATE <= "0001";	
								
				WHEN OTHERS => NULL;
			END CASE;
	
		END IF;	
	END PROCESS P2;
	
END ARCHITECTURE MyController;