using System;
using System.IO;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
/*=======TODO============================
 * 1. SyntaxColor
 * 1.1 поменять у части текста цвет\стиль
 * 2. рог на datagrid?
 *
/*==============================================*/
namespace MWFTestApplication {
	class MainWindow : System.Windows.Forms.Form {	
		static Label label;
		static TextBox text;
		RichTextBox text2;
		enum ModKeys {Nok, Ctrl, Shift};
		static ModKeys mkeys = ModKeys.Nok;
		static bool ctrl = false;
		static char k;

		public MainWindow() {

			ClientSize = new System.Drawing.Size (450, 450);

			label = new Label();
			label.Text = "A: ";
			label.Dock = DockStyle.Top;
			label.TextAlign = ContentAlignment.MiddleCenter;
			this.Controls.Add(label);
			Text = "E/";
			text = new TextBox ();
			text.Dock = DockStyle.Left;
			text.Size = new System.Drawing.Size(200, 200);
			text.Multiline = true;
			text.Font = new System.Drawing.Font("Monospace", 13F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			text.Text = "some";
			//text.Location = new System.Drawing.Point(10, 10);
			text.Enabled = true;
			text.AutoCompleteMode = AutoCompleteMode.Suggest;
			text.KeyDown += keydownText;
			text.KeyPress += keypressText;
			this.Controls.Add (text);

			text2 = new RichTextBox ();
			text2.Dock = DockStyle.Right;
			text2.Multiline = true;
			text2.Font = new System.Drawing.Font("Monospace", 13F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			this.Controls.Add (text2);
			text2.Text = "asdf asdf afs asf ";
			text2.Select (2, 3);
			text2.Font = new Font("Consolas", 18f, FontStyle.Bold);
			text2.BackColor = Color.AliceBlue;
			Color[] colors =
			{
				Color.Aqua,
				Color.CadetBlue,
				Color.Cornsilk,
				Color.Gold,
				Color.HotPink,
				Color.Lavender,
				Color.Moccasin
			};

		}

		static void keydownText (object s, KeyEventArgs e){
			MainWindow.label.Text = e.KeyValue.ToString();
			if (e.Control)
				MainWindow.mkeys = ModKeys.Ctrl;
			else
				MainWindow.mkeys = ModKeys.Nok;
			ctrl = e.Shift;

			//e.SuppressKeyPress
			//e.Handled = true;
		}
		static void keypressText (object s, KeyPressEventArgs e){
			MainWindow.label.Text += e.KeyChar;
			if (MainWindow.mkeys != ModKeys.Ctrl)
				MainWindow.label.Text += "C";

			//e.SuppressKeyPress
			k = e.KeyChar;
			e.Handled = MainWindow.mkeys != ModKeys.Ctrl;
			e.Handled = ! ctrl;

		}

		public static void Main(string[] args) {
			Application.Run(new MainWindow());
		}
	}
}
