using Google.Cloud.Firestore;
using Grpc.Core;
using Grpc.Net.Client;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Server.Kestrel.Core;
using Microsoft.Extensions.Hosting;
using NetExchange;
using testService;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.Threading.Tasks;


namespace testService
{
    public class Program
    {
        private static GrpcChannel channel = GrpcChannel.ForAddress("http://localhost:5042");
        private static ExProto.ExProtoClient exchange = new ExProto.ExProtoClient(channel);
        internal static AsyncDuplexStreamingCall<RtuMessage, RtuMessage> rtuLink = exchange.MessageRtu();
        internal static AsyncDuplexStreamingCall<ExtMessage, ExtMessage> extLink = exchange.MessageExt();
        internal static AsyncDuplexStreamingCall<CmdMessage, CmdMessage> cmdLink = exchange.MessageCmd();
        
        internal static AsyncDuplexStreamingCall<ExMessage, ExMessage> exLink = exchange.ExLink(); //Mobile grpc Àü¿ë
        internal static AsyncDuplexStreamingCall<RtuMessage, RtuMessage> influxLink = exchange.influxDB(); //InfluxdDB Client Àü¿Ë

        public static void Main(string[] args)
        {
            GRPC.RpcService();
            CreateHostBuilder(args);
            ApplicationConfiguration.Initialize();
            Application.Run(new Form1());
        }
        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder => {
                    webBuilder.ConfigureKestrel(options => {
                        string localIP = "Not available, please check your network seetings!";
                        IPHostEntry host = Dns.GetHostEntry(Dns.GetHostName());
                        foreach (IPAddress ip in host.AddressList)
                        {
                            if (ip.AddressFamily == AddressFamily.InterNetwork)
                            {
                                localIP = ip.ToString();
                            }
                        }
                        System.Net.IPAddress ip2 = System.Net.IPAddress.Parse("172.20.2.72");
                        options.Listen(ip2, 5044, o => o.Protocols = HttpProtocols.Http2);
                        Debug.WriteLine(ip2);
                    });
                    webBuilder.UseStartup<Startup>();
                   
                });

        static private void addIP()
        {
            string localIP = "Not available, please check your network seetings!";
            IPHostEntry host = Dns.GetHostEntry(Dns.GetHostName());
            foreach (IPAddress ip in host.AddressList)
            {
                if (ip.AddressFamily == AddressFamily.InterNetwork)
                {
                    localIP = ip.ToString();
                }
            }
            System.Net.IPAddress ip1 = System.Net.IPAddress.Parse(localIP);
            Console.WriteLine(ip1);
            FirestoreDb db;
            string path = AppDomain.CurrentDomain.BaseDirectory + @"hometestproject-f01e6-firebase-adminsdk-z0oga-3d3578f7d5.json";
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", path);
            db = FirestoreDb.Create("hometestproject-f01e6");
            DocumentReference coll = db.Collection("IP").Document("local");
            Dictionary<string, string> data1 = new Dictionary<string, string>()
            {
                {"IP", ip1.ToString() }
            };
            coll.SetAsync(data1);
        }
    }
}