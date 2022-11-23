----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.11.2022 13:20:48
-- Design Name: 
-- Module Name: ethernet_module - Behavioral
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

entity ethernet_module is
    PORT(  CLK10I, RESETN : in std_logic;
           TABORTP, TAVAILP, TFINISHP, TLASTP : in std_logic; 
           RENABP : in std_logic;
           
           RBYTEP, RCLEANP, RCVNGP, RDONEP, RSMATIP, RSTARTP : out std_logic;
           TDONEP, TREADDP, TRNSMTP, TSTARTP : out std_logic;
           
           TSOCOLP, TSMCOLP, TSECOLP : out std_logic; 
           
           TDATAI : in std_logic_vector (7 downto 0);
           TDATAO : out std_logic_vector (7 downto 0);  
                   
           RDATAI : in std_logic_vector (7 downto 0);
           RDATAO : out std_logic_vector (7 downto 0)
           
    );
end ethernet_module;

architecture Struct of ethernet_module is
    component Ethernet_transmitter
        PORT( CLK10I, RESETN : in std_logic;
        
              TABORTP, TAVAILP, TFINISHP, TLASTP, TSOCOLP, TSMCOLP, TSECOLP : in std_logic;
              TDONEP, TREADDP, TRNSMTP, TSTARTP, COLLISION_HAPPENING : out std_logic;
        
              TDATAI : in std_logic_vector (7 downto 0);
              TDATAO : out std_logic_vector (7 downto 0));
    end component;
    
component ethernet_receiver
    PORT( CLK10I, RESETN : in std_logic;
    
          RENABP : in std_logic;
          RBYTEP, RCLEANP, RCVNGP, RDONEP, RSMATIP, RSTARTP : out std_logic;
    
          RDATAI : in std_logic_vector (7 downto 0);
          RDATAO : out std_logic_vector (7 downto 0)
          );
 end component;
 
 component ethernet_collision is
         Port (CLK10I, RESETN : in std_logic;
         
               TRNSMTP, RCVNGP, TABORTP, COLLISION_HAPPENING: in std_logic;
               TSOCOLP, TSMCOLP, TSECOLP : out std_logic);
     end component;    

signal TRNSMTP_inter : std_logic;
signal RCVNGP_inter : std_logic;
signal TDONEP_inter : std_logic;

signal TSOCOLP_inter : std_logic;
signal TSMCOLP_inter : std_logic;
signal TSECOLP_inter : std_logic;

signal COLLISION_HAPPENING_inter : std_logic;

signal Test_sortie : std_logic_vector (7 downto 0);

begin

    U1 : ethernet_transmitter port map (CLK10I => CLK10I, 
                                        RESETN => RESETN, 
                                        TABORTP => TABORTP,
                                        TAVAILP => TAVAILP, 
                                        TFINISHP => TFINISHP,
                                        TLASTP => TLASTP,
                                        TDONEP => TDONEP, 
                                        TREADDP => TREADDP,
                                        TRNSMTP => TRNSMTP_inter, 
                                        TSTARTP => TSTARTP, 
                                        TDATAI => TDATAI, 
                                        TDATAO => TDATAO,
                                        TSOCOLP => TSOCOLP_inter,
                                        TSMCOLP => TSMCOLP_inter, 
                                        TSECOLP => TSECOLP_inter,
                                        COLLISION_HAPPENING => COLLISION_HAPPENING_inter);
    
    U2 : ethernet_receiver port map (CLK10I => CLK10I,
                                     RESETN => RESETN,
                                     RENABP => RENABP,
                                     RBYTEP => RBYTEP,
                                     RCLEANP => RCLEANP,
                                     RCVNGP => RCVNGP_inter,
                                     RDONEP => RDONEP,
                                     RSMATIP => RSMATIP,
                                     RSTARTP => RSTARTP,
                                     RDATAI => RDATAI,
                                     RDATAO => RDATAO);
                                     
    U3 : ethernet_collision port map (CLK10I => CLK10I,
                                      RESETN => RESETN,
                                      TRNSMTP => TRNSMTP_inter,
                                      RCVNGP => RCVNGP_inter,
                                      TABORTP => TABORTP,
                                      TSOCOLP => TSOCOLP_inter,
                                      TSMCOLP => TSMCOLP_inter,
                                      TSECOLP => TSECOLP_inter,
                                      COLLISION_HAPPENING => COLLISION_HAPPENING_inter);

    TRNSMTP <= TRNSMTP_inter;
    RCVNGP <= RCVNGP_inter;
    
    TSOCOLP <= TSOCOLP_inter;
    TSMCOLP <= TSMCOLP_inter;
    TSECOLP <= TSECOLP_inter;
    

end Struct;
