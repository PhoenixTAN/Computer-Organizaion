LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY Adder_1 IS
	PORT(Ain,Bin,Cin: IN STD_LOGIC;
		Sum,Cout: out STD_LOGIC);
END Adder_1;

ARCHITECTURE rtl of Adder_1 IS	
	
BEGIN	
	PROCESS(Ain,Bin,Cin)
	VARIABLE S: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	BEGIN	
		S := '0' & Ain + Bin + Cin; --Note: do not add() !!!!
		Sum <= S(0);
		Cout <= S(1);
	END PROCESS;
END rtl;
