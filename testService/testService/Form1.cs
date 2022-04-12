namespace testService
{
    public partial class Form1 : Form
    {
        public static Form1? f1;
        RestFul rest = new RestFul();


        public Form1()
        {
            InitializeComponent();
            f1 = this;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            rest.serverInit();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            GRPC.RpcService();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }
    }
}