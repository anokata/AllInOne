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
        int size = 14;
        int width = 640;
        int height = 480;
        SdlDotNet.Graphics.Font font;
		string filePath = Path.Combine("..", "..");
		string fileDirectory = "";
		//string fileName = "FreeSans.ttf";
		string fileName = "DejaVuSansMono.ttf";
        Random rand = new Random();
		string eventText = String.Empty;
		int curY = 0;

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
            //Events.Tick +=
              //  new EventHandler<TickEventArgs>(Events_TickEvent);
            Events.KeyboardDown +=
                new EventHandler<KeyboardEventArgs>(this.KeyboardDown);
            Events.Quit += new EventHandler<QuitEventArgs>(this.Quit);
			//Events.KeyboardUp
            font = new SdlDotNet.Graphics.Font(file, size);
            Video.WindowIcon();
            Video.WindowCaption = "[NOITPAC]";
            screen = Video.SetVideoMode(width, height, true);

            Surface surf = screen.CreateCompatibleSurface(width, height, true);
            surf.Fill(new Rectangle(new Point(0, 0), surf.Size), Color.White);
            Events.Run();
        }

        private void Events_TickEvent(object sender, TickEventArgs e)
        {
                screen.Update();
                Thread.Sleep(500);
        }

        private void KeyboardDown(object sender, KeyboardEventArgs e)
        {
            // Check if the key pressed was a Q or Escape
            if (e.Key == Key.Escape || e.Key == Key.Q)
            {
                Events.QuitApplication();
            }
			eventText = "key: " + e.Key.ToString () + " char? " + e.KeyboardCharacter;
			font.Style = Styles.Bold;
			text = font.Render(eventText, Color.LightBlue, true);
			screen.Blit(text,new Rectangle(new Point(0, curY), text.Size));
			screen.Update();
			curY += 20;
        }

        private void Quit(object sender, QuitEventArgs e)
        {
            Events.QuitApplication();
        }

        public static string Title
        {
            get
            {
                return "[ELTIT]";
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
