----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.11.2022 11:14:23
-- Design Name: 
-- Module Name: ethernet_collision - Behavioral
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

entity ethernet_collision is
    Port (CLK10I, RESETN : in std_logic;
    
          TRNSMTP, RCVNGP, TABORTP, TSUCCESS, TFAIL: in std_logic; 
          TSOCOLP, TSMCOLP, TSECOLP : out std_logic);
end ethernet_collision;

architecture Behavioral of ethernet_collision is
    signal Collision_Nmb : std_logic_vector (4 downto 0) := (others => '0');
begin
    process (CLK10I)
        begin
            if (rising_edge(CLK10I)) then
                TSOCOLP <= '0';
                TSMCOLP <= '0';
                TSECOLP <= '0';
                if (RESETN = '0') then
                    Collision_Nmb <= (others => '0');
                    TSECOLP <= '0';
                    TSOCOLP <= '0';
                    TSMCOLP <= '0';
                elsif (TRNSMTP = '1' and RCVNGP = '1') then
                    TSOCOLP <= '1';
                elsif (TFAIL = '1') then
                     Collision_Nmb <= Collision_Nmb + 1;
                     if (Collision_Nmb >= "00001") then  -- Multiple failures
                        TSMCOLP <= '1';
                        if (Collision_Nmb = "01111") then -- Too many failures, cannot send
                            TSECOLP <= '1';
                            Collision_Nmb <= (others => '0');
                       end if;
                    end if;
                end if;
                
                if (TSUCCESS = '1') then -- Reset collision number
                    Collision_Nmb <= (others => '0');
                end if;    
                if (TABORTP = '1') then
                   TSOCOLP <= '1'; 
                   TSMCOLP <= '1';
                end if;
                                       
            end if;
    end process;

end Behavioral;
