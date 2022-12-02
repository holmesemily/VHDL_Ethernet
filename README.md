# VHDL_Ethernet

## Project Description
A modelisation of an Ethernet module in FPGA.
This was made using Xilinx Vivado and written in VHDL. 

Programmed by Maïlis Dy and Emily Holmes as part of a VHDL course.

### System Characteristics 
The system was built to function with a period of 10ns, but can work with as low as 2.155ns. Thus, a frequency of 460MHz.

## Module description
The Ethernet module is built around the Ethernet Core 10 manual. Our implementation is centered around three components :

### Signals shared between all modules : 
- RESETN -> Reinitialize all three components to their initial state
- CLK10I -> Clock

### **Transmitter** 

**Input** 
- TABORTP -> Requires transmission termination
- TAVAILP -> Data is ready to be treated
- TFINISHP -> Transmission is done, no more data to transmit
- TDATAI[0:7] -> Data to be transmitted
- TLASTP -> Last data has been sent - this signal is unused in our project, as we communicate this information with TFINISHP.
- TSOCOLP, TSMCOLP, TSECOLP -> Collision state information (in order: 1 collision, multiple collisions, too many collisions and stop transmission until reset).
      
**Output**
- TDATAO[0:7] -> Information sent
- TDONEP -> Transmission is done (regardless of success/failure)
- TREADDP -> Available byte has been read
- TRNSMTP -> Transmitting 
- TSTARTP -> Transmission begins (impulse when SFD received)
- TSUCCESS, TFAIL -> Lets Collision component know whether transmission failed or succeeded
      
### **Receiver** 
 
**Input**
- RENABP -> Data to receive
- RDATAI[0:7] -> Data received
      
**Output**
- RBYTEP -> Sent after every byte received
- RCLEANP -> Sent after error
- RCVNGP -> Receiving data
- RDONEP -> Sent after successful reception (EFD)
- RSMATIP -> Address match
- RSTARTP -> SFD received
- RDATAO[0:7] -> Data sent to upper layer
      
 
### **Collision**
 
**Input**
- TRNSMTP -> Transmitting
- RCVNGP -> Receiving
- TABORTP -> Transmission is aborting (according to specs, TSOCOLP and TSMCOLP must be asserted high during any and all signal abortion)
- TSUCCESS -> Transmission was successful (to reset failed transmission attempts)
- TFAIL -> Transmission failed (to count failed transmission attemps)
      
**Output**
- TSOCOLP -> Single collision detected
- TSMCOLP -> Multiple collision detected
- TSECOLP -> Too many collision detected (15+) : transmitter will not try transmitting again
fos?
 
 
