----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.11.2022 10:07:02
-- Design Name: 
-- Module Name: test_receiver - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_receiver is
--  Port ( );
end test_receiver;

architecture Behavioral of test_receiver is

COMPONENT ethernet_receiver
PORT( CLK10I, RESETN : in std_logic;

      RENABP : in std_logic;
      RBYTEP, RCLEANP, RCVNGP, RDONEP, RSMATIP, RSTARTP : out std_logic;

      RDATAI : in std_logic_vector (7 downto 0);
      RDATAO : out std_logic_vector (7 downto 0)
      );
        
END COMPONENT;
    signal CLK10I : std_logic := '0';
    signal RESETN : std_logic := '0';
    signal RENABP : std_logic := '0';
    
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


uut: Ethernet_receiver PORT MAP (
CLK10I => CLK10I,
RESETN => RESETN,
RENABP => RENABP,
RBYTEP => RBYTEP,
RCLEANP => RCLEANP,
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
-- Stimulus process
stim_proc: process
begin
-- insert stimulus here

-- addr match, receiver functional
RESETN <= '1';
RENABP <= '0', '1' after 100ns, '0' after 1680ns;
RDATAI <= "00000000" , "10101011" after 100ns, X"ef" after 180ns, X"cd" after 260ns, X"ab" after 340ns, X"ef" after 420ns, X"cd" after 500ns, X"ab" after 580ns, X"cd" after 670ns, "00000000" after 1140ns, "01010100" after 1600ns; 

wait;
end process;

end Behavioral;
