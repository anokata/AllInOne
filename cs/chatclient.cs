using System;
using System.IO;
using System.Net.Sockets;
using System.Drawing;
using System.Windows.Forms;
using System.Threading;

public class Client : Form
{
    // Элементы формы
    private System.Windows.Forms.TextBox multiLineBox;
    private System.Windows.Forms.TextBox messageBox;
    private System.Windows.Forms.TextBox ipBox;
    private System.Windows.Forms.Button sendButton;
    private System.Windows.Forms.Button connectButton;
    private TcpClient tcp;
    private System.Net.Sockets.NetworkStream stream;

    static public void Main()
    {
        // Запуск приложения
        Application.Run(new Client());
    }
 
    // Конструктор
    public Client()
    {
        // Создаём элементы формы
        this.connectButton = new Button();
        connectButton.Text = "Connect";
        // Привязываем процедуру нажатия кнопки
        connectButton.Click += new EventHandler(Connect_Click);
        // Добавляем кнопку на форму
        Controls.Add(connectButton);
        // Устанавливаем позицию кнопки
        this.connectButton.Location = new System.Drawing.Point(10, 10);

        // Создаём кнопку Send
        this.sendButton = new Button();
        sendButton.Text = "Send";
        sendButton.Click += new EventHandler(Send_Click);
        Controls.Add(sendButton);
        this.sendButton.Location = new System.Drawing.Point(230, 280);

        // Создаём поле для вывода
        this.multiLineBox = new System.Windows.Forms.TextBox();
        this.multiLineBox.AcceptsReturn = true;
        this.multiLineBox.AcceptsTab = true;
        this.multiLineBox.Location = new System.Drawing.Point(10, 50);
        this.multiLineBox.Multiline = true;
        this.multiLineBox.Name = "multiLineBox";
        this.multiLineBox.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
        this.multiLineBox.Size = new System.Drawing.Size(340, 204);
        this.multiLineBox.TabIndex = 0;
        this.multiLineBox.Text = "";
        this.Controls.Add(this.multiLineBox);
        
        // Создаём поле для ввода IP
        this.ipBox = new System.Windows.Forms.TextBox();
        this.Controls.Add(this.ipBox);
        this.ipBox.Location = new System.Drawing.Point(100, 10);
        this.ipBox.Size = new Size(200, 20);
        this.ipBox.Text = "127.0.0.1";

        // Создаём поле для ввода сообщения
        this.messageBox = new System.Windows.Forms.TextBox();
        this.Controls.Add(this.messageBox);
        this.messageBox.Location = new System.Drawing.Point(10, 280);
        this.messageBox.Size = new Size(200, 20);

        // Запускаем поток чтения
        Thread readThread = new Thread(new ParameterizedThreadStart(Read));
        readThread.Start(null);
        // Изменяем размер формы
        Size = new Size(500,400);
    }

    // Процедура чтения данных от сервера
    private void Read(object o) 
    {
        while (true) {
            if (stream == null) continue;
            int i;
            Byte[] bytes = new Byte[256];
            String data = null;
            if (stream.CanRead) {
                // Считываем данные из потока 
                i = stream.Read(bytes, 0, bytes.Length); 
                data = System.Text.Encoding.ASCII.GetString(bytes, 0, i);
                // Добавляем считанную строку в лог
                this.multiLineBox.Text += data;
            }
        }
    }
 
    // Процедура соединения с сервером
    private void Connect_Click(object sender, EventArgs e)
    {
        // Создаём подключение к серверу и потоки ввода вывода
        this.tcp = new TcpClient(this.ipBox.Text, 4004);this.tcp = new TcpClient(this.ipBox.Text, 4004);
        stream = tcp.GetStream();
        StreamWriter writer = new StreamWriter(tcp.GetStream());

        // Создаём случайное имя гостя
        Random rand = new Random();
        String name = "guest_" + rand.Next();
        writer.Write(name + "\r\n");
        writer.Flush();
        
        // Запись соединения в лог
        this.multiLineBox.Text += "Connected as " + name + "\r\n";
    }
    
    // Процедура отправки сообщения
    private void Send_Click(object sender, EventArgs e)
    {
        // Создаём поток записи для соединения с сервером
        StreamWriter writer = new StreamWriter(tcp.GetStream());
 
        // Записываем текст из поля ввода
        writer.Write(this.messageBox.Text + "\r\n");
        writer.Flush();
        // Добавляем запись о сообщении в лог
        this.multiLineBox.Text += "you> " + this.messageBox.Text + "\r\n";
    }
}


