import serial
import time
import threading
import tkinter as tk

# Configure the serial connection
ser = serial.Serial(
    port='COM12',  # Replace with your COM port
    baudrate=9600,
    bytesize=serial.EIGHTBITS,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    timeout=None  # No timeout, wait indefinitely for input
)

# Global variables for counts, timestamp, maxval, and window values
counts_x = [0] * 15  # 15 counts for x coincidence window
counts_y = [0] * 15  # 15 counts for y coincidence window
timestamp = maxval = 0
x_window = 10  # Default x window
y_window = 20  # Default y window


# Function to send window data every second
def send_window_data():
    global x_window, y_window
    while True:
        try:
            # Send x_window and y_window as two 8-bit numbers
            ser.write(bytes([x_window, y_window]))
            time.sleep(1)  # Wait for 1 second
        except serial.SerialException as e:
            print(f"Serial error: {e}")
            time.sleep(1)  # Wait before trying again


# Function to receive and update the counts and other values
def receive_and_update():
    global counts_x, counts_y, timestamp, maxval
    while True:
        try:
            # Read exactly 131 bytes (64 bytes for x, 64 bytes for y, 4 bytes for timestamp, 1 byte for maxval)
            ser.reset_input_buffer()  # Clear the serial input buffer
            data = ser.read(125)  # Read 131 bytes from the serial port
            if len(data) == 125:  # Ensure that 131 bytes were received
                # Parse the received data for x and y windows
                for i in range(15):
                    counts_x[i] = (data[4 * i + 3] << 24) | (data[4 * i + 2] << 16) | (data[4 * i + 1] << 8) | data[
                        4 * i]
                    counts_y[i] = (data[60 + 4 * i + 3] << 24) | (data[60 + 4 * i + 2] << 16) | (
                            data[60 + 4 * i + 1] << 8) | data[60 + 4 * i]
                timestamp = (data[123] << 24) | (data[122] << 16) | (data[121] << 8) | data[120]
                maxval = data[124]

                # Update the GUI with the new values
                update_gui()

        except serial.SerialException as e:
            print(f"Serial error: {e}")
            time.sleep(1)  # Wait before trying again

        except Exception as e:
            print(f"Unexpected error: {e}")
            time.sleep(1)  # Wait before trying again


# Function to update the GUI
def update_gui():
    # Update labels for x window
    for i, label in enumerate(labels_x):
        label.config(text=f"X Window Count {labels[i]}: {counts_x[i]}")

    # Update labels for y window
    for i, label in enumerate(labels_y):
        label.config(text=f"Y Window Count {labels[i]}: {counts_y[i]}")

    # Update timestamp and maxval
    label_timestamp.config(text=f"Timestamp: {timestamp}")
    label_maxval.config(text=f"Maxval: {maxval}")
    window.update_idletasks()  # Force update of the GUI


# Function to handle spin box changes
def update_window_values():
    global x_window, y_window
    x_window = int(spin_x.get())
    y_window = int(spin_y.get())


# Set up the GUI
window = tk.Tk()
window.geometry('800x800')
window.title("Coincidence Counts")

# Spin boxes for x_window and y_window
frame_top = tk.Frame(window)
frame_top.pack(pady=10)

tk.Label(frame_top, text="X Window Length:", font=("Helvetica", 14)).grid(row=0, column=0, padx=10)
spin_x = tk.Spinbox(frame_top, from_=1, to=255, width=5, font=("Helvetica", 14), command=update_window_values)
spin_x.grid(row=0, column=1, padx=10)
spin_x.delete(0, "end")
spin_x.insert(0, str(x_window))

tk.Label(frame_top, text="Y Window Length:", font=("Helvetica", 14)).grid(row=0, column=2, padx=10)
spin_y = tk.Spinbox(frame_top, from_=1, to=255, width=5, font=("Helvetica", 14), command=update_window_values)
spin_y.grid(row=0, column=3, padx=10)
spin_y.delete(0, "end")
spin_y.insert(0, str(y_window))

# Labels for x and y counts
frame_counts = tk.Frame(window)
frame_counts.pack()

labels_x = []
labels_y = []
labels = ["A", "B", "C", "D", "AB", "AC", "AD", "BC", "BD", "CD", "ABC", "ABD", "ACD", "BCD", "ABCD"]
for i in range(15):
    label_x = tk.Label(frame_counts, text=f"X Window Count {labels[i]}: 0", font=("Helvetica", 14))
    label_x.grid(row=i, column=0, padx=10, pady=2)
    labels_x.append(label_x)

    label_y = tk.Label(frame_counts, text=f"Y Window Count {labels[i]}: 0", font=("Helvetica", 14))
    label_y.grid(row=i, column=1, padx=10, pady=2)
    labels_y.append(label_y)

# Labels for timestamp and maxval
label_timestamp = tk.Label(window, text="Timestamp: 0", font=("Helvetica", 16))
label_timestamp.pack(pady=10)

label_maxval = tk.Label(window, text="Maxval: 0", font=("Helvetica", 16))
label_maxval.pack(pady=10)

# Start the sending and receiving functions in background threads
send_thread = threading.Thread(target=send_window_data, daemon=True)
send_thread.start()

receive_thread = threading.Thread(target=receive_and_update, daemon=True)
receive_thread.start()


# Function to close the application
def on_closing():
    ser.close()  # Close the serial port
    window.quit()  # Close the GUI window


# Set up the close window protocol
window.protocol("WM_DELETE_WINDOW", on_closing)

# Start the Tkinter main loop
window.mainloop()