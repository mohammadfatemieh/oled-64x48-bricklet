#!/usr/bin/perl

use strict;
use Tinkerforge::IPConnection;
use Tinkerforge::BrickletOLED64x48;

use constant HOST => 'localhost';
use constant PORT => 4223;
use constant UID => 'XYZ'; # Change XYZ to the UID of your OLED 64x48 Bricklet
use constant WIDTH => 64;
use constant HEIGHT => 48;

my $ipcon = Tinkerforge::IPConnection->new(); # Create IP connection
my $oled = Tinkerforge::BrickletOLED64x48->new(&UID, $ipcon); # Create device object

sub draw_matrix
{
    my ($oled, $pixels_ref) = @_;
    my @pixels = @{$pixels_ref};
    my @pages = ();

    foreach my $row (0..&HEIGHT / 8 - 1) {
        $pages[$row] = ();

        foreach my $column (0..&WIDTH - 1) {
            $pages[$row][$column] = 0;

            foreach my $bit (0..7) {
                if ($pixels[($row * 8) + $bit][$column]) {
                    $pages[$row][$column] |= 1 << $bit;
                }
            }
        }
    }

    $oled->new_window(0, &WIDTH - 1, 0, &HEIGHT / 8 - 1);

    foreach my $row (0..&HEIGHT / 8 - 1) {
        $oled->write($pages[$row]);
    }
}

$ipcon->connect(&HOST, &PORT); # Connect to brickd
# Don't use device before ipcon is connected

# Clear display
$oled->clear_display();

# Draw checkerboard pattern
my @pixels = ();

foreach my $row (0..&HEIGHT - 1) {
    $pixels[$row] = ();

    foreach my $column (0..&WIDTH - 1) {
        $pixels[$row][$column] = (($row / 8) % 2) == (($column / 8) % 2);
    }
}

draw_matrix($oled, \@pixels);

print "Press key to exit\n";
<STDIN>;
$ipcon->disconnect();
