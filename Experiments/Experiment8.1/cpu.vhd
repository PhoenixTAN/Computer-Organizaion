LIBRARY IEEE;  
USE IEEE.STD_LOGIC_1164.ALL;  
USE IEEE.STD_LOGIC_UNSIGNED.ALL;  
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY CPU IS  
    PORT ( 
		   CLK,WE,WR:IN STD_LOGIC;           
           RA:IN STD_LOGIC_VECTOR(1 DOWNTO 0);  
           DATA:IN STD_LOGIC_VECTOR(3 DOWNTO 0);  
           IR:IN STD_LOGIC_VECTOR(15 DOWNTO 0);
           HLinput: IN STD_LOGIC;   
           PC:BUFFER STD_LOGIC_VECTOR(2 DOWNTO 0);  
           SEL:BUFFER STD_LOGIC_VECTOR(2 DOWNTO 0);  
           SEG:BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0)  
          );
END ENTITY CPU;
  
ARCHITECTURE MyCPU OF CPU IS  
    
	SHARED VARIABLE R1,R2,R3,R4:STD_LOGIC_VECTOR(7 DOWNTO 0);         
    SIGNAL CLK2:STD_LOGIC;  
    
    BEGIN  
        PROCESS(CLK2)
        VARIABLE OP:STD_LOGIC_VECTOR(3 DOWNTO 0);
        VARIABLE CX,CY,CZ:STD_LOGIC_VECTOR(7 DOWNTO 0);
        VARIABLE RX,RY,RZ:STD_LOGIC_VECTOR(1 DOWNTO 0); 
        VARIABLE STATE:INTEGER RANGE 0 TO 2; 
        BEGIN  
            IF CLK2'EVENT AND CLK2='0' THEN  
                IF WR='0' THEN  
                    
                    CASE RA(1 DOWNTO 0) IS  --RA
                        WHEN "00" => 
							IF HLinput = '0' THEN
								R1( 3 DOWNTO 0 ):= data; 
							ELSE
								R1( 7 DOWNTO 4 ) := data;
							END IF;
							
                        WHEN "01" => 
							IF HLinput = '0' THEN
								R2( 3 DOWNTO 0 ):= data; 
							ELSE
								R2( 7 DOWNTO 4 ) := data;
							END IF;
                        WHEN "10" => 
							IF HLinput = '0' THEN
								R3( 3 DOWNTO 0 ):= data; 
							ELSE
								R3( 7 DOWNTO 4 ) := data;
							END IF;
                        WHEN "11" => 
							IF HLinput = '0' THEN
								R4( 3 DOWNTO 0 ):= data; 
							ELSE
								R4( 7 DOWNTO 4 ) := data;
							END IF;
                        WHEN OTHERS => NULL;  
                    END CASE; 
                     
                ELSE  --WR = '1'
                    IF STATE=0 THEN  
                        IF WE='0' THEN   
                            PC<="000";  
                        ELSE  -- WE = '1' TO CONTINUE
                            IF PC = "111" THEN  
                                STATE:=0;  
                            ELSE --PC != "111"  WE = '1' WR ='1'
                                PC<=PC+1; 
                                STATE:=1;  
                            END IF;  
                        END IF;  
                    END IF; --state0  
                    
                    IF STATE=1 THEN  
                        OP:=IR(15 DOWNTO 12);  
                        RX:=IR(11 DOWNTO 10);  
                        RY:=IR(9 DOWNTO 8);  
                        RZ:=IR(7 DOWNTO 6);  
                        
                        CASE RX(1 DOWNTO 0) IS  
                            WHEN "00" => CX:=R1;  
                            WHEN "01" => CX:=R2;  
                            WHEN "10" => CX:=R3;  
                            WHEN "11" => CX:=R4;  
                            WHEN OTHERS => NULL;  
                        END CASE;  
                        
                        CASE RY(1 DOWNTO 0) IS  
                            WHEN "00" => CY:=R1;  
                            WHEN "01" => CY:=R2;  
                            WHEN "10" => CY:=R3;  
                            WHEN "11" => CY:=R4;  
                            WHEN OTHERS => NULL;  
                        END CASE;  
                       
                         CASE RZ(1 DOWNTO 0) IS  
                            WHEN "00" => CZ:=R1;  
                            WHEN "01" => CZ:=R2;  
                            WHEN "10" => CZ:=R3;  
                            WHEN "11" => CZ:=R4;  
                            WHEN OTHERS => NULL;  
                        END CASE;  
                        
                        STATE:=2;  
                    END IF; --state1
                     
                    IF STATE=2 THEN  
                        IF OP="0111" THEN  
                            CZ:=CX XOR CY;                           
                        
                        CASE RX(1 DOWNTO 0) IS  
                            WHEN "00" => R1:=CX;  
                            WHEN "01" => R2:=CX;  
                            WHEN "10" => R3:=CX;  
                            WHEN "11" => R4:=CX;  
                            WHEN OTHERS => NULL;  
                        END CASE;  
                        CASE RY(1 DOWNTO 0) IS  
                            WHEN "00" => R1:=CY;  
                            WHEN "01" => R2:=CY;  
                            WHEN "10" => R3:=CY;  
                            WHEN "11" => R4:=CY;  
                            WHEN OTHERS => NULL;  
                        END CASE;  
                        CASE RZ(1 DOWNTO 0) IS  
                            WHEN "00" => R1:=CZ;  
                            WHEN "01" => R2:=CZ;  
                            WHEN "10" => R3:=CZ;  
                            WHEN "11" => R4:=CZ;  
                            WHEN OTHERS => NULL;  
                        END CASE;  
 
                        ELSIF OP="1000" THEN  
                            CY:='0' & CX(7 DOWNTO 1); 
                            
                            CASE RX(1 DOWNTO 0) IS  
                            WHEN "00" => R1:=CX;  
                            WHEN "01" => R2:=CX;  
                            WHEN "10" => R3:=CX;  
                            WHEN "11" => R4:=CX;  
                            WHEN OTHERS => NULL;  
                        END CASE;  
                        CASE RY(1 DOWNTO 0) IS  
                            WHEN "00" => R1:=CY;  
                            WHEN "01" => R2:=CY;  
                            WHEN "10" => R3:=CY;  
                            WHEN "11" => R4:=CY;  
                            WHEN OTHERS => NULL;  
                        END CASE;  
                        CASE RZ(1 DOWNTO 0) IS  
                            WHEN "00" => R1:=CZ;  
                            WHEN "01" => R2:=CZ;  
                            WHEN "10" => R3:=CZ;  
                            WHEN "11" => R4:=CZ;  
                            WHEN OTHERS => NULL;  
                        END CASE;  
                        END IF;  
                                              
                        STATE:=0;                       
                    END IF; --state2
                      
                END IF;       
            END IF;  
        END PROCESS;  
        
        PROCESS(CLK) --LED 
        VARIABLE TIMES:STD_LOGIC_VECTOR(1 DOWNTO 0); -- 11 downto 0 
        VARIABLE X:STD_LOGIC_VECTOR(4 DOWNTO 0);    
        BEGIN  
            IF CLK'EVENT AND CLK='1' THEN  
                TIMES := TIMES+1;  
                
                IF TIMES = "0" THEN   
                    CLK2 <= NOT(CLK2);  --delay times 11 downto 0
                END IF;  
                
                SEL <= SEL + 1;  
                CASE SEL( 2 DOWNTO 0 ) IS  
                    WHEN "111" => X:='0'&R1(7 DOWNTO 4);  
                    WHEN "000" => X:='0'&R1(3 DOWNTO 0);  
                    WHEN "001" => X:='0'&R2(7 DOWNTO 4);  
                    WHEN "010" => X:='0'&R2(3 DOWNTO 0);  
                    WHEN "011" => X:='0'&R3(7 DOWNTO 4);  
                    WHEN "100" => X:='0'&R3(3 DOWNTO 0);  
                    WHEN "101" => X:='0'&R4(7 DOWNTO 4);  
                    WHEN "110" => X:='0'&R4(3 DOWNTO 0);  
                    WHEN OTHERS => NULL;  
                END CASE;
                
                CASE X( 4 DOWNTO 0 ) IS  
                    WHEN "00000" => SEG<="00111111";  
                    WHEN "00001" => SEG<="00000110";  
                    WHEN "00010" => SEG<="01011011";  
                    WHEN "00011" => SEG<="01001111";  
                    WHEN "00100" => SEG<="01100110";  
                    WHEN "00101" => SEG<="01101101";  
                    WHEN "00110" => SEG<="01111101";  
                    WHEN "00111" => SEG<="00000111";  
                    WHEN "01000" => SEG<="01111111";  
                    WHEN "01001" => SEG<="01101111";  
                    WHEN "01010" => SEG<="01110111";  
                    WHEN "01011" => SEG<="01111100";  
                    WHEN "01100" => SEG<="00111001";  
                    WHEN "01101" => SEG<="01011110";  
                    WHEN "01110" => SEG<="01111001";  
                    WHEN "01111" => SEG<="01110001";  
                    WHEN OTHERS  => SEG<="00000000";  
                END CASE; 
                 
            END IF;  
        END PROCESS;  
END ARCHITECTURE MyCPU;  