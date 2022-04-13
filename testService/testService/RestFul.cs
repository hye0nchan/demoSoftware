using NetExchange;
using System.Net;

namespace testService
{
    internal class RestFul
    {
        GRPC grpc = new GRPC();
        HttpListener httpListener;


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


                        switch (control)
                        {
                            case "/seonsor1":
                                await grpc.sensor1Async();
                                break;
                            case "/lamp/on":
                                await grpc.switchFirstOnAsync("lamp");
                                break;
                            case "/lamp/off":
                                await grpc.switchFirstOffAsync("lamp");
                                break;
                            case "/fan/on":
                                await grpc.switchSecondOnAsync("fan");
                                break;
                            case "/fan/off":
                                await grpc.switchSecondOffAsync("fan");
                                break;
                        }
                    }

                });
            }
        }
    }
}
