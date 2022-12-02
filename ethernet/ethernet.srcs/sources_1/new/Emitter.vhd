----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.11.2022 16:34:19
-- Design Name: 
-- Module Name: Emitter - Behavioral
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


entity ethernet_receiver is
Generic (
        SFD : std_logic_vector (7 downto 0) := "10101011";
        EFD : std_logic_vector (7 downto 0) := "01010100";
        NOADDRI : std_logic_vector (47 downto 0) := X"abcdefabcdef");

    Port (CLK10I, RESETN : in std_logic;

          RENABP: in std_logic;
          RCLEANP, RCVNGP, RDONEP, RSMATIP, RSTARTP, RBYTEP : out std_logic;

          RDATAI : in std_logic_vector (7 downto 0);
          RDATAO : out std_logic_vector (7 downto 0));
end ethernet_receiver;

architecture Behavioral of ethernet_receiver is
    signal CLK10I_8 : std_logic_vector (2 downto 0) := (others => '0');  
    signal Compteur_6 : std_logic_vector (2 downto 0) := (others => '0');
    signal Index : std_logic_vector (7 downto 0) := "00000000";    
    signal Last_Data_Received : std_logic_vector (7 downto 0) := (others => '0');
    
    signal SFD_Received : std_logic := '0';
    signal ADDR_Dest_Received : std_logic := '0';
    signal ADDR_Source_Received : std_logic := '0';
    
begin
    process (CLK10I) 
        begin
        if (rising_edge(CLK10I)) then
            RBYTEP <= '0';
            RSTARTP <= '0';
            RCLEANP <= '0';
            RDONEP <= '0';
    
            if (RESETN = '0') then
                RCLEANP <= '1';
                RSMATIP <= '0';
                RCVNGP <= '0';
                                
                Last_Data_Received <= (others => '0');
                SFD_Received <= '0';
                ADDR_Dest_Received <= '0';
                ADDR_Source_Received <= '0';
                Index <= (others => '0');
                CLK10I_8 <= (others => '0');
                Compteur_6 <= (others => '0');
                
            else
                if (RENABP = '1') then
                    if (CLK10I_8 = "000") then
                        Last_Data_Received <= RDATAI;
                    
                        if (SFD_Received = '0') then
                            if (RDATAI = SFD) then
                                RSTARTP <= '1';
                                RCVNGP <= '1';
                                SFD_Received <= '1';
                            end if;  
                                   
                        elsif (ADDR_Dest_Received = '0') then 
                            -- if (RDATAI = NOADDRI(8*Index + 7 downto 8*Index)
                            if (RDATAI = NOADDRI(to_integer(shift_left(unsigned(Index), 3)) + 7 downto to_integer(shift_left(unsigned(Index), 3)))) then
                                RBYTEP <= '1';
                                Index <= Index + 1;
                            else -- No address match
                                RCLEANP <= '1';
                                RCVNGP <= '0';
                                SFD_Received <= '0';
                                Index <= (others => '0');
                            end if;
                                
                            if (Compteur_6 = "101") then 
                                Compteur_6 <= "000";
                                Index <= (others => '0');
                                RSMATIP <= '1';
                                ADDR_Dest_Received <= '1';
                            else
                                Compteur_6 <= Compteur_6 + 1;
                            end if;
                            
                        elsif (ADDR_Source_Received = '0') then
                            if (Compteur_6 <= "101") then
                                RBYTEP <= '1';
                                if (Compteur_6 = "101") then
                                    ADDR_Source_Received <= '1';
                                    Compteur_6 <= "000";
                                else
                                    Compteur_6 <= Compteur_6 + 1;
                                end if;
                            end if;
                        
                        else -- Receive data until EFD
                            RBYTEP <= '1'; 
                            if (RDATAI = EFD) then
                                RDONEP <= '1';
                                RSMATIP <= '0';
                                RCVNGP <= '0';
                                SFD_Received <= '0';
                                ADDR_Dest_Received <= '0';
                                ADDR_Source_Received <= '0';
                            else
                                RDATAO <= RDATAI; 
                            end if;                 
                        end if;
                        
                        CLK10I_8 <= CLK10I_8 + 1;
                    else
                        if (CLK10I_8 = "111") then
                            CLK10I_8 <= "000";
                        end if;
                        CLK10I_8 <= CLK10I_8 + 1;
                    end if;
                else
                    if (Last_Data_Received /= EFD and SFD_Received = '1') then
                        -- If last frame was incomplete
                        RCLEANP <= '1';
                        RSMATIP <= '0';
                        RCVNGP <= '0';
                        
                        Last_Data_Received <= (others => '0');
                        SFD_Received <= '0';
                        ADDR_Dest_Received <= '0';
                        ADDR_Source_Received <= '0';
                        Index <= (others => '0');
                        CLK10I_8 <= (others => '0');
                        Compteur_6 <= (others => '0');
                    end if;
                end if;        
            end if;
        end if;
    end process;
end Behavioral;
