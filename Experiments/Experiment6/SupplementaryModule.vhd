--supplementary module
LIBRARY IEEE;
LIBRARY IEEE;
USE IEEE.STD_lOGIC_1164.ALL;

ENTITY SupplementaryModule IS 
	PORT(
		CLK: IN STD_LOGIC;
		K1: IN STD_LOGIC; --S2 RA1
		K2: IN STD_LOGIC; --S1 RA0
		K3: IN STD_LOGIC; --S0 WT
		K4: IN STD_LOGIC; --Cin RD
		K5: IN STD_LOGIC; --Control Signal Select  0: CPURegister; 1: ALU
		K6: IN STD_LOGIC; --Sin 1:Register receives data from external input; 0: Register receives data from ALU output;
		K7: IN STD_LOGIC; --ALU Wt
		K8: IN STD_LOGIC; --HLinput
		K9: IN STD_LOGIC; --Data3
		K10: IN STD_LOGIC; --Data2
		K11: IN STD_LOGIC; --Data1
		K12: IN STD_LOGIC; --Data0
		ALUData: IN STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		ALUS: BUFFER STD_LOGIC_VECTOR( 2 DOWNTO 0 );
		ALUCin: BUFFER STD_LOGIC;
		CPURA: BUFFER STD_LOGIC_VECTOR( 1 DOWNTO 0 );
		CPUWT: BUFFER STD_LOGIC;
		CPURD: BUFFER STD_LOGIC;
		DataToRegister: BUFFER STD_LOGIC_VECTOR( 3 DOWNTO 0 );
		ALUSel: BUFFER STD_LOGIC;
		MUXSout: BUFFER STD_LOGIC	
	);
END ENTITY SupplementaryModule;

ARCHITECTURE KDistribution OF SupplementaryModule IS
BEGIN
	P1: PROCESS(CLK)
	BEGIN
		IF CLK'EVENT AND CLK = '1' THEN
			IF K5 = '1' THEN
				--CPURA <= "00"; --CLEAR
				--CPUWT <= '0'; --CLEAR
				--CPURD <= '0'; --CLEAR
				ALUS <= K1&K2&K3;
				ALUCin <= K4;
			ELSE
				CPURA <= K1&K2; 
				CPUWT <= K3; 
				CPURD <= K4; 
			END IF;			
		END IF;
	
	END PROCESS P1;
	
	P2: PROCESS(CLK)
	BEGIN
		IF CLK'EVENT AND CLK = '1' THEN
			IF K6 = '0' THEN
				ALUSel <= '0';
				MUXSout <= '0';
				CASE K8 IS
					WHEN '0' => DataToRegister <= K9&K10&K11&K12;
					WHEN '1' => DataToRegister <= K9&K10&K11&K12;
					WHEN OTHERS => NULL;
				END CASE;
			ELSE
				ALUSel <= K11;
				MUXSout <= K12;
				CASE K8 IS
					WHEN '0' => DataToRegister <= ALUData( 3 DOWNTO 0 );
					WHEN '1' => DataToRegister <= ALUData( 7 DOWNTO 4 );
					WHEN OTHERS => NULL;
				END CASE;
			END IF;
		END IF;
	END PROCESS P2;

END ARCHITECTURE KDistribution;