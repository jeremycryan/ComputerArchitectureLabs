# Lab 2 Report

For this lab we created a SPI memory module using behavioral verilog.

Overall, we followed the suggested schematic that was provided for the lab. The only difference we made was that our finite state machine also takes in the clk signal.

![Schematic](https://camo.githubusercontent.com/a3d99b6ef56619616b97d89ff938a494d40f8ccb/68747470733a2f2f65333830323365322d612d36326362336131612d732d73697465732e676f6f676c6567726f7570732e636f6d2f736974652f6361313566616c6c2f7265736f75726365732f6c6162322d7370692d736368656d2e706e67)

## Final State Machine
Our final state machine had 7 states in total. While the finite state machine runs on the clk signal, some state transitions and counters are controlled by the positive edge of the serial clock so that data is presented according to the our defined SPI behavior.

#### Standby: 
The standby state waits for the CS pin to be asserted low, then transitions to the Wait_Address state.

#### Wait_Address: 
This state waits for all the address byte to be fully inputed into the shift register. The write enable pin for the address latch is driven high until after the 7th bit, which is the last bit of the address. Depending on the 8th bit (R/W bit) of the byte the state transitions to read_0 or write_0.

#### Read_0: 

#### Read_1:

#### Write_0: 

#### Write_1:

#### Wait_End: 
This state waits for CS to be deasserted to high. Once CS is deasserted the FSM transitions back to the Standby state.

## Testing:
For our test we wrote to our spi memory and the read the same memory address we wrote to.

## Work Plan Reflection:
For our midpoint check-in we were on schedule with our work plan. For our final SPI memory however, we did less work on Wednesday than we scheduled in our work plan and a lot of work overflowed into Thursday. We planned to only do our report on Thursday but that is not what happened. In the future we need to be a little stricter about doing the amount of work we put on our work plan.
