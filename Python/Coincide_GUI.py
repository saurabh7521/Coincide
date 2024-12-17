import serial
import time
import threading
import tkinter as tk

# Configure the serial connection to communicate with FPGA
ser = serial.Serial(
    port='COM12',  # Replace 'COM12' with the correct COM port for your system
    baudrate=9600,  # Baud rate for UART communication
    bytesize=serial.EIGHTBITS,  # 8 data bits
    parity=serial.PARITY_NONE,  # No parity bit
    stopbits=serial.STOPBITS_ONE,  # 1 stop bit
    timeout=None  # No timeout; wait indefinitely for data
)

# Global variables for counts, timestamp, maxval, and coincidence window settings
counts_x = [0] * 15  # List to hold 15 x coincidence counts
counts_y = [0] * 15  # List to hold 15 y coincidence counts
timestamp = 0  # 32-bit timestamp
maxval = 0  # 8-bit timer maxval
x_window = 10  # Default x coincidence window length
y_window = 20  # Default y coincidence window length


# Function to send x_window and y_window values to FPGA every second
def send_window_data():
    global x_window, y_window
    while True:
        try:
            # Convert x_window and y_window to bytes and send them
            ser.write(bytes([x_window, y_window]))
            time.sleep(1)  # Send the values every 1 second
        except serial.SerialException as e:
            print(f"Serial error: {e}")  # Handle serial communication errors
            time.sleep(1)  # Wait before retrying


# Function to receive data from FPGA and update the counts and other values
def receive_and_update():
    global counts_x, counts_y, timestamp, maxval
    while True:
        try:
            # Expecting 125 bytes: 15 x 4 bytes for x, 15 x 4 bytes for y, 4 bytes timestamp, and 1 byte maxval
            ser.reset_input_buffer()  # Clear any leftover data in the input buffer
            data = ser.read(125)  # Read 125 bytes of data
            if len(data) == 125:  # Proceed only if exactly 125 bytes were received
                # Parse the 15 counts for the x coincidence window
                for i in range(15):
                    counts_x[i] = (data[4 * i + 3] << 24) | (data[4 * i + 2] << 16) | (data[4 * i + 1] << 8) | data[
                        4 * i]

                # Parse the 15 counts for the y coincidence window
                for i in range(15):
                    counts_y[i] = (data[60 + 4 * i + 3] << 24) | (data[60 + 4 * i + 2] << 16) | \
                                  (data[60 + 4 * i + 1] << 8) | data[60 + 4 * i]

                # Parse the 32-bit timestamp
                timestamp = (data[123] << 24) | (data[122] << 16) | (data[121] << 8) | data[120]

                # Parse the 8-bit maxval
                maxval = data[124]

                # Update the GUI with the new data
                update_gui()

        except serial.SerialException as e:
            print(f"Serial error: {e}")  # Handle serial port errors
            time.sleep(1)

        except Exception as e:
            print(f"Unexpected error: {e}")  # Handle any other errors
            time.sleep(1)


# Function to update the GUI with the latest counts, timestamp, and maxval
def update_gui():
    # Update the labels for x coincidence window counts
    for i, label in enumerate(labels_x):
        label.config(text=f"X Window Count {labels[i]}: {counts_x[i]}")

    # Update the labels for y coincidence window counts
    for i, label in enumerate(labels_y):
        label.config(text=f"Y Window Count {labels[i]}: {counts_y[i]}")

    # Update the timestamp and maxval labels
    label_timestamp.config(text=f"Timestamp: {timestamp}")
    label_maxval.config(text=f"Maxval: {maxval}")

    # Force the GUI to refresh with updated data
    window.update_idletasks()


# Function to handle spin box changes and update x_window and y_window values
def update_window_values():
    global x_window, y_window
    x_window = int(spin_x.get())  # Get the new value for x_window from the spinbox
    y_window = int(spin_y.get())  # Get the new value for y_window from the spinbox


# Set up the GUI window
window = tk.Tk()
window.geometry('800x800')  # Set the size of the window
window.title("Coincidence Counts")  # Set the window title

# Frame for spinboxes to set x_window and y_window lengths
frame_top = tk.Frame(window)
frame_top.pack(pady=10)

# Spinbox and label for x_window
tk.Label(frame_top, text="X Window Length:", font=("Helvetica", 14)).grid(row=0, column=0, padx=10)
spin_x = tk.Spinbox(frame_top, from_=1, to=255, width=5, font=("Helvetica", 14), command=update_window_values)
spin_x.grid(row=0, column=1, padx=10)
spin_x.delete(0, "end")
spin_x.insert(0, str(x_window))  # Set the default value for x_window

# Spinbox and label for y_window
tk.Label(frame_top, text="Y Window Length:", font=("Helvetica", 14)).grid(row=0, column=2, padx=10)
spin_y = tk.Spinbox(frame_top, from_=1, to=255, width=5, font=("Helvetica", 14), command=update_window_values)
spin_y.grid(row=0, column=3, padx=10)
spin_y.delete(0, "end")
spin_y.insert(0, str(y_window))  # Set the default value for y_window

# Frame for displaying the x and y counts
frame_counts = tk.Frame(window)
frame_counts.pack()

# Lists to hold labels for x and y counts
labels_x = []
labels_y = []
labels = ["A", "B", "C", "D", "AB", "AC", "AD", "BC", "BD", "CD", "ABC", "ABD", "ACD", "BCD", "ABCD"]

# Create labels for the 15 counts for x and y windows
for i in range(15):
    # Labels for x window counts
    label_x = tk.Label(frame_counts, text=f"X Window Count {labels[i]}: 0", font=("Helvetica", 14))
    label_x.grid(row=i, column=0, padx=10, pady=2)
    labels_x.append(label_x)

    # Labels for y window counts
    label_y = tk.Label(frame_counts, text=f"Y Window Count {labels[i]}: 0", font=("Helvetica", 14))
    label_y.grid(row=i, column=1, padx=10, pady=2)
    labels_y.append(label_y)

# Label for timestamp
label_timestamp = tk.Label(window, text="Timestamp: 0", font=("Helvetica", 16))
label_timestamp.pack(pady=10)

# Label for maxval
label_maxval = tk.Label(window, text="Maxval: 0", font=("Helvetica", 16))
label_maxval.pack(pady=10)

# Start threads for sending and receiving data
send_thread = threading.Thread(target=send_window_data, daemon=True)
send_thread.start()

receive_thread = threading.Thread(target=receive_and_update, daemon=True)
receive_thread.start()


# Function to handle window close event
def on_closing():
    ser.close()  # Close the serial port
    window.quit()  # Exit the GUI


# Bind the window close event to on_closing function
window.protocol("WM_DELETE_WINDOW", on_closing)

# Start the Tkinter main loop
window.mainloop()
