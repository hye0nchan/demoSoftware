public class RestApi
{
    public RestApi()
    {
        HttpListener httpListener;

        private void serverInit()
        {
            if (httpListener == null)
            {
                httpListener = new HttpListener();
                httpListener.Prefixes.Add(string.Format("http://+:8686/"));
                serverStart();
            }
        }
    }

    private void serverStart()
    {
        if (!httpListener.IsListening)
        {
            httpListener.Start();
            richTextBox1.Text = "Server is started";
            Task.Factory.StartNew(() =>
            {
                while (httpListener != null)
                {
                    HttpListenerContext context = this.httpListener.GetContext();


                    string rawurl = context.Request.RawUrl;
                    string httpmethod = context.Request.HttpMethod;

                    string result = "";

                    result += string.Format("httpmethod = {0}\r\n", httpmethod);
                    result += string.Format("rawurl = {0}\r\n", rawurl);


                    if (richTextBox1.InvokeRequired)
                        richTextBox1.Invoke( new MethodInvoker(delegate {richTextBox1.Text = result;}));
                    else
                        richTextBox1.Text = result;

                    context.Response.Close();
                }
            });
        }
    }

}
