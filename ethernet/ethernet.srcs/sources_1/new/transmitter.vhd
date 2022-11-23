---------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2022 12:02:44
-- Design Name: 
-- Module Name: transmitter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;


entity ethernet_transmitter is
    Generic (
        SFD : std_logic_vector (7 downto 0) := "10101011";
        EFD : std_logic_vector (7 downto 0) := "01010100";
        NOADDRI : std_logic_vector (47 downto 0) := X"0a0b0c0a0b0c");

    Port (CLK10I, RESETN : in std_logic;

          TABORTP, TAVAILP, TFINISHP, TLASTP, TSOCOLP, TSMCOLP, TSECOLP : in std_logic;
          TDONEP, TREADDP, TRNSMTP, TSTARTP, COLLISION_HAPPENING : out std_logic;

          TDATAI : in std_logic_vector (7 downto 0);
          TDATAO : out std_logic_vector (7 downto 0));
end ethernet_transmitter;

architecture Behavioral of ethernet_transmitter is
    signal CLK10I_8 : std_logic_vector (2 downto 0) := (others => '0');  
    signal Compteur_6 : std_logic_vector (2 downto 0) := (others => '0');  
    signal Compteur_4 : std_logic_vector (1 downto 0) := (others => '0');  
    signal Index : std_logic_vector (7 downto 0) := (others => '0');

    signal Trans_Required : std_logic := '0';
    signal Abort_Required : std_logic := '0';
    signal SFD_Done : std_logic := '0';
    signal Dest_Done : std_logic := '0';
    signal Source_Done : std_logic := '0';
    signal Trans_Done : std_logic := '0';
begin
    process (CLK10I) 
        begin
            if (rising_edge(CLK10I)) then 
                TREADDP <= '0';
                TDONEP <= '0';
                TSTARTP <= '0';
                
                if (RESETN = '0') then              -- Réinitialisation totale
                    CLK10I_8 <= (others => '0');
                    Compteur_6 <= (others => '0');
                    Compteur_4 <= (others => '0');
                    
                    TDATAO <= (others => '0');
                    TRNSMTP <= '0';
                    
                    Trans_required <= '0';
                    Abort_required <= '0';
                    SFD_Done <= '0';
                    Dest_Done <= '0';
                    Source_Done <= '0';
                    Trans_Done <= '0';
                else 
                    if (Trans_Required = '1' or TAVAILP = '1') then 
                        if (Trans_Required = '0') then 
                            Trans_Required <= '1';
                        end if; 
                        
                        if (Abort_Required = '1' or TABORTP = '1' or TSOCOLP = '1') then
                            if (Abort_Required = '0') then 
                                Abort_Required <= '1';
                            end if;
                            
                            if (CLK10I_8 = "000") then          -- à l'octet
                                COLLISION_HAPPENING <= '1';
                                TDATAO <= "10101010";
                                TRNSMTP <= '0';
                                if (Compteur_4 < "11") then
                                    Compteur_4 <= Compteur_4 + 1;
                                else
                                    Compteur_4 <= "00";
                                    COLLISION_HAPPENING <= '0';
                                    TDONEP <= '1';
                                    SFD_Done <= '0';                              
                                    Dest_Done <= '0';                              
                                    Source_Done <= '0';   
                                    Trans_Done <= '0';
                                    Trans_Required <= '0';    
                                    Abort_Required <= '0';
                                end if;
                            
                            CLK10I_8 <= CLK10I_8 + 1;
                                
                            else
                                if (CLK10I_8 = "111") then
                                    CLK10I_8 <= "000";
                                else
                                    CLK10I_8 <= CLK10I_8 + 1;
                                end if;
                            end if;
                        
                    
                        else
                            if (Trans_Done = '1') then 
                              TDONEP <= '1';           
                              TRNSMTP <= '0';          
                              SFD_Done <= '0';                              
                              Dest_Done <= '0';                              
                              Source_Done <= '0';   
                              Trans_Done <= '0';  
                              Trans_Required  <= '0'; 
                            else
                                TRNSMTP <= '1';
                                if (CLK10I_8 = "000") then 
                                    if (SFD_Done = '0') then
                                        TSTARTP <= '1';
                                        TDATAO <= SFD;
                                        SFD_Done <= '1';
                                    
                                    elsif (Dest_Done = '0') then
                                        TDATAO <= TDATAI; 
                                        TREADDP <= '1';
                                        if (Compteur_6 = "101") then
                                            Compteur_6 <= "000"; 
                                            Dest_Done <= '1';
                                        else 
                                            Compteur_6 <= Compteur_6 + 1; 
                                        end if;
                                        
                                    elsif (Source_Done = '0') then
                                    --  NOADDRI(8*Index + 7 downto 8*Index)
                                        TDATAO <= NOADDRI(to_integer(shift_left(unsigned(Index), 3)) + 7 downto to_integer(shift_left(unsigned(Index), 3)));                                
                                        if (Compteur_6 = "101") then 
                                            Compteur_6 <= "000";
                                            Index <= (others => '0');
                                            Source_Done <= '1';
                                        else
                                            Compteur_6 <= Compteur_6 + 1;
                                            Index <= Index + 1;
                                        end if;
                                                                    
                                    else -- Envoi de DATA jusqu'a TFINISHP
                                        if (TFINISHP = '0') then 
                                            TDATAO <= TDATAI;
                                            TREADDP <= '1';
                                        else
                                            TDATAO <= EFD;
                                            Trans_Done <= '1';
                                        end if;
                                    end if;     
                                    CLK10I_8 <= CLK10I_8 + 1;
                                else
                                    if (CLK10I_8 = "111") then
                                        CLK10I_8 <= "000";
                                    else
                                        CLK10I_8 <= CLK10I_8 + 1;
                                    end if;
                                end if;
                                
                                
                                
                            end if;
                        end if;
                    end if;
                end if;
            end if;
    end process; 
end Behavioral;
