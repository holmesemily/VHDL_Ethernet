----------------------------------------------------------------------------------
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
        NOADDRI1 : std_logic_vector (7 downto 0) := "11001100";
        NOADDRI2 : std_logic_vector (7 downto 0) := "11001101";
        NOADDRI3 : std_logic_vector (7 downto 0) := "01001100";
        NOADDRI4 : std_logic_vector (7 downto 0) := "01001101";
        NOADDRI5 : std_logic_vector (7 downto 0) := "00001100";
        NOADDRI6 : std_logic_vector (7 downto 0) := "00101111");

    Port (CLK10I, RESETN : in std_logic;

          TABORTP, TAVAILP, TFINISHP, TLASTP : in std_logic;
          TDONEP, TREADDP, TRNSMTP, TSTARTP : out std_logic;

          TDATAI : in std_logic_vector (7 downto 0);
          TDATAO : out std_logic_vector (7 downto 0));
end ethernet_transmitter;

architecture Behavioral of ethernet_transmitter is
    signal CLK10I_8 : std_logic_vector (2 downto 0) := (others => '0');  
    signal CURRENT_DATA : std_logic_vector (7 downto 0);
    signal Compteur_6 : std_logic_vector (2 downto 0) := (others => '0');  

    signal Trans_Required : std_logic := '0';
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
                if (RESETN = '0') then
                    -- routine de reset
                    null;
                else 
                    if (TABORTP = '1') then
                        -- envoyer 32 bits de padding sur TDATAO, envoyer TDONEP, baisser TRNSMTP
                    
                    elsif (TAVAILP = '1') then
                        TRNSMTP <= '1';
                        if (CLK10I_8 = "000") then 
                            if (SFD_Done = '0') then
                                TSTARTP <= '1';
                                TDATAO <= SFD;
                                SFD_Done <= '1';
                               
                            elsif (Dest_Done = '0') then
                                if (Compteur_6 < "101") then
                                    TDATAO <= TDATAI; 
                                    TREADDP <= '1';
                                    Compteur_6 <= Compteur_6 + 1; 
                                else 
                                    TDATAO <= TDATAI; 
                                    TREADDP <= '1';
                                    Dest_Done <= '1';
                                    Compteur_6 <= "000";
                                end if;
                                
                           elsif (Source_Done = '0') then
                              if (Compteur_6 = "000") then 
                              TDATAO <= NOADDRI1; 
                              Compteur_6 <= Compteur_6 + 1;
                              elsif (Compteur_6 = "001") then
                              TDATAO <= NOADDRI2; 
                              Compteur_6 <= Compteur_6 + 1;                              
                              elsif (Compteur_6 = "010") then
                              TDATAO <= NOADDRI3; 
                              Compteur_6 <= Compteur_6 + 1;                              
                              elsif (Compteur_6 = "011") then
                              TDATAO <= NOADDRI4; 
                              Compteur_6 <= Compteur_6 + 1;                             
                              elsif (Compteur_6 = "100") then
                              TDATAO <= NOADDRI5; 
                              Compteur_6 <= Compteur_6 + 1;                              
                              elsif (Compteur_6 = "101") then
                              TDATAO <= NOADDRI6; 
                              Compteur_6 <= "000";
                              Source_Done <= '1'; 
                              end if;
                                                              
                           else -- Envoi de DATA jusqu'a TFINISHP
                              if (TFINISHP = '0') then
                                TDATAO <= TDATAI;
                                TREADDP <= '1';
                              else
                                if (Trans_Done = '0') then
                                    TDATAO <= EFD;
                                    Trans_Done <= '1';
                                else 
                                    TDATAO <= (others => '0');
                                    TRNSMTP <= '0';
                                    TDONEP <= '1';
                                                                 
                                    SFD_Done <= '0';                              
                                    Dest_Done <= '0';                              
                                    Source_Done <= '0';   
                                    Trans_Done <= '0';   
                                end if;
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
    end process; 
end Behavioral;




----------------------------------------------------------------------------------
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
        NOADDRI1 : std_logic_vector (7 downto 0) := "11001100";
        NOADDRI2 : std_logic_vector (7 downto 0) := "11001101";
        NOADDRI3 : std_logic_vector (7 downto 0) := "01001100";
        NOADDRI4 : std_logic_vector (7 downto 0) := "01001101";
        NOADDRI5 : std_logic_vector (7 downto 0) := "00001100";
        NOADDRI6 : std_logic_vector (7 downto 0) := "00101111");

    Port (CLK10I, RESETN : in std_logic;

          TABORTP, TAVAILP, TFINISHP, TLASTP : in std_logic;
          TDONEP, TREADDP, TRNSMTP, TSTARTP : out std_logic;

          TDATAI : in std_logic_vector (7 downto 0);
          TDATAO : out std_logic_vector (7 downto 0));
end ethernet_transmitter;

architecture Behavioral of ethernet_transmitter is
    signal CLK10I_8 : std_logic_vector (2 downto 0) := (others => '0');  
    signal CURRENT_DATA : std_logic_vector (7 downto 0);
    signal Compteur_6 : std_logic_vector (2 downto 0) := (others => '0');  

    signal Trans_Required : std_logic := '0';
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
                if (RESETN = '0') then
                    -- routine de reset
                    null;
                else 
                    if (Trans_Required = '0') then 
                        if (TAVAILP = '1') then 
                            Trans_Required <= '1';
                        end if; 
                    elsif (Trans_Required = '1' or TAVAILP = '1') then -- CEST PAS BEAU CA 
                        
                        if (TABORTP = '1') then
                        -- envoyer 32 bits de padding sur TDATAO, envoyer TDONEP, baisser TRNSMTP
                    
                        else
                            if (TFINISHP = '1') then
                                if (Trans_Done = '0') then
                                    TDATAO <= EFD;
                                    Trans_Done <= '1';
                                    TDONEP <= '1';
                                else 
                                    TDATAO <= (others => '0');
                                    TRNSMTP <= '0';          
                                    SFD_Done <= '0';                              
                                    Dest_Done <= '0';                              
                                    Source_Done <= '0';   
                                    Trans_Done <= '0';   
                                end if;
                            else
                                TRNSMTP <= '1';
                                if (CLK10I_8 = "000") then 
                                    if (SFD_Done = '0') then
                                        TSTARTP <= '1';
                                        TDATAO <= SFD;
                                        SFD_Done <= '1';
                                    
                                    elsif (Dest_Done = '0') then
                                        if (Compteur_6 < "101") then
                                            TDATAO <= TDATAI; 
                                            TREADDP <= '1';
                                            Compteur_6 <= Compteur_6 + 1; 
                                        else 
                                            TDATAO <= TDATAI; 
                                            TREADDP <= '1';
                                            Dest_Done <= '1';
                                            Compteur_6 <= "000";
                                        end if;
                                        
                                    elsif (Source_Done = '0') then
                                    if (Compteur_6 = "000") then 
                                    TDATAO <= NOADDRI1; 
                                    Compteur_6 <= Compteur_6 + 1;
                                    elsif (Compteur_6 = "001") then
                                    TDATAO <= NOADDRI2; 
                                    Compteur_6 <= Compteur_6 + 1;                              
                                    elsif (Compteur_6 = "010") then
                                    TDATAO <= NOADDRI3; 
                                    Compteur_6 <= Compteur_6 + 1;                              
                                    elsif (Compteur_6 = "011") then
                                    TDATAO <= NOADDRI4; 
                                    Compteur_6 <= Compteur_6 + 1;                             
                                    elsif (Compteur_6 = "100") then
                                    TDATAO <= NOADDRI5; 
                                    Compteur_6 <= Compteur_6 + 1;                              
                                    elsif (Compteur_6 = "101") then
                                    TDATAO <= NOADDRI6; 
                                    Compteur_6 <= "000";
                                    Source_Done <= '1'; 
                                    end if;
                                                                    
                                    else -- Envoi de DATA jusqu'a TFINISHP
                                        TDATAO <= TDATAI;
                                        TREADDP <= '1';
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


