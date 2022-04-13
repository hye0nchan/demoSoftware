using Google.Protobuf;
using Grpc.Core;
using Grpc.Net.Client;
using NetExchange;
using System.Diagnostics;

namespace testService
{
    internal class GRPC
    {
        private static GrpcChannel channel = GrpcChannel.ForAddress("http://localhost:5042");
        private static ExProto.ExProtoClient exchange = new ExProto.ExProtoClient(channel);
        internal static AsyncDuplexStreamingCall<RtuMessage, RtuMessage> rtuLink = exchange.MessageRtu();
        internal static AsyncDuplexStreamingCall<ExtMessage, ExtMessage> extLink = exchange.MessageExt();
        internal static AsyncDuplexStreamingCall<CmdMessage, CmdMessage> cmdLink = exchange.MessageCmd();

        internal static AsyncDuplexStreamingCall<ExMessage, ExMessage> exLink = exchange.ExLink(); //Mobile grpc 전용
        internal static AsyncDuplexStreamingCall<RtuMessage, RtuMessage> influxLink = exchange.influxDB(); //InfluxdDB Client 전옹

        ushort opid = 0;
        byte protocol = 100;
        ulong DeviceId = 0x4C7525C1Cf81;

        private void switchDevice(string switchName)
        {
            switch (switchName)
            {
                case "pump":
                    DeviceId = 0x500291A40A61;
                    break;
                case "fan":
                    DeviceId = 0x4C7525C1Cf81;
                    break;
                case "lamp":
                    DeviceId = 0x4C7525C1Cf81;
                    break;
                case "outFan":
                    DeviceId = 0x4C7525C1CF71;
                    break;

            }
        }

        public async Task switchFirstOnAsync(string switchName)
        {
            switchDevice(switchName);
            byte[] data = new byte[] {
                0x01,
                0x10,
                0x01,
                0xF7,
                0x00,
                0x04,
                0x08,
                0x00,
                0xC9,
                (byte)(opid>>8),
                (byte)opid,
                0x00,
                0x00,
                0x00,
                0x00,
                0xAD,
                0xDE
            };
            opid++;
            RtuMessage request = new RtuMessage();
            request.GwId = 0;
            request.DataUnit = ByteString.CopyFrom(data[0..data.Length]);
            request.DeviceId = DeviceId;
            request.SequenceNumber = 0;
            request.Channel = ((UInt32)0 << 8) | protocol;
            await Program.rtuLink.RequestStream.WriteAsync(request);
        }

        public async Task switchFirstOffAsync(string switchName)
        {
            switchDevice(switchName);
            byte[] data = new byte[] {
                0x01,
                0x10,
                0x01,
                0xF7,
                0x00,
                0x04,
                0x08,
                0x00,
                0x00,
                (byte)(opid>>8),
                (byte)opid,
                0x00,
                0x00,
                0x00,
                0x00,
                0xAD,
                0xDE
            };
            opid++;
            RtuMessage request = new RtuMessage();
            request.GwId = 0;
            request.DataUnit = ByteString.CopyFrom(data[0..data.Length]);
            request.DeviceId = DeviceId;
            request.SequenceNumber = 0;
            request.Channel = ((UInt32)0 << 8) | protocol;
            await Program.rtuLink.RequestStream.WriteAsync(request);
        }

        public async Task switchSecondOnAsync(string switchName)
        {
            switchDevice(switchName);
            byte[] data = new byte[] {
                0x01,
                0x10,
                0x01,
                0xFB,
                0x00,
                0x04,
                0x08,
                0x00,
                0xC9,
                (byte)(opid>>8),
                (byte)opid,
                0x00,
                0x00,
                0x00,
                0x00,
                0xAD,
                0xDE
            };
            opid++;
            RtuMessage request = new RtuMessage();
            request.GwId = 0;
            request.DataUnit = ByteString.CopyFrom(data[0..data.Length]);
            request.DeviceId = DeviceId;
            request.SequenceNumber = 0;
            request.Channel = ((UInt32)0 << 8) | protocol;
            await Program.rtuLink.RequestStream.WriteAsync(request);
        }

        public async Task switchSecondOffAsync(string switchName)
        {
            switchDevice(switchName);
            byte[] data = new byte[] {
                0x01,
                0x10,
                0x01,
                0xFB,
                0x00,
                0x04,
                0x08,
                0x00,
                0x00,
                (byte)(opid>>8),
                (byte)opid,
                0x00,
                0x00,
                0x00,
                0x00,
                0xAD,
                0xDE
            };
            opid++;
            RtuMessage request = new RtuMessage();
            request.GwId = 0;
            request.DataUnit = ByteString.CopyFrom(data[0..data.Length]);
            request.DeviceId = DeviceId;
            request.SequenceNumber = 0;
            request.Channel = ((UInt32)0 << 8) | protocol;
            await Program.rtuLink.RequestStream.WriteAsync(request);
        }

        public async Task sensor1Async()
        {
            Debug.WriteLine("enter sensor");
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

        public static void RpcService()
        {

            _ = Task.Run(async () => {

                while (await rtuLink.ResponseStream.MoveNext(cancellationToken: CancellationToken.None))
                {
                    RtuMessage response = rtuLink.ResponseStream.Current; // From Server
                    IServerStreamWriter<RtuMessage>? responseStream = testService.responseStreamRtu;
                    IServerStreamWriter<RtuMessage>? responseStream_flutter = testService.responseStreamFlutter;
                    //InfluxDB
                    IServerStreamWriter<RtuMessage>? responseStream_influxDB = testService.responseStreamInflux;

                    var protocol = (byte)response.Channel;
                    Debug.WriteLine(protocol);
                    if (responseStream != null || responseStream_flutter != null)
                    {
                        switch (protocol)
                        {
                            case 100:
                                //C# dashboard or InfluxDB Client 
                                await responseStream.WriteAsync(response);
                                break;
                            case 200:
                                // mobile Client
                                Debug.WriteLine("enter program");
                                testService.RxLink(ref response);
                                break;

                        }

                    }

                }

            });

            _ = Task.Run(async () => {
                while (await extLink.ResponseStream.MoveNext(cancellationToken: CancellationToken.None))
                {
                    ExtMessage response = extLink.ResponseStream.Current; // From Server
                    IServerStreamWriter<ExtMessage>? responseStream = testService.responseStreamExt;

                    if (responseStream != null)
                    {
                        await responseStream.WriteAsync(response); // Server to Client
                    }
                }
            });

            _ = Task.Run(async () => {
                while (await cmdLink.ResponseStream.MoveNext(cancellationToken: CancellationToken.None))
                {
                    CmdMessage response = cmdLink.ResponseStream.Current; // From Server
                    IServerStreamWriter<CmdMessage>? responseStream = testService.responseStreamCmd;

                    if (responseStream != null)
                    {
                        await responseStream.WriteAsync(response); // Server to Client
                    }
                }
            });
            Debug.WriteLine("Network Service Host Starts");

        }
    }
}
