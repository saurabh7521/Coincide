# FPGA Based Photon Coincidence Counter
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
- **Verilog:** The FPGA is programmed using Verilog- an industry standard programming language for FPGAs, ASICs, etc. with inline comments, thus making it easier for the public to understand the workings of module design.

# Project Structure

Below are the files used for the module design with a short description. 

- **'comparator.v'** : This module compares a 4-bit input with a bitmask and increments a counter if all bits are high.
- **'duplicator.v** : This module detects edges on an input pulse and duplicates the pulse for a user-specified duration. It uses an edge detector and a synchronizer to handle input pulse timing.
- **'edge_detector.v'** : Detects transitions in an input signal, specifically rising or falling edges, depending on its configuration. When an edge is detected, the module generates a brief pulse on its output (a high input for 1 clock cycle), which is used to trigger subsequent actions in the design.
- **'pipeline.v'** : This module introduces a configurable delay to an input signal by passing it through a series of flip-flops, effectively synchronizing the raw input signal with the rising edge of the FPGA clock to ensure a clean input signal. This module is crucial as it avoids metastability in the design.
- **'timer.v'** : A custom timer with 1-bit output that is HIGH for one cycle when the timer reaches its maximum value.
- **''uart_tx.v** : This module takes the pulse counts values of the inputs as well as coincident counts between the inputs and transmits them serially to the PC using UART communciation protocol.
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
