#region Copyright notice and license

// Copyright 2019 The gRPC Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#endregion

using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using Grpc.Core;
using NetExchange;
using System;
using System.Collections.Generic;

namespace NetService
{
    public class ExchangeService : ExProto.ExProtoBase
    {
        private readonly ILogger _logger;
        internal static IServerStreamWriter<RtuMessage> responseStreamRtu = null;
        internal static IServerStreamWriter<ExtMessage> responseStreamExt = null;
        internal static IServerStreamWriter<CmdMessage> responseStreamCmd = null;
        internal static IServerStreamWriter<RtuMessage> responseStream = null;
        internal static IServerStreamWriter<RtuMessage> responseStreamInflux = null;
        internal static IServerStreamWriter<ExMessage> responseExMessage = null;

        public ExchangeService(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<ExchangeService>();
            _logger.LogInformation($"Exchange Service Protocol Starts");
        }





  
        internal static void RxLink(ref RtuMessage response)
        {
            IServerStreamWriter<RtuMessage> responseStream = ExchangeService.responseStream;

            if (responseStream != null)
            {
                RtuMessage box = new RtuMessage();
                //responseStream.WriteAsync(new ExMessage {Route = response.Route, DataUnit = response.DataUnit, GwId = response.GwId, DeviceId = response.DeviceId });
                box.GwId = response.GwId; box.DataUnit = response.DataUnit; box.DeviceId = response.DeviceId; box.SequenceNumber = response.SequenceNumber;

                responseStream.WriteAsync(box);

            }

        }

    }
}
