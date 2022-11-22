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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ethernet_collision is
    Port (CLK10I, RESETN : in std_logic;
    
          TRNSMTP, RCVNGP, TDONEP, TABORTP: in std_logic;
          TSOCOLP, TSMCOLP, TSECOLP : out std_logic);
end ethernet_collision;

architecture Behavioral of ethernet_collision is
    signal Collision_Nmb : std_logic_vector (3 downto 0) := (others => '0');
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
                    Collision_Nmb <= Collision_Nmb + 1;
                    if (Collision_Nmb >= "0010") then  -- Multiple failures
                         TSOCOLP <= '0';
                         TSMCOLP <= '1';
                    elsif (Collision_Nmb = "1000") then -- Too many failures, cannot send
                        TSECOLP <= '1';
                        TSOCOLP <= '0';
                        TSMCOLP <= '0';
                        Collision_Nmb <= (others => '0');
                    end if;
                end if;
                if (TDONEP = '1') then
                    Collision_Nmb <= (others => '0');
                end if;    
                if (TABORTP = '1') then
                   TSOCOLP <= '1'; 
                   TSMCOLP <= '1';
                end if;
                                       
            end if;
    end process;

end Behavioral;
