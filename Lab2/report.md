# Lab 2 Report

For this lab we created a SPI memory module using behavioral verilog.

Overall, we followed the suggested schematic that was provided for the lab. The only difference we made was that our finite state machine also takes in the clk signal.

![Schematic](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab2/schematic.png)

## Input Conditioner
Our Input Conditioner submodule takes in a noisy signal and outputs a debounced, conditioned signal along with positive edge and negative edge signals. As you can see in our schematic, we use three Input Conditioners in our SPI memory: one to condition the MOSI signal; one to get the positive and negative edges from the serial clock; and one to condition the chip select signal.

Since our serial clock goes through an input conditioner, if the serial clock is too fast in relation to the system clock the signal is flattened by the debouncer. However, this should not be a problem in actual use as in most use cases the system clock will be at least an order of magnitude faster than the serial clock. For example, our FPGA's have a max clock speed of 60MHz and a minimum of 30MHz according to ![its data sheet](https://www.xilinx.com/support/documentation/data_sheets/ds187-XC7Z010-XC7Z020-Data-Sheet.pdf) and although SPI does not have a set clock speed, a SPI serial clock typically does not exceed a few MHz.

## Shift Register
Our Shift Register submodule can handle parallel in-serial out as well as serial in-parallel out. It shifts on the positive edge of the serial clock, as you can see in our schematic.

## Address Latch
Our address latch is made up of 7 flip flops. Since the address in SPI is only 7 bits, we just tie the most significant 7 bits of the shift register parallel out to the input of our address latch. The address latch is controlled by an enable signal.

## D-Flip Flop
This submodule is a d-flip flop that is controlled by the negative edge of the serial clock.

## Finite State Machine
Our finite state machine had 7 states in total. While the finite state machine runs on the clk signal, some state transitions and counters are controlled by the positive edge of the serial clock so that data is presented according to the our defined SPI behavior.

![Block diagram](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab2/FSM_diagram.png)

#### Standby: 
The standby state waits for the CS pin to be asserted low, then transitions to the `wait_address` state.
#### Wait_Address: 
This state waits for all the address byte to be fully inputed into the shift register. The write enable pin for the address latch is driven high until after the 7th bit, which is the last bit of the address. On the first serial clock cycle after the R/W bit is available, the state changes to `test_mosi`.
#### Test_MOSI
This state checks the most recent bit of the MOSI line and, if it is a zero, changes the state to `write_0`; otherwise, it changes the state to `read_0`. Because it's important that we pull the requested byte out of data memory and start the output to the MISO line within the next serial clock cycle, `test_mosi` transitions on the internal clock, not the serial clock.
#### Read_0: 
This state enables the MISO buffer, so that data can be pushed to the MISO line; it also loads a data memory byte to the shift register specified by the address stored in the address latch.
#### Read_1:
This state keeps the MISO line asserted as data is serially output from the shift register. After 8 bits, it changes state to `wait_end`.
#### Write_0: 
This state waits for all 8 data bits to be input to the shift register. Then, it changes state to `write_1`. During this state, the miso buffer, shifter enable, address latch enable, and data memory write enable lines are all low.
#### Write_1:
This state writes the current value of the shift register to the data memory address stored in the address latch. It then changes state to `wait_end`.
#### Wait_End: 
This state waits for CS to be deasserted to high. Once CS is deasserted the FSM transitions back to `standby`.

## Testing:
For our test, we wrote to our SPI memory and then read the same memory address we wrote to. We did this for two different sets of addresses and data in. We were unable to fix a problem when reading where the MISO buffer would be enabled a couple clk cycles before the shift register and d-flip flop were sending data to the line. However, we do not believe this to affect communications as the MISO line is sent data with the serial clock, so the error should not be read by the master since it happens between serial clock cycles.

![Test case 1 waveform](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab2/test_1_waveform.png)

Above is a GTKWave visualization of a test of our SPI memory. In this case, the R/W address is 0000011 and the data byte is 10101010. 

![Test case 2 waveform](https://github.com/jeremycryan/ComputerArchitectureLabs/blob/master/Lab2/test_2_waveform.png)

Above is the visualization of another test. In this case, the R/W address is 0011010 and the data byte is 11110000. In both of these cases, we first write data to the address, then attempt to read it.

## Work Plan Reflection:
For our midpoint check-in we were on schedule with our work plan. For our final SPI memory however, we did less work on Wednesday than we scheduled in our work plan and a lot of work overflowed into Thursday. We planned to only do our report on Thursday but that is not what happened. In the future we need to be a little stricter about doing the amount of work we put on our work plan.
