LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY multiplicationALU_1bit_true_format IS
  PORT(
		CLK: IN STD_LOGIC;		
		BC: IN STD_LOGIC;
		input: IN STD_LOGIC_VECTOR( 8 DOWNTO 0 );
		Qs: BUFFER STD_LOGIC;
		TEST: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 )
		);
END ENTITY multiplicationALU_1bit_true_format;

ARCHITECTURE experiment3 OF multiplicationALU_1bit_true_format IS
	
BEGIN
		
	P1:PROCESS(CLK)
		VARIABLE Bs, Cs: STD_LOGIC;
		VARIABLE B: STD_LOGIC_VECTOR( 9 DOWNTO 0 ); --X 00.12345678
		VARIABLE C: STD_LOGIC_VECTOR( 7 DOWNTO 0 ); --Y   .12345678
		VARIABLE A: STD_LOGIC_VECTOR( 9 DOWNTO 0 ); --A 00.12345678
	BEGIN
	IF CLK'EVENT AND CLK = '1' THEN
		
			IF BC = '0' THEN -- Register B
				B( 7 DOWNTO 0 ) := input( 7 DOWNTO 0 );
				Bs := input(8);
				b(8) := '0';
				b(9) := '0';
			ELSIF BC = '1' THEN -- Register C
				C := input( 7 DOWNTO 0 );
				Cs := input(8);
			END IF;		
			Qs <= Bs Xor Cs;
		
			FOR N IN 1 TO 8 LOOP
				IF C(0) = '1' THEN
					A := A + B;
				END IF;		
				C := A(0) & C( 7 DOWNTO 1 ); --C MOVE RIGHT
				A := '0' & A( 9 DOWNTO 1 );	 --A MOVE RIGHT
			END LOOP;
		
			TEST <= A( 7 DOWNTO 0 ) & C;
			A := "0000000000"; --CLR A	
			
		END IF; --CLK EVENT END
	END PROCESS P1;

END ARCHITECTURE experiment3;