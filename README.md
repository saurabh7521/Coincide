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
- **'au_top.v'** : This module instantiates the ones above and integrates all the pieces for the functioning of the design as described below. 

And below is a flowchart that explains which file instantiates which file, or the file heirarchy. 

<img width="457" alt="image" src="https://github.com/user-attachments/assets/e7113d76-17aa-4176-97a9-47b7e409ebbc">

The au_top module instantiates timer, reset_conditioner, duplciator, uart_tx, and the comparator module. In turn, the duplicator module instantiates edge_detector and pipeline module. 

The raw input is first sent to the **duplicator** module by the au_top module. The duplciator sends the raw input to the pipeline, which cleans the input and outputs a "conditioned" signal that is synchronized with the FPGA clock. The dueplicator then sends this to the edge_detector that detects if the input has the transiiton from 0 to 1, if so, then the edge_detector outputs a high signal for one clock cycle. The duplicator takes this output from edge_detector and duplicates the signal for a specified number of clock cycles. This duplicated output is the final output signal of the duplicated module. 

The outputs of the duplicator is taken, bitmasked and then sent to the **comparator**. The comparator gives a high signal for one clock cycle if all the signals given to it are high.
Once this high signal is detected, an up-counter is incremented by one. This is the counter that counts the pulses as well as the coincidence. To count the coincidence of two pulses, send those two pulses together in the comparator. The current comparator takes four inputs. Depending upon how many pulse coincidence you want to count, bitmask the other inputs accordingly. 

The **timer** meanwhile is running and every second, it send a poll flag (a high signal). After reception of this poll flag, the au_top module captures the counter values, transmits them using UART and resets the counters.

The **UART** module sends the counter values along with once it reads that the tmr_maxval_temp bit is high, indicating that the timer module has completed counting a second and the data needs to be transmitted sequencially to the PC.

The **front end** is managed by Python. It uses the PySerial library for serial communication and the Tkinter library for GUI. The python code is self-explannatory. Feel free to reach out at the e-mail below if you need any clarification!

# Getting Started
**Prerequisites**

- **FPGA development board** : Alchitry Au can be bought here: https://www.sparkfun.com/products/16527?gad_source=1&gbraid=0AAAAADsj4ERmTcWTfacvj-O-PNMcfs9UH&gclid=EAIaIQobChMIyaiZ56eahwMV20n_AR3fmQGuEAQYASABEgI_IvD_BwE
- **FPGA Development Software** : Considering the FPGA is from Xilinx, download Vivado

**Usage**
- **Synthesize and Generate bit stream** using Vivado after you have opened the project (Coincide.xpr) with Vivado
- **Program** the bitstream to your FPGA development board using Alchitry loader (https://alchitry.com/news/alchitry-loader-v2/). Make note that you need a bin file generated from Vivado
- You now have a powerful multi-photon coincidence counter ready for applicaiton into your research!

# License
This project is licensed under the MIT License - see the LICENSE file for details.

# Acknowledgements

- Thanks to the Trinity College Summer Research Program, under which I have been working on FPGA projects under Dr. Davind Branning, PhD.

# Contact
Feel free to contact me if you run into any problems with the code or if you have any cool suggestions.

**E-mail:** saurabh.tiwari@trincoll.edu
