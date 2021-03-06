<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletOLED64x48.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletOLED64x48;

const HOST = 'localhost';
const PORT = 4223;
const UID = 'XYZ'; // Change XYZ to the UID of your OLED 64x48 Bricklet

$ipcon = new IPConnection(); // Create IP connection
$oled = new BrickletOLED64x48(UID, $ipcon); // Create device object

$ipcon->connect(HOST, PORT); // Connect to brickd
// Don't use device before ipcon is connected

// Clear display
$oled->clearDisplay();

// Write "Hello World" starting from upper left corner of the screen
$oled->writeLine(0, 0, 'Hello World');

echo "Press key to exit\n";
fgetc(fopen('php://stdin', 'r'));
$ipcon->disconnect();

?>
