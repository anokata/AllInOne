using System;
using System.IO;
using System.Net.Sockets;
using System.Drawing;
using System.Windows.Forms;

public class Client : Form
{
    private System.Windows.Forms.TextBox multiLineBox;
    private System.Windows.Forms.TextBox messageBox;
    private System.Windows.Forms.Button sendButton;
    private System.Windows.Forms.Button connectButton;
    private TcpClient tcp;

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
    }

    private void read() 
    {
        int i;
        Byte[] bytes = new Byte[256];
        String data = null;
        var stream = tcp.GetStream();
        i = stream.Read(bytes, 0, bytes.Length);
        data = System.Text.Encoding.ASCII.GetString(bytes, 0, i);
        this.multiLineBox.Text += data;
    }
 
    private void Connect_Click(object sender, EventArgs e)
    {
        this.tcp = new TcpClient("localhost", 4004);
        read();
        StreamWriter writer = new StreamWriter(tcp.GetStream());
        writer.Write("alice\n");
        //writer.Flush();
    }

    private void Send_Click (object sender, EventArgs e)
    {
        StreamWriter writer = new StreamWriter(tcp.GetStream());
 
        writer.Write(this.messageBox.Text + "\n");
        //writer.Flush();
        read();
 
    }
        //tcp.Close();
}


