<img width="446" alt="image" src="https://github.com/user-attachments/assets/18c22235-9b0b-4ebc-98d4-9208432772fc"><img width="446" alt="image" src="https://github.com/user-attachments/assets/949dc434-c816-4263-9e2e-5b15e9ca43b8"># FPGA Based Photon Coincidence Counter
 An efficient and easy to scale photon coincidence counter that utilises the key features of an FPGA- parallel high speed processing & scalability

This project uses the Xilinx Artix-7 FPGA installed on the Alchitry Au FPGA development board that can be found here: https://alchitry.com/boards/au/

**Name:** Saurabh Tiwari

**Institution:** Trinity College, Hartford, CT

# Project Overview

Quantum mechanical experiemtns often require photons that are correlated (sometimes these are entangled photons as well). 
This project provides a straight forward solution to finding out the correlation between two photons (or more) by checking if they are **coincident**. 
Photons that are detected within a certain time window of each other – usually several nanoseconds -- are said to be **coincident photons!**


# Features

- **High Bandwidth Counting:** The module can count upto 45 million coincident photons per second!
- **Interactive Graphical User Interface:** Live updates availbale using on the PC using Python based GUI.
- **Simple and Robust Communication:** The FPGA hardware communciates with the PC using a universal and simple, yet robust communication protocol- 
Universal Asynchronous Receiver-Transmitter (UART).
- **Verilog:** The FPGA is programmed using Verilog- an industry standard programming language for FPGAs, ASICs, etc.

# Project Structure
- **'blinky.v'** : The top module integrating the wave generator and LED control logic.
- **'wave.v** : Module generating the PWM wave pattern for the LEDs.
- **'reset_conditioner.v'** : Module ensuring a clean reset signal.

# Getting Started
**Prerequisites**

- **FPGA development board** : Alchitry Au can be bought here: https://www.sparkfun.com/products/16527?gad_source=1&gbraid=0AAAAADsj4ERmTcWTfacvj-O-PNMcfs9UH&gclid=EAIaIQobChMIyaiZ56eahwMV20n_AR3fmQGuEAQYASABEgI_IvD_BwE
- **FPGA Development Software** : Considering the FPGA is from Xilinx, download Vivado

**Usage**
- **Synthesize and Generate bit stream** using Vivado after you have opened the project (blinky.xpr) with Vivado
- **Program** the bitstream to your FPGA development board using Alchitry loader (https://alchitry.com/news/alchitry-loader-v2/). Make note that you need a bin file generated from Vivado
- Observe the dynamic wave pattern on the LEDs and the alternating custom pattern when the reset button is pressed.

# License
This project is licensed under the MIT License - see the LICENSE file for details.

# Acknowledgements

- Thanks to the Trinity College Summer Research Program, under which I have been working on FPGA projects under Dr. Davind Branning, PhD.
- Special mention to SparkFun for PWM wave pattern inspiration.

# Contact
Feel free to contact me if you run into any problems with the code or if you have any cool suggestions.

**E-mail:** saurabh.tiwari@trincoll.edu
