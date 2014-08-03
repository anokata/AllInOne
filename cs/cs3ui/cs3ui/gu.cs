using System;
using System.IO;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;

namespace MWFTestApplication {
	class MainWindow : System.Windows.Forms.Form {	
		static Label label;
		static TextBox text;
		RichTextBox text2;
		public MainWindow() {

			ClientSize = new System.Drawing.Size (450, 450);

			label = new Label();
			label.Text = "A: ";
			label.Dock = DockStyle.Bottom;
			label.TextAlign = ContentAlignment.MiddleCenter;
			this.Controls.Add(label);
			Text = "E/";
			text = new TextBox ();
			text.Dock = DockStyle.Fill;
			text.Size = new System.Drawing.Size(200, 200);
			text.Multiline = true;
			text.Font = new System.Drawing.Font("Monospace", 13F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
			text.Text = "some";
			text.Location = new System.Drawing.Point(10, 10);
			text.Enabled = true;
			text.AutoCompleteMode = AutoCompleteMode.Suggest;
			text.KeyDown += keydownText;
			text.KeyPress += keypressText;
			this.Controls.Add (text);

		}

		static void keydownText (object s, KeyEventArgs e){
			MainWindow.label.Text = e.KeyValue.ToString();
			//e.SuppressKeyPress
			e.Handled = true;
		}
		static void keypressText (object s, KeyPressEventArgs e){
			MainWindow.label.Text += e.KeyChar;
			//e.SuppressKeyPress
			e.Handled = true;
		}

		public static void Main(string[] args) {
			Application.Run(new MainWindow());
		}
	}
}
