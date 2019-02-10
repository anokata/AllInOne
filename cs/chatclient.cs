using System;
using System.IO;
using System.Net.Sockets;
using System.Drawing;
using System.Windows.Forms;
using System.Threading;

public class Client : Form
{
    private System.Windows.Forms.TextBox multiLineBox;
    private System.Windows.Forms.TextBox messageBox;
    private System.Windows.Forms.Button sendButton;
    private System.Windows.Forms.Button connectButton;
    private TcpClient tcp;
    private System.Net.Sockets.NetworkStream stream;

    static public void Main ()
    {
        Application.Run (new Client());
    }
 
    public Client()
    {
        this.connectButton = new Button();
        connectButton.Text = "Connect";
        connectButton.Click += new EventHandler(Connect_Click);
        Controls.Add(connectButton);
        this.connectButton.Location = new System.Drawing.Point(10, 10);

        this.sendButton = new Button();
        sendButton.Text = "Send";
        sendButton.Click += new EventHandler(Send_Click);
        Controls.Add(sendButton);
        this.sendButton.Location = new System.Drawing.Point(10, 280);

        this.multiLineBox = new System.Windows.Forms.TextBox();
        this.multiLineBox.AcceptsReturn = true;
        this.multiLineBox.AcceptsTab = true;
        this.multiLineBox.Location = new System.Drawing.Point(200, 10);
        this.multiLineBox.Multiline = true;
        this.multiLineBox.Name = "multiLineBox";
        this.multiLineBox.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
        this.multiLineBox.Size = new System.Drawing.Size(240, 104);
        this.multiLineBox.TabIndex = 0;
        this.multiLineBox.Text = "";
        this.Controls.Add(this.multiLineBox);

        this.messageBox = new System.Windows.Forms.TextBox();
        this.Controls.Add(this.messageBox);
        this.messageBox.Location = new System.Drawing.Point(150, 280);
        Thread readThread = new Thread(new ParameterizedThreadStart(read));
        readThread.Start(null);
    }

    private void read(object o) 
    {
        while (true) {
            if (stream == null) continue;
            //Console.WriteLine("read 2");
            int i;
            Byte[] bytes = new Byte[256];
            String data = null;
            if (stream.CanRead) {
                i = stream.Read(bytes, 0, bytes.Length); 
                data = System.Text.Encoding.ASCII.GetString(bytes, 0, i);
                this.multiLineBox.Text += data;
            }
        }
    }
 
    private void Connect_Click(object sender, EventArgs e)
    {
        this.tcp = new TcpClient("localhost", 4004);
        stream = tcp.GetStream();
        StreamWriter writer = new StreamWriter(tcp.GetStream());

        Random rand = new Random();
        String name = "guest_" + rand.Next();
        writer.Write(name + "\n");

        writer.Flush();
        this.multiLineBox.Text += "Connected as " + name + "\n";
    }

    private void Send_Click (object sender, EventArgs e)
    {
        StreamWriter writer = new StreamWriter(tcp.GetStream());
 
        writer.Write(this.messageBox.Text + "\n");
        writer.Flush();
        this.multiLineBox.Text += "you> " + this.messageBox.Text + "\n";
    }
}


