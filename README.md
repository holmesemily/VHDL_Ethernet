# VHDL_Ethernet

## Project Description
A modelisation of an Ethernet module in FPGA.
This was made using Xilinx Vivado and written in VHDL. 

Programmed by Maïlis Dy and Emily Holmes as part of a VHDL course.

### Project Completion
The project contains : 
- The Transmitter module (behavioral architecture)
- The Receiving module (behavioral architecture)
- The Collision module (behavioral architecture)
- The "Ethernet" module, containing all three components (structural architecture)

On top of that, regarding the collisions :
- We can detect single collision, multiple collisions, and transmission is aborted (until a RESETN signal) after 15 collisions (As per TSECOLP signal specification).
- After each collision, the transmission module will send 32 bits of padding (1-0 alternating). 

### System Characteristics 
The system was built to function with a period of 10ns, but can work with as low as **2.155ns**. Thus, a frequency of 460MHz.
![minperiod](https://user-images.githubusercontent.com/81361917/205255471-4c627e3b-882f-4527-a42e-9171c2066384.png)

The implementation contains a total of 75 flip-flops and 108 LUT.
<br/>
![slicelogic](https://user-images.githubusercontent.com/81361917/205257219-f9898470-21a9-48c7-97de-8fa48afa3497.png)

### Tests
The following tests are included in the VHDL simulation file. They are briefly described here and a screenshot is included.

**Receiving - Address match**
![receiver_addr_match](https://user-images.githubusercontent.com/81361917/205262646-6af4bbe7-26c6-42f1-b0c8-936d53057675.png)

**Receiving - No Address match**
![receiving-nomatch](https://user-images.githubusercontent.com/81361917/205262895-1d0e0696-7270-4581-bd81-85b1b5888aa4.png)

**Transmitting - Successful**
![transmissing_successful](https://user-images.githubusercontent.com/81361917/205262938-8cebbc47-f4c6-453b-8a4c-41ef81434c46.png)

**Transmitting - Abort**
![transmitting - abort](https://user-images.githubusercontent.com/81361917/205262971-4f2cb13b-66ec-489f-91b7-d5cfd19f59c1.png)

**Transmitting - Reset**
![transmitting-reset](https://user-images.githubusercontent.com/81361917/205262983-008773d6-68da-438d-8730-3ef8c69f9660.png)

**Collision Test**
![collision](https://user-images.githubusercontent.com/81361917/205262989-a9d1d066-128b-44fc-b50e-5c9cf4a59259.png)


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
 
 
