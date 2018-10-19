# Lab 2 Report

For this lab we created a SPI memory module using behavioral verilog.

Overall, we followed the suggested schematic that was provided for the lab. The only difference we made was that our finite state machine also takes in the clk signal.

![Schematic](https://camo.githubusercontent.com/a3d99b6ef56619616b97d89ff938a494d40f8ccb/68747470733a2f2f65333830323365322d612d36326362336131612d732d73697465732e676f6f676c6567726f7570732e636f6d2f736974652f6361313566616c6c2f7265736f75726365732f6c6162322d7370692d736368656d2e706e67)

## Input Conditioner
Our Input Conditioner submodule takes in a noisy signal and outputs a debounced, conditioned signal along with positive edge and negative edge signals. As you can see in our schematic, we use three Input Conditioners in our SPI memory: one to condition the MOSI signal; one to get the positive and negative edges from the serial clock; and one to condition the chip select signal.

Since our serial clock goes through an input conditioner, if the serial clock is too fast in relation to the system clock the signal is flattened by the debouncer. However, this should not be a problem in actual use as in most use cases the system clock will be at least an order of magnitude faster than the serial clock. For example, our FPGA's have a max clock speed of 60MHz and a minimum of 30MHz according to ![its data sheet](https://www.xilinx.com/support/documentation/data_sheets/ds187-XC7Z010-XC7Z020-Data-Sheet.pdf) and although SPI does not have a set clock speed, a SPI serial clock typically does not exceed a few MHz.

## Shift Register
Our Shift Register submodule can handle parallel in-serial out as well as serial in-parallel out. It shifts on the positive edge of the serial clock, as you can see in our schematic.

## Address Latch
Our address latch is made up of 7 flip flops. Since the address in SPI is only 7 bits, we just tie the most significant 7 bits of the shift register parallel out to the input of our address latch. The address latch is controlled by an enable signal.

## D-Flip Flop
This submodule is a d-flip flop that is controlled by the negative edge of the serial clock.

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
