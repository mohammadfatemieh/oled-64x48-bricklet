using System;
using System.Drawing;
using System.Threading;
using Tinkerforge;

class Example
{
	private static string HOST = "localhost";
	private static int PORT = 4223;
	private static string UID = "XYZ"; // Change XYZ to the UID of your OLED 64x48 Bricklet
	private static int WIDTH = 64;
	private static int HEIGHT = 48;

	private static void DrawBitmap(BrickletOLED64x48 oled, Bitmap bitmap)
	{
		byte[][] pages = new byte[HEIGHT / 8][];

		for (int row = 0; row < HEIGHT / 8; row++)
		{
			pages[row] = new byte[WIDTH];

			for (int column = 0; column < WIDTH; column++)
			{
				pages[row][column] = 0;

				for (int bit = 0; bit < 8; bit++)
				{
					if (bitmap.GetPixel(column, (row * 8) + bit).GetBrightness() > 0)
					{
						pages[row][column] |= (byte)(1 << bit);
					}
				}
			}
		}

		oled.NewWindow(0, (byte)(WIDTH - 1), 0, (byte)(HEIGHT / 8 - 1));

		for (int row = 0; row < HEIGHT / 8; row++)
		{
			oled.Write(pages[row]);
		}
	}

	static void Main()
	{
		IPConnection ipcon = new IPConnection(); // Create IP connection
		BrickletOLED64x48 oled = new BrickletOLED64x48(UID, ipcon); // Create device object

		ipcon.Connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Clear display
		oled.ClearDisplay();

		// Draw rotating line
		Bitmap bitmap = new Bitmap(WIDTH, HEIGHT);
		int originX = WIDTH / 2;
		int originY = HEIGHT / 2;
		int length = HEIGHT / 2 - 2;
		int angle = 0;

		Console.WriteLine("Press enter to exit");

		while (!Console.KeyAvailable)
		{
			double radians = Math.PI * angle / 180.0;
			int x = (int)(originX + length * Math.Cos(radians));
			int y = (int)(originY + length * Math.Sin(radians));

			using (Graphics g = Graphics.FromImage(bitmap))
			{
				g.FillRectangle(Brushes.Black, 0, 0, WIDTH, HEIGHT);
				g.DrawLine(Pens.White, originX, originY, x, y);
			}

			DrawBitmap(oled, bitmap);
			Thread.Sleep(25);

			angle++;
		}

		Console.ReadLine();
		ipcon.Disconnect();
	}
}
