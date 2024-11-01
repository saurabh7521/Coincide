import serial
import time
import threading
import tkinter as tk

# Configure the serial connection
ser = serial.Serial(
    port='COM5',  # Replace with your COM port
    baudrate=9600,
    bytesize=serial.EIGHTBITS,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    timeout=None  # No timeout, wait indefinitely for input
)

# Global variables for all counts, timestamp, and maxval
countsA = countsB = countsC = countsD = 0
countsAB = countsAC = countsAD = countsBC = countsBD = countsCD = 0
countsABC = countsABD = countsACD = countsBCD = countsABCD = 0
timestamp = maxval = 0

# Function to receive and update the counts and other values
def receive_and_update():
    global countsA, countsB, countsC, countsD, countsAB, countsAC, countsAD, countsBC, countsBD, countsCD
    global countsABC, countsABD, countsACD, countsBCD, countsABCD, timestamp, maxval
    while True:
        try:
            # Read exactly 65 bytes (32 bits for each count, 32 bits for timestamp, and 8 bits for maxval)
            ser.reset_input_buffer()  # Clear the serial input buffer
            data = ser.read(65)  # Read 65 bytes from the serial port
            if len(data) == 65:  # Ensure that 65 bytes were received
                # Parse the received data into respective variables
                countsA = (data[3] << 24) | (data[2] << 16) | (data[1] << 8) | data[0]
                countsB = (data[7] << 24) | (data[6] << 16) | (data[5] << 8) | data[4]
                countsC = (data[11] << 24) | (data[10] << 16) | (data[9] << 8) | data[8]
                countsD = (data[15] << 24) | (data[14] << 16) | (data[13] << 8) | data[12]
                countsAB = (data[19] << 24) | (data[18] << 16) | (data[17] << 8) | data[16]
                countsAC = (data[23] << 24) | (data[22] << 16) | (data[21] << 8) | data[20]
                countsAD = (data[27] << 24) | (data[26] << 16) | (data[25] << 8) | data[24]
                countsBC = (data[31] << 24) | (data[30] << 16) | (data[29] << 8) | data[28]
                countsBD = (data[35] << 24) | (data[34] << 16) | (data[33] << 8) | data[32]
                countsCD = (data[39] << 24) | (data[38] << 16) | (data[37] << 8) | data[36]
                countsABC = (data[43] << 24) | (data[42] << 16) | (data[41] << 8) | data[40]
                countsABD = (data[47] << 24) | (data[46] << 16) | (data[45] << 8) | data[44]
                countsACD = (data[51] << 24) | (data[50] << 16) | (data[49] << 8) | data[48]
                countsBCD = (data[55] << 24) | (data[54] << 16) | (data[53] << 8) | data[52]
                countsABCD = (data[59] << 24) | (data[58] << 16) | (data[57] << 8) | data[56]
                timestamp = (data[63] << 24) | (data[62] << 16) | (data[61] << 8) | data[60]
                maxval = data[64]

                # Print the received values to the console
                print(f"Received: countsA = {countsA}, countsB = {countsB}, countsC = {countsC}, countsD = {countsD}, "
                      f"countsAB = {countsAB}, countsAC = {countsAC}, countsAD = {countsAD}, "
                      f"countsBC = {countsBC}, countsBD = {countsBD}, countsCD = {countsCD}, "
                      f"countsABC = {countsABC}, countsABD = {countsABD}, countsACD = {countsACD}, "
                      f"countsBCD = {countsBCD}, countsABCD = {countsABCD}, timestamp = {timestamp}, maxval = {maxval}")

                # Update the GUI with the new values
                update_gui()

        except serial.SerialException as e:
            # Handle serial communication errors
            print(f"Serial error: {e}")
            time.sleep(1)  # Wait before trying again

        except Exception as e:
            # Handle any other unexpected errors
            print(f"Unexpected error: {e}")
            time.sleep(1)  # Wait before trying again

# Function to update the GUI
def update_gui():
    label_countsA.config(text=f"Counts A: {countsA}")  # Update label for countsA
    label_countsB.config(text=f"Counts B: {countsB}")  # Update label for countsB
    label_countsC.config(text=f"Counts C: {countsC}")  # Update label for countsC
    label_countsD.config(text=f"Counts D: {countsD}")  # Update label for countsD
    label_countsAB.config(text=f"Counts AB: {countsAB}")  # Update label for countsAB
    label_countsAC.config(text=f"Counts AC: {countsAC}")  # Update label for countsAC
    label_countsAD.config(text=f"Counts AD: {countsAD}")  # Update label for countsAD
    label_countsBC.config(text=f"Counts BC: {countsBC}")  # Update label for countsBC
    label_countsBD.config(text=f"Counts BD: {countsBD}")  # Update label for countsBD
    label_countsCD.config(text=f"Counts CD: {countsCD}")  # Update label for countsCD
    label_countsABC.config(text=f"Counts ABC: {countsABC}")  # Update label for countsABC
    label_countsABD.config(text=f"Counts ABD: {countsABD}")  # Update label for countsABD
    label_countsACD.config(text=f"Counts ACD: {countsACD}")  # Update label for countsACD
    label_countsBCD.config(text=f"Counts BCD: {countsBCD}")  # Update label for countsBCD
    label_countsABCD.config(text=f"Counts ABCD: {countsABCD}")  # Update label for countsABCD
    window.update_idletasks()  # Force update of the GUI

# Set up the GUI
window = tk.Tk()  # Create the main window
window.geometry('600x600')  # Set the window size to accommodate more labels
window.title("Counts Value")  # Set the window title

# Labels for displaying countsA, countsB, countsC, countsD, AB, AC, AD, BC, BD, CD, ABC, ABD, ACD, BCD, and ABCD
label_countsA = tk.Label(window, text="Counts A: 0", font=("Helvetica", 24))
label_countsA.pack(expand=True)  # Add label_countsA to the window

label_countsB = tk.Label(window, text="Counts B: 0", font=("Helvetica", 24))
label_countsB.pack(expand=True)  # Add label_countsB to the window

label_countsC = tk.Label(window, text="Counts C: 0", font=("Helvetica", 24))
label_countsC.pack(expand=True)  # Add label_countsC to the window

label_countsD = tk.Label(window, text="Counts D: 0", font=("Helvetica", 24))
label_countsD.pack(expand=True)  # Add label_countsD to the window

label_countsAB = tk.Label(window, text="Counts AB: 0", font=("Helvetica", 24))
label_countsAB.pack(expand=True)  # Add label_countsAB to the window

label_countsAC = tk.Label(window, text="Counts AC: 0", font=("Helvetica", 24))
label_countsAC.pack(expand=True)  # Add label_countsAC to the window

label_countsAD = tk.Label(window, text="Counts AD: 0", font=("Helvetica", 24))
label_countsAD.pack(expand=True)  # Add label_countsAD to the window

label_countsBC = tk.Label(window, text="Counts BC: 0", font=("Helvetica", 24))
label_countsBC.pack(expand=True)  # Add label_countsBC to the window

label_countsBD = tk.Label(window, text="Counts BD: 0", font=("Helvetica", 24))
label_countsBD.pack(expand=True)  # Add label_countsBD to the window

label_countsCD = tk.Label(window, text="Counts CD: 0", font=("Helvetica", 24))
label_countsCD.pack(expand=True)  # Add label_countsCD to the window

label_countsABC = tk.Label(window, text="Counts ABC: 0", font=("Helvetica", 24))
label_countsABC.pack(expand=True)  # Add label_countsABC to the window

label_countsABD = tk.Label(window, text="Counts ABD: 0", font=("Helvetica", 24))
label_countsABD.pack(expand=True)  # Add label_countsABD to the window

label_countsACD = tk.Label(window, text="Counts ACD: 0", font=("Helvetica", 24))
label_countsACD.pack(expand=True)  # Add label_countsACD to the window

label_countsBCD = tk.Label(window, text="Counts BCD: 0", font=("Helvetica", 24))
label_countsBCD.pack(expand=True)  # Add label_countsBCD to the window

label_countsABCD = tk.Label(window, text="Counts ABCD: 0", font=("Helvetica", 24))
label_countsABCD.pack(expand=True)  # Add label_countsABCD to the window

# Start the receiving function in a background thread
receiver_thread = threading.Thread(target=receive_and_update, daemon=True)
receiver_thread.start()  # Start the thread to receive data

# Function to close the application
def on_closing():
    ser.close()  # Close the serial port
    window.quit()  # Close the GUI window

# Set up the close window protocol
window.protocol("WM_DELETE_WINDOW", on_closing)

# Start the Tkinter main loop
window.mainloop()  # Run the GUI event loop