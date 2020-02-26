import java.awt.Color;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import com.tinkerforge.IPConnection;
import com.tinkerforge.BrickletOLED64x48;

public class ExampleScribble {
	private static final String HOST = "localhost";
	private static final int PORT = 4223;
	private static final String UID = "XYZ"; // Change XYZ to the UID of your OLED 64x48 Bricklet
	private static final short WIDTH = 64;
	private static final short HEIGHT = 48;

	static void drawImage(BrickletOLED64x48 oled, BufferedImage image) throws Exception {
		short[][] column = new short[6][WIDTH];
		short page = 0;
		short i, j, k;

		for (i = 0; i < HEIGHT/8; i++)
		{
			for (j = 0; j < WIDTH; j++)
			{
				page = 0;

				for (k = 0; k < 8; k++)
				{
					if ((image.getRGB(j, (i*8)+k) & 0x00FFFFFF) > 0)
					{
						page |= (short)(1 << k);
					}
				}
				column[i][j] = page;
			}
		}

		oled.newWindow((short)0, (short)(WIDTH-1), (short)0, (short)5);

		for (i = 0; i < HEIGHT/8; i++)
		{
			oled.write(column[i]);
		}
	}

	// Note: To make the example code cleaner we do not handle exceptions. Exceptions
	//       you might normally want to catch are described in the documentation
	public static void main(String args[]) throws Exception {
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletOLED64x48 oled = new BrickletOLED64x48(UID, ipcon); // Create device object

		ipcon.connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Clear display
		oled.clearDisplay();

		// Draw rotating line
		BufferedImage image = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_ARGB);
		int originX = WIDTH / 2;
		int originY = HEIGHT / 2;
		int length = HEIGHT / 2 - 2;
		int angle = 0;

		System.out.println("Press ctrl+c to exit");

		while (true) {
			double radians = Math.toRadians(angle);
			int x = (int)(originX + length * Math.cos(radians));
			int y = (int)(originY + length * Math.sin(radians));
			Graphics g = image.createGraphics();

			g.setColor(Color.black);
			g.fillRect(0, 0, WIDTH, HEIGHT);
			g.setColor(Color.white);
			g.drawLine(originX, originY, x, y);
			g.dispose();

			drawImage(oled, image);
			Thread.sleep(25);

			angle++;
		}
	}
}
