function octave_example_pixel_matrix()
    more off;

    HOST = "localhost";
    PORT = 4223;
    UID = "XYZ"; % Change to your UID
    SCREEN_WIDTH = 64;
    SCREEN_HEIGHT = 48;

    function draw_matrix(oled, pixels)
        SCREEN_WIDTH = 64;
        SCREEN_HEIGHT = 48;
        column = cell(1, SCREEN_HEIGHT/8);
        for i = 1:(SCREEN_HEIGHT/8) - 1
            column{i} = zeros(1, 64);
            for j = 1:SCREEN_WIDTH
                page = 0;
                for k = 0:7
                    if pixels(i*8 + k, j) == true
                        page = bitor(page, bitshift(1, k));
                    end
                end
                column{i}(j) = page;
            end
        end
        oled.newWindow(0, SCREEN_WIDTH-1, 0, 5);
        for i = 1:(SCREEN_HEIGHT/8) - 1
            oled.write(column{i});
        end
    end

    ipcon = java_new("com.tinkerforge.IPConnection"); % Create IP connection
    oled = java_new("com.tinkerforge.BrickletOLED64x48", UID, ipcon); % Create device object

    ipcon.connect(HOST, PORT); % Connect to brickd
    % Don't use device before ipcon is connected

    % Clear display
    oled.clearDisplay();

    % Draw checkerboard pattern
    pixel_matrix = false(SCREEN_HEIGHT, SCREEN_WIDTH);

    for h = 1:SCREEN_HEIGHT
        for w = 1:SCREEN_WIDTH
            pixel_matrix(h, w) = mod(floor(h / 8), 2) == mod(floor(w / 8), 2);
        end
    end

    draw_matrix(oled, pixel_matrix);

    input("Press key to exit\n", "s");
    ipcon.disconnect();
end
