library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;


entity ethernet_transmitter is
    Generic (
        SFD : std_logic_vector (7 downto 0) := "10101011";
        EFD : std_logic_vector (7 downto 0) := "01010100";
        NOADDRI : std_logic_vector (47 downto 0) := "110011001100110011001100110011001100110011001100";
    );

    Port (CLK10I : in std_logic;
          RESETN : in std_logic;

          TABORTP : in std_logic;
          TAVAILP : in std_logic;
          TDONEP : out std_logic;
          TFINISHP : in std_logic;
          TLASTP : in std_logic;
          TREADDP : out std_logic;
          TRNSMTP : out std_logic;
          TSTARTP : out std_logic;

          TDATAI : in std_logic_vector (7 downto 0);
          TDATAO : out std_logic_vector (7 downto 0);
          );
end ethernet_transmitter;

architecture Behavioral of ethernet_transmitter is
    signal CLK10I_8 : std_logic_vector (2 downto 0) := (others => '0');  
    signal CURRENT_DATA : std_logic_vector (7 downto 0);
begin
    process (CLK10I) 
        begin
            if (rising_edge(CLK10I)) then 
                if (RESETN = '0') then
                    -- routine de reset
                else 
                    CLK10I_8 <= CLK10I_8 + 1;
                    if (rising_edge(TABORTP)) then
                        -- envoyer 32 bits de padding sur TDATAO, envoyer TDONEP, baisser TRNSMTP
                    elsif (TAVAILP = '1') then
                        CLK10I_8 <= "100";    -- sync à l'octet
                        if (CLK10I_8[2] = '1') then
                            CURRENT_DATA <= SFD;
                        else 
                        CURRENT_DATA <= EFD; -- for testing purposes
                        end if;
                    end if;
                end if;
            end if;
    end process; 
    TDATAO <= CURRENT_DATA;
end Behavioral;
