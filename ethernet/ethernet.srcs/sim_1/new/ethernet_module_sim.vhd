----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.11.2022 14:13:48
-- Design Name: 
-- Module Name: ethernet_module_sim - Behavioral
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

entity ethernet_module_sim is
end ethernet_module_sim;

architecture Behavioral of ethernet_module_sim is

component ethernet_module is
    PORT(  CLK10I, RESETN : in std_logic;
           TABORTP, TAVAILP, TFINISHP, TLASTP : in std_logic; 
           RENABP : in std_logic;
           
           RBYTEP, RCLEANP, RCVNGP, RDONEP, RSMATIP, RSTARTP : out std_logic;
           TDONEP, TREADDP, TRNSMTP, TSTARTP : out std_logic;
           
           TSOCOLP, TSMCOLP, TSECOLP : out std_logic; -- à voir?
           
           TDATAI : in std_logic_vector (7 downto 0);
           TDATAO : out std_logic_vector (7 downto 0);
           RDATAI : in std_logic_vector (7 downto 0);
           RDATAO : out std_logic_vector (7 downto 0));
end component;

    signal CLK10I : std_logic := '0';
    signal RESETN : std_logic := '0';
    signal RENABP : std_logic := '0';
    
    signal TABORTP : std_logic := '0';
    signal TAVAILP : std_logic := '0';
    signal TFINISHP : std_logic := '0';
    signal TLASTP : std_logic := '0';
 
    signal TDONEP : std_logic := '0';
    signal TREADDP : std_logic := '0';
    signal TRNSMTP : std_logic := '0';
    signal TSTARTP : std_logic := '0';
    
    signal TSOCOLP : std_logic := '0';
    signal TSMCOLP : std_logic := '0';
    signal TSECOLP : std_logic := '0';
    
    signal TDATAI : std_logic_vector ( 7 downto 0) := (others => '0');
    signal TDATAO : std_logic_vector ( 7 downto 0) := (others => '0');
    signal RDATAI : std_logic_vector ( 7 downto 0) := (others => '0');
    signal RDATAO : std_logic_vector ( 7 downto 0) := (others => '0');

    signal RBYTEP : std_logic := '0';
    signal RCLEANP : std_logic := '0';
    signal RCVNGP : std_logic := '0';
    signal RDONEP : std_logic := '0';
    signal RSMATIP : std_logic := '0';
    signal RSTARTP : std_logic := '0';

constant Clock_period : time := 10 ns;
begin

uut: ethernet_module PORT MAP (
CLK10I => CLK10I,
RESETN => RESETN,

RENABP => RENABP,
RBYTEP => RBYTEP,
RCLEANP => RCLEANP,

TABORTP => TABORTP,
TAVAILP => TAVAILP,
TFINISHP => TFINISHP,
TLASTP => TLASTP,

TDONEP => TDONEP,
TREADDP => TREADDP,
TRNSMTP => TRNSMTP,
TSTARTP => TSTARTP,

TSOCOLP => TSOCOLP,
TSMCOLP => TSMCOLP,
TSECOLP => TSECOLP,

TDATAI => TDATAI,
TDATAO => TDATAO,

RDATAI => RDATAI,
RDATAO => RDATAO,

RCVNGP => RCVNGP,
RDONEP => RDONEP,
RSMATIP => RSMATIP,
RSTARTP => RSTARTP
);

-- Clock process definitions
Clock_process :process
begin
CLK10I <= not(CLK10I);
wait for Clock_period/2;
end process;

stim_proc: process
begin



-- Please comment or uncomment the tests to try them 

-- RECEIVING - ADDR MATCH
RESETN <= '1';
RENABP <= '0', '1' after 100ns, '0' after 1680ns;
RDATAI <= "00000000" , "10101011" after 100ns, X"ef" after 180ns, X"cd" after 260ns, X"ab" after 340ns, X"ef" after 420ns, X"cd" after 500ns, X"ab" after 580ns, X"cd" after 670ns, "00000000" after 1140ns, "01010100" after 1600ns; 
-- END RECEIVING - ADDR MATCH


-- RECEIVING - NO ADDR MATCH
--RESETN <= '1';
--RENABP <= '0', '1' after 100ns, '0' after 1680ns;
--RDATAI <= "00000000" , "10101011" after 100ns, X"ef" after 180ns, X"cd" after 260ns, X"bb" after 340ns; 
-- END RECEIVING - NO ADDR MATCH


-- TRANSMITTING - NO ISSUE
--RESETN <= '1';
--TDATAI <= "00000000", X"ef" after 100 ns, X"cd" after 180 ns, X"ab" after 260 ns, X"ef" after 340 ns, X"cd" after 420 ns, X"ab" after 500 ns; -- "00000100" after 1090 ns; 
--TAVAILP <= '0', '1' after 50 ns, '0' after 100 ns;
--TFINISHP <= '0', '1' after 1300 ns, '0' after 1400ns;
-- END TRANSMITTING - NO ISSUE


-- TRANSMITTING - ABORT
--RESETN <= '1';
--TDATAI <= "00000000", X"ef" after 100 ns, X"cd" after 180 ns, X"ab" after 260 ns, X"ef" after 340 ns, X"cd" after 420 ns, X"ab" after 500 ns; -- "00000100" after 1090 ns; 
--TAVAILP <= '0', '1' after 50 ns, '0' after 100 ns;
--TABORTP <= '0', '1' after 1300ns, '0' after 1400ns;
-- END TRANSMITTING - ABORT


-- TRANSMITTING - RESET
--RESETN <= '1', '0' after 1300ns, '1' after 1400ns;
--TDATAI <= "00000000", X"ef" after 100 ns, X"cd" after 180 ns, X"ab" after 260 ns, X"ef" after 340 ns, X"cd" after 420 ns, X"ab" after 500 ns; -- "00000100" after 1090 ns; 
--TAVAILP <= '0', '1' after 50 ns, '0' after 100 ns;
-- END TRANSMITTING - RESET


-- COLLISION TEST
-- Description: Receiving + Transmitting at the same time. Transmission will send bit padding after each collision
--RESETN <= '1';
--RENABP <= '0', '1' after 100ns, '0' after 1680ns;
--RDATAI <= "00000000" , "10101011" after 100ns, X"ef" after 180ns, X"cd" after 260ns, X"ab" after 340ns, X"ef" after 420ns, X"cd" after 500ns, X"ab" after 580ns, X"cd" after 670ns, "00000000" after 1140ns, "01010100" after 1600ns; 
--TAVAILP <= '0', '1' after 100 ns;
--TDATAI <= X"ab";
-- END COLLISION TEST

wait;
end process;    

end Behavioral;
