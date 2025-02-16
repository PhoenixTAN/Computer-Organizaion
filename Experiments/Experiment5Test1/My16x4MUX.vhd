LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY My16x4MUX IS
 PORT(
		SEL1: IN STD_LOGIC_VECTOR( 2 DOWNTO 0 );
		input: IN STD_LOGIC_VECTOR( 15 DOWNTO 0 );
		S: OUT STD_LOGIC_VECTOR( 3 DOWNTO 0 )
		);
END ENTITY My16x4MUX;

ARCHITECTURE TEST OF My16x4MUX IS
	
BEGIN
	PROCESS(SEL1)
	BEGIN
		CASE SEL1( 2 DOWNTO 0 ) IS
			WHEN "000" => S <= input( 3 DOWNTO 0 );
			WHEN "001" => S <= input( 7 DOWNTO 4 );
			WHEN "010" => S <= input( 11 DOWNTO 8 );
			WHEN "011" => S <= input( 15 DOWNTO 12 );
			WHEN OTHERS => S <= "0000";
	END CASE;

	END PROCESS;
		
END ARCHITECTURE TEST;