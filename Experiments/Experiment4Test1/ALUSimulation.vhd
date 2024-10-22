LIBRARY IEEE;
USE IEEE.STD_lOGIC_1164.ALL;
USE IEEE.STD_lOGIC_UNSIGNED.ALL;

ENTITY ALUSimulation IS
	PORT(
		CLK: IN STD_LOGIC;
		S: IN STD_LOGIC_VECTOR( 2 DOWNTO 0 );
		Cin: IN STD_LOGIC;
		Cout: OUT STD_LOGIC;  --Overflow
		F: BUFFER STD_LOGIC_VECTOR( 8 DOWNTO 0 ); --Double Symbol
		Data: IN STD_LOGIC_VECTOR( 3 DOWNTO 0 );
		Sel: IN STD_LOGIC_VECTOR( 1 DOWNTO 0 );
		Wt: IN STD_LOGIC;
		
		BitSelect: BUFFER STD_LOGIC_VECTOR( 2 DOWNTO 0 );
		LED7S: BUFFER STD_LOGIC_VECTOR( 7 DOWNTO 0 )
	);
END ENTITY ALUSimulation;

ARCHITECTURE MyALU OF ALUSimulation IS 
BEGIN
	
	P1: PROCESS(CLK) --ALU PROCESS		
		VARIABLE A: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		VARIABLE B: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	BEGIN
	IF CLK'EVENT AND CLK = '1' THEN
		IF Wt = '1' THEN 
			CASE Sel ( 1 DOWNTO 0 ) IS
				WHEN "00" => A( 3 DOWNTO 0 ) := Data( 3 DOWNTO 0 );
				WHEN "01" => A( 7 DOWNTO 4 ) := Data( 3 DOWNTO 0 );
				WHEN "10" => B( 3 DOWNTO 0 ) := Data( 3 DOWNTO 0 );
				WHEN "11" => B( 7 DOWNTO 4 ) := Data( 3 DOWNTO 0 );
				WHEN OTHERS => NULL;
			END CASE;
		--END IF;
		ELSE --Wt = '0'
			CASE S ( 2 DOWNTO 0 ) IS
				WHEN "000" => F( 7 DOWNTO 0 ) <= "00000000";
				WHEN "001" => F( 7 DOWNTO 0 ) <= A AND B; 
				WHEN "010" => F( 7 DOWNTO 0 ) <= A OR B;
				WHEN "011" => F( 7 DOWNTO 0 ) <= A XOR B;
				WHEN "100" => F( 8 DOWNTO 0 ) <= (( A(7) & A ) + ( B(7) & B )) + Cin;
												IF( F(8) = '0' AND F(7) = '1' ) THEN -- Positive Overflow
														Cout <= '1';
												ELSIF( F(8) = '1' AND F(7) = '0' ) THEN --Negative Overflow
														Cout <= '1';
												ELSE
														Cout <= '0';
												END IF;
				WHEN "101" => F( 7 DOWNTO 0 ) <= A( 6 DOWNTO 0 ) & "0";
				WHEN "110" => F( 7 DOWNTO 0 ) <= "0" & A( 7 DOWNTO 1 );
				WHEN "111" => IF A(7) = '1' THEN 
									F( 7 DOWNTO 0 ) <= "1" & A( 7 DOWNTO 1 );
							ELSE
									F( 7 DOWNTO 0 ) <= "0" & A( 7 DOWNTO 1 );
							END IF;				
				WHEN OTHERS => NULL;
			END CASE;
		END IF; --Wt
	END IF; -- CLK EVENT END
	END PROCESS P1;
	
	P2: PROCESS(CLK) --7 SEG LEDS PROCESS
	VARIABLE Divider: INTEGER := 0;	
	VARIABLE LEDdata: STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	BEGIN
	IF CLK'EVENT AND CLK = '1' THEN
		IF Divider = 10 THEN
			Divider := 0;
			CASE BitSelect(0) IS
				WHEN '0' => LEDdata := F( 3 DOWNTO 0 ); BitSelect(0) <= '1';
				WHEN '1' => LEDdata := F( 7 DOWNTO 4 ); BitSelect(0) <= '0';
				WHEN OTHERS => NULL;
			END CASE;
			
			CASE LEDdata( 3 DOWNTO 0 ) IS
				WHEN "0000" => LED7S <= x"3F";
				WHEN "0001" => LED7S <= x"06";
				WHEN "0010" => LED7S <= x"5B";
				WHEN "0011" => LED7S <= x"4F";
				WHEN "0100" => LED7S <= x"66";
				WHEN "0101" => LED7S <= x"6D";
				WHEN "0110" => LED7S <= x"7D";
				WHEN "0111" => LED7S <= x"07";
				WHEN "1000" => LED7S <= x"7F";
				WHEN "1001" => LED7S <= x"6F";
				WHEN "1010" => LED7S <= x"77";
				WHEN "1011" => LED7S <= x"7C";
				WHEN "1100" => LED7S <= x"39";
				WHEN "1101" => LED7S <= x"5E";
				WHEN "1110" => LED7S <= x"79";
				WHEN "1111" => LED7S <= x"71";
				WHEN OTHERS => NULL;
			END CASE;
		ELSE
			Divider := Divider + 1;
		END IF;
	
	
	END IF;	
	END PROCESS P2;

END ARCHITECTURE MyALU;