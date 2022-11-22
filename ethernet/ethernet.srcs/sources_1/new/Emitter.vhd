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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ethernet_receiver is
Generic (
        SFD : std_logic_vector (7 downto 0) := "10101011";
        EFD : std_logic_vector (7 downto 0) := "01010100";
        NOADDRI : std_logic_vector (47 downto 0) := X"efefefefefef");

    Port (CLK10I, RESETN : in std_logic;

          RENABP: in std_logic;
          RCLEANP, RCVNGP, RDONEP, RSMATIP, RSTARTIP, RBYTEP : out std_logic;

          RDATAI : in std_logic_vector (7 downto 0);
          RDATAO : out std_logic_vector (7 downto 0));
end ethernet_receiver;

architecture Behavioral of ethernet_receiver is
    signal CLK10I_8 : std_logic_vector (2 downto 0) := (others => '0');  
    signal Compteur_6 : std_logic_vector (2 downto 0) := (others => '0');  
    signal Last_Data_Received : std_logic_vector (7 downto 0) := (others => '0');
    
    signal SFD_Received : std_logic := '0';
    signal ADDR_Dest_Received : std_logic := '0';
    signal ADDR_Source_Received : std_logic := '0';
    
begin
    process (CLK10I) 
        begin
        if (rising_edge(CLK10I)) then
            RBYTEP <= '0';
            RSTARTIP <= '0';
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
                
            else
                if (RENABP = '1') then
                    if (CLK10I_8 = "000") then
                        Last_Data_Received <= RDATAI;
                    
                        if (SFD_Received = '0') then
                            if (RDATAI = SFD) then
                                RSTARTIP <= '1';
                                RCVNGP <= '1';
                                SFD_Received <= '1';
                            end if;  
                                   
                        elsif (ADDR_Dest_Received = '0') then 
                            if (Compteur_6 <= "101") then 
                                -- if (RDATAI = NOADDRI(8*Compteur_6 + 7 downto 8*Compteur_6)
                                if (RDATAI = NOADDRI(to_integer(shift_left(unsigned(Compteur_6), 3)) + 7 downto to_integer(shift_left(unsigned(Compteur_6), 3)))) then
                                    RBYTEP <= '1';
                                else -- Mauvaise addr
                                    RCLEANP <= '1';
                                    RCVNGP <= '0';
                                    SFD_Received <= '0';
                                end if;
                                
                                if (Compteur_6 = "101") then 
                                    Compteur_6 <= "000";
                                    RSMATIP <= '1';
                                    ADDR_Dest_Received <= '1';
                                else
                                    Compteur_6 <= Compteur_6 + 1;
                                end if;
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
                        
                        else -- receive data except if EFD
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
                -- RENABP = 0
                    if (Last_Data_Received /= EFD and SFD_Received = '1') then
                        -- Last frame incomplete
                        RCLEANP <= '1';
                        RSMATIP <= '0';
                        RCVNGP <= '0';
                        
                        Last_Data_Received <= (others => '0');
                        SFD_Received <= '0';
                        ADDR_Dest_Received <= '0';
                        ADDR_Source_Received <= '0';
                    end if;
                end if;        
            end if;
        end if;
    end process;
end Behavioral;