using Grpc.Core;
using Grpc.Net.Client;
using NetExchange;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
                        //await responseStream.WriteAsync(response);

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
