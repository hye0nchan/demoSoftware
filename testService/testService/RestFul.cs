using Google.Protobuf;
using NetExchange;
using System.Diagnostics;
using System.Net;

namespace testService
{
    internal class RestFul
    {
        HttpListener? httpListener;

        public void serverInit()
        {
            if (httpListener == null)
            {
                httpListener = new HttpListener();
                httpListener.Prefixes.Add(string.Format("http://+:8686/"));
                serverStart();
            }
        }

        private void serverStart()
        {
            if (!httpListener.IsListening)
            {
                httpListener.Start();
                Form1.f1.richTextBox1.Text = "Server is started";
                Task.Factory.StartNew(async () => {
                    while (httpListener != null)
                    {
                        HttpListenerContext context = this.httpListener.GetContext();
                        string rawurl = context.Request.RawUrl;
                        string httpmethod = context.Request.HttpMethod;
                        string httpMethod = "";
                        string control = "";
                        httpMethod += string.Format("httpmethod = {0}\r\n", httpmethod);
                        control = rawurl;
                        if (Form1.f1.richTextBox1.InvokeRequired) Form1.f1.richTextBox1.Invoke(
                             new MethodInvoker(
                                 delegate {
                                     Form1.f1.richTextBox1.Text = httpMethod;
                                     Form1.f1.richTextBox1.Text += control;
                                 }));
                        else Form1.f1.richTextBox1.Text = httpMethod;
                        context.Response.Close();
                        if (control == "/test")
                        {
                            Debug.WriteLine("enter /test");
                            byte protocol = 100;
                            byte[] data = new byte[] { 0x01, 0x03, 0x00, 0xCB, 0x00, 0x52, 0xAD, 0xDE };

                            RtuMessage request = new RtuMessage();
                            request.GwId = 0;
                            request.DataUnit = ByteString.CopyFrom(data[0..data.Length]);
                            request.DeviceId = 0x4C75258912F5;
                            request.SequenceNumber = 0;
                            request.Channel = ((UInt32)0 << 8) | protocol;
                            await Program.rtuLink.RequestStream.WriteAsync(request);
                        }
                    }
                });
            }
        }
    }
}
