----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2022 09:41:25
-- Design Name: 
-- Module Name: Test_Ethernet - Behavioral
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

entity Test_Ethernet is
--  Port ( );
end Test_Ethernet;

architecture Behavioral of Test_Ethernet is

COMPONENT Ethernet_transmitter
PORT( CLK10I, RESETN : in std_logic;

      TSOCOLP, TABORTP, TAVAILP, TFINISHP, TLASTP : in std_logic;
      TDONEP, TREADDP, TRNSMTP, TSTARTP : out std_logic;

      TDATAI : in std_logic_vector (7 downto 0);
      TDATAO : out std_logic_vector (7 downto 0)
      );
        
END COMPONENT;
    signal CLK10I : std_logic := '0';
    signal RESETN : std_logic := '0';
    signal TSOCOLP : std_logic := '0';
    signal TABORTP : std_logic := '0';
    signal TAVAILP : std_logic := '0';
    signal TFINISHP : std_logic := '0';
    signal TLASTP : std_logic := '0';
    
    signal TDATAI : std_logic_vector ( 7 downto 0) := (others => '0');
    
    signal TDATAO : std_logic_vector ( 7 downto 0) := (others => '0');
    
    signal TDONEP : std_logic := '0';
    signal TREADDP : std_logic := '0';
    signal TRNSMTP : std_logic := '0';
    signal TSTARTP : std_logic := '0';

    constant Clock_period : time := 10 ns;
begin


uut: Ethernet_transmitter PORT MAP (
CLK10I => CLK10I,
TSOCOLP => TSOCOLP,
RESETN => RESETN,
TABORTP => TABORTP,
TAVAILP => TAVAILP,
TFINISHP => TFINISHP,
TLASTP => TLASTP,
TDATAI => TDATAI,
TDATAO => TDATAO,
TDONEP => TDONEP,
TREADDP => TREADDP,
TRNSMTP => TRNSMTP,
TSTARTP => TSTARTP
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
RESETN <= '1'; --, '0' after 1000 ns, '1' after 1200 ns;
TDATAI <= "00001000", "00000100" after 1200 ns; 
TAVAILP <= '0', '1' after 50 ns, '0' after 1400 ns;
TFINISHP <= '0', '1' after 1700 ns, '0' after 1985 ns, '1' after 2600 ns;
TABORTP <= '0', '0' after 1400 ns, '0' after 1500 ns;

wait;
end process;

end Behavioral;
