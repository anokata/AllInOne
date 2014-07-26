using System;
using System.Drawing;
using System.Threading;
using System.IO;
using SdlDotNet.Core;
using SdlDotNet.Input;
using SdlDotNet.Graphics;
using SdlDotNet.Graphics.Sprites;

namespace SdlDotNetExamples.SmallDemos
{
    public class FontExample : IDisposable
    {
        Surface text;
        Surface screen;
        int size = 12;
        int width = 640;
        int height = 480;
        SdlDotNet.Graphics.Font font;
		string filePath = Path.Combine("..", "..");
		string fileDirectory = "";//"Data";
		//string fileName = "FreeSans.ttf";
		string fileName = "DejaVuSansMono.ttf";
        Random rand = new Random();

        string[] textArray = { "Hello World!", "This is a test", "FontExample", "SDL.NET" };
        int[] styleArray = { 0, 1, 2, 4 };

        [STAThread]
        public static void Main()
        {
            FontExample t = new FontExample();
            t.Go();
        }

        public void Go()
        {
            if (File.Exists(fileName))
            {
                filePath = "";
                fileDirectory = "";
            }
            else if (File.Exists(Path.Combine(fileDirectory, fileName)))
            {
                filePath = "";
            }

            string file = Path.Combine(Path.Combine(filePath, fileDirectory), fileName);
			//Console.Write (file);
            Events.Tick +=
                new EventHandler<TickEventArgs>(Events_TickEvent);
            Events.KeyboardDown +=
                new EventHandler<KeyboardEventArgs>(this.KeyboardDown);
            Events.Quit += new EventHandler<QuitEventArgs>(this.Quit);

            font = new SdlDotNet.Graphics.Font(file, size);
            Video.WindowIcon();
            Video.WindowCaption = "SDL.NET - Font Example";
            screen = Video.SetVideoMode(width, height, true);

            Surface surf = screen.CreateCompatibleSurface(width, height, true);
            surf.Fill(new Rectangle(new Point(0, 0), surf.Size), Color.Black);
            Events.Run();
        }

        private void Events_TickEvent(object sender, TickEventArgs e)
        {
            try
            {
                font.Style = (Styles)styleArray[rand.Next(styleArray.Length)];
                text = font.Render(
                    textArray[rand.Next(textArray.Length)],
                    Color.FromArgb(0, (byte)rand.Next(255),
                    (byte)rand.Next(255), (byte)rand.Next(255)));

                switch (rand.Next(4))
                {
                    case 1:
                        text = text.CreateFlippedVerticalSurface();
                        break;
                    case 2:
                        text = text.CreateFlippedHorizontalSurface();
                        break;
                    case 3:
                        text = text.CreateRotatedSurface(rand.Next(360));
                        break;
                    default:
                        break;
                }

                screen.Blit(
                    text,
                    new Rectangle(new Point(rand.Next(width - 100), rand.Next(height - 100)),
                    text.Size));
                screen.Update();
                Thread.Sleep(500);
            }
            catch
            {
                //sdl.Dispose();
				Console.Write ("error");
                throw;
            }
        }

        private void KeyboardDown(object sender, KeyboardEventArgs e)
        {
            // Check if the key pressed was a Q or Escape
            if (e.Key == Key.Escape || e.Key == Key.Q)
            {
                Events.QuitApplication();
            }
        }

        private void Quit(object sender, QuitEventArgs e)
        {
            Events.QuitApplication();
        }

        public static string Title
        {
            get
            {
                return "F";
            }
        }

        #region IDisposable Members

        private bool disposed;

        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    if (this.font != null)
                    {
                        this.font.Dispose();
                        this.font = null;
                    }
                }
                this.disposed = true;
            }
        }

        public void Dispose()
        {
            this.Dispose(true);
            GC.SuppressFinalize(this);
        }

        public void Close()
        {
            Dispose();
        }

        ~FontExample()
        {
            Dispose(false);
        }

        #endregion
    }
}
