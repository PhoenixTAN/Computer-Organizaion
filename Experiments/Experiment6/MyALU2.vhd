----MyALU2.0
LIBRARY IEEE;
USE IEEE.STD_lOGIC_1164.ALL;
USE IEEE.STD_lOGIC_UNSIGNED.ALL;

ENTITY MyALU2 IS
	PORT(
		CLK: IN STD_LOGIC;
		S: IN STD_LOGIC_VECTOR( 2 DOWNTO 0 );
		Cin: IN STD_LOGIC;
		Data: IN STD_LOGIC_VECTOR( 7 DOWNTO 0 );		
		Sel: IN STD_LOGIC;
		Wt: IN STD_LOGIC;
		Cout: OUT STD_LOGIC;  --Overflow
		F: BUFFER STD_LOGIC_VECTOR( 7 DOWNTO 0 ) --Double Symbol		
	);
END ENTITY MyALU2;

ARCHITECTURE MyALU OF MyALU2 IS 
BEGIN
	
	P1: PROCESS(CLK) --ALU PROCESS		
		VARIABLE A: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		VARIABLE B: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	BEGIN
	IF CLK'EVENT AND CLK = '1' THEN
		IF Wt = '1' THEN 
			CASE Sel IS
				WHEN '0' => A( 7 DOWNTO 0 ) := Data( 7 DOWNTO 0 );
				WHEN '1' => B( 7 DOWNTO 0 ) := Data( 7 DOWNTO 0 );
				WHEN OTHERS => NULL;
			END CASE;
		ELSE --Wt = '0'
			CASE S ( 2 DOWNTO 0 ) IS
				WHEN "000" => F <= "00000000";
				WHEN "001" => F <= A AND B; 
				WHEN "010" => F <= A OR B;
				WHEN "011" => F <= A XOR B;
				WHEN "100" => F <= (A + B) + (Cin); 
								IF A(7) = '0' AND B(7) = '0' AND F(7) = '1' THEN
									Cout <= '1';
								ELSIF A(7) = '1' AND B(7) = '1' AND F(7) = '0' THEN
									Cout <= '1';
								ELSE
									Cout <= '0';
								END IF;
				WHEN "101" => F <= A( 6 DOWNTO 0 ) & "0";
				WHEN "110" => F <= "0" & A( 7 DOWNTO 1 );
				WHEN "111" => IF A(7) = '1' THEN 
									F <= "1" & A( 7 DOWNTO 1 );
							ELSE
									F <= "0" & A( 7 DOWNTO 1 );
							END IF;				
				WHEN OTHERS => NULL;
			END CASE;
		END IF; --Wt
	END IF; -- CLK EVENT END
	END PROCESS P1;
	
END ARCHITECTURE MyALU;
