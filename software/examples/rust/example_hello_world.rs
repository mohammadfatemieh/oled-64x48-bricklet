use std::{error::Error, io};

use tinkerforge::{ip_connection::IpConnection, oled_64x48_bricklet::*};

const HOST: &str = "localhost";
const PORT: u16 = 4223;
const UID: &str = "XYZ"; // Change XYZ to the UID of your OLED 64x48 Bricklet.

fn main() -> Result<(), Box<dyn Error>> {
    let ipcon = IpConnection::new(); // Create IP connection.
    let oled = Oled64x48Bricklet::new(UID, &ipcon); // Create device object.

    ipcon.connect((HOST, PORT)).recv()??; // Connect to brickd.
                                          // Don't use device before ipcon is connected.

    // Clear display
    oled.clear_display().recv()?;

    // Write "Hello World" starting from upper left corner of the screen
    oled.write_line(0, 0, "Hello World".to_string()).recv()?;

    println!("Press enter to exit.");
    let mut _input = String::new();
    io::stdin().read_line(&mut _input)?;
    ipcon.disconnect();
    Ok(())
}
