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

# Global variables for countsA, countsB, countsAB, timestamp, and maxval
countsA = 0
countsB = 0
countsAB = 0
timestamp = 0
maxval = 0

# Function to receive and update the countsA, countsB, countsAB, timestamp, and maxval
def receive_and_update():
    global countsA, countsB, countsAB, timestamp, maxval
    while True:
        try:
            # Read exactly 17 bytes (32 bits for countsA, 32 bits for countsB, 
            # 32 bits for countsAB, 32 bits for timestamp, and 8 bits for maxval)
            ser.reset_input_buffer()  # Clear the serial input buffer
            data = ser.read(17)  # Read 17 bytes from the serial port
            if len(data) == 17:  # Ensure that 17 bytes were received
                # Parse the received data into respective variables
                countsA = (data[3] << 24) | (data[2] << 16) | (data[1] << 8) | data[0]
                countsB = (data[7] << 24) | (data[6] << 16) | (data[5] << 8) | data[4]
                countsAB = (data[11] << 24) | (data[10] << 16) | (data[9] << 8) | data[8]
                timestamp = (data[15] << 24) | (data[14] << 16) | (data[13] << 8) | data[12]
                maxval = data[16]

                # Print the received values to the console
                print(f"Received: countsA = {countsA}, countsB = {countsB}, countsAB = {countsAB}, timestamp = {timestamp}, maxval = {maxval}")

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
    label_countsAB.config(text=f"Counts AB: {countsAB}")  # Update label for countsAB
    window.update_idletasks()  # Force update of the GUI

# Set up the GUI
window = tk.Tk()  # Create the main window
window.geometry('400x300')  # Set the window size
window.title("Counts Value")  # Set the window title

# Labels for displaying countsA, countsB, and countsAB
label_countsA = tk.Label(window, text="Counts A: 0", font=("Helvetica", 24))
label_countsA.pack(expand=True)  # Add label_countsA to the window

label_countsB = tk.Label(window, text="Counts B: 0", font=("Helvetica", 24))
label_countsB.pack(expand=True)  # Add label_countsB to the window

label_countsAB = tk.Label(window, text="Counts AB: 0", font=("Helvetica", 24))
label_countsAB.pack(expand=True)  # Add label_countsAB to the window

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
