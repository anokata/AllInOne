using System;
using System.Collections.Generic;
using System.Net.Sockets;
using System.Text;
using System.Threading;
 
namespace ChatServer {
    
    // Класс 
    class State {
        private TcpClient client;
        private StringBuilder sb = new StringBuilder();
 
        public string Name { get; }
 
        // Конструктор объекта State
        public State(string name, TcpClient client) {
            // Сохраняем имя и объект сокета клиента в полях объекта
            Name = name;
            this.client = client;
        }
 
        // Процедура отправки текста этому клиенту
        public void Send(string text) {
            // Преобразуем строку в массив байт
            var bytes = Encoding.ASCII.GetBytes(string.Format("{0}\r\n", text));
            // Отправляем массив байт данному клиенту
            client.GetStream().Write(bytes, 0, bytes.Length);
        }
    }
 
    class Program {
        static TcpListener listen;
        static Thread serverthread;
        static Dictionary<int, State> connections = new Dictionary<int, State>();
 
        static void Main(string[] args) {
            // Создаём сокет для входящих соединений
            listen = new TcpListener(System.Net.IPAddress.Any, 4004);
            // Создаём поток обработки входящих соединений
            serverthread = new Thread(new ThreadStart(DoListen));
            // Запускаем поток
            serverthread.Start();
        }
        // Процедура обработки входящих соединений
        private static void DoListen() {
            // Запуск сокета
            listen.Start();
            Console.WriteLine("Server: Started server");
 
            while (true) {
                Console.WriteLine("Server: Waiting...");
                // Получение клиентского соединения
                TcpClient client = listen.AcceptTcpClient();
                Console.WriteLine("Server: Waited");
 
                // Создаём поток обработки этого клиента
                Thread clientThread = new Thread(new ParameterizedThreadStart(DoClient));
                // Запускаем этот поток
                clientThread.Start(client);
            }
        }
        // Процедура обработки клиента
        private static void DoClient(object client) {
            // Преобразуем параметр client к типу TcpClient
            TcpClient tClient = (TcpClient)client;
            Console.WriteLine("Client (Thread: {0}): Connected!", Thread.CurrentThread.ManagedThreadId);
            
            byte[] bytes = null;
            string name = string.Empty;
            // Если клиент не подсоединён
            if (!tClient.Connected) {
                Console.WriteLine("Client (Thread: {0}): Terminated!", Thread.CurrentThread.ManagedThreadId);
                // Закрываем сокет клиента
                tClient.Close();
                // Завершаем поток
                Thread.CurrentThread.Abort();
            }

            // Получаем имя клиента
            name = Receive(tClient);
 
            // Добавляем имя клиента и его сокет в словарь под ID потока
            connections.Add(Thread.CurrentThread.ManagedThreadId, new State(name, tClient));
            Console.WriteLine("\tTotal connections: {0}", connections.Count);
            // Объявляем всем клиентам о прибытии нового клиента
            Broadcast(string.Format("+++ {0} arrived +++", name));
 
            do {
                // Получаем данные от клиента
                string text = Receive(tClient);
                // Если клиент прислал команду завершения
                if (text == "/quit") {
                    // Объявляем всем клиентам об отсоединении клиента
                    Broadcast(string.Format("Connection from {0} closed.", name));
                    // Удаляем запись из словаря об этом клиенте
                    connections.Remove(Thread.CurrentThread.ManagedThreadId);
                    Console.WriteLine("\tTotal connections: {0}", connections.Count);
                    break;
                }
                // Если клиент не подсоединён
                if (!tClient.Connected) {
                    // Завершаем
                    break;
                }
                // Объявляем всем клиентам о новом сообщении данного клиента
                Broadcast(string.Format("{0}> {1}", name, text));
            } while (true);
 
            Console.WriteLine("Client (Thread: {0}): Terminated!", Thread.CurrentThread.ManagedThreadId);
            // Закрываем сокет клиента
            tClient.Close();
            // Завершаем поток
            Thread.CurrentThread.Abort();
        }
 
        // Функция получения данных клиента
        private static string Receive(TcpClient client) {
            StringBuilder sb = new StringBuilder(); // Аккумулятор данных
            do {
                // Если у клиента доступны данные
                if (client.Available > 0) {
                    // Пока есть данные
                    while (client.Available > 0) {
                        // Читаем байт из потока сокета клиента
                        char ch = (char)client.GetStream().ReadByte();
                        // Если байт - перевод строки то игнорируем
                        if (ch == '\r') {
                            continue;
                        }
                        // Если байт - символ новой строки, то возвращаем данные в виде строки
                        if (ch == '\n') {
                            return sb.ToString();
                        }
                        // Добавляем байт к строке
                        sb.Append(ch);
                    }
                }
                // Пауза на 100 мс
                Thread.Sleep(100);
            } while (true);
        }
        
        // Процедура оповещения всех клиентов
        private static void Broadcast(string text) {
            Console.WriteLine(text);
            // Для каждого клиента
            foreach (var oClient in connections) {
                // Если это не текущий клиент
                if (oClient.Key != Thread.CurrentThread.ManagedThreadId) {
                    State state = oClient.Value;
                    // Отсылаем текст клиенту
                    state.Send(text);
                }
            }
        }
    }
}
