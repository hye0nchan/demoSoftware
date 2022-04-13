// <auto-generated>
//     Generated by the protocol buffer compiler.  DO NOT EDIT!
//     source: Protos/network.proto
// </auto-generated>
// Original file comments:
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
//
#pragma warning disable 0414, 1591
#region Designer generated code

using grpc = global::Grpc.Core;

namespace NetExchange {
  /// <summary>
  /// The service definition.
  /// </summary>
  public static partial class ExProto
  {
    static readonly string __ServiceName = "net_exchange.ExProto";

    [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
    static void __Helper_SerializeMessage(global::Google.Protobuf.IMessage message, grpc::SerializationContext context)
    {
      #if !GRPC_DISABLE_PROTOBUF_BUFFER_SERIALIZATION
      if (message is global::Google.Protobuf.IBufferMessage)
      {
        context.SetPayloadLength(message.CalculateSize());
        global::Google.Protobuf.MessageExtensions.WriteTo(message, context.GetBufferWriter());
        context.Complete();
        return;
      }
      #endif
      context.Complete(global::Google.Protobuf.MessageExtensions.ToByteArray(message));
    }

    [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
    static class __Helper_MessageCache<T>
    {
      public static readonly bool IsBufferMessage = global::System.Reflection.IntrospectionExtensions.GetTypeInfo(typeof(global::Google.Protobuf.IBufferMessage)).IsAssignableFrom(typeof(T));
    }

    [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
    static T __Helper_DeserializeMessage<T>(grpc::DeserializationContext context, global::Google.Protobuf.MessageParser<T> parser) where T : global::Google.Protobuf.IMessage<T>
    {
      #if !GRPC_DISABLE_PROTOBUF_BUFFER_SERIALIZATION
      if (__Helper_MessageCache<T>.IsBufferMessage)
      {
        return parser.ParseFrom(context.PayloadAsReadOnlySequence());
      }
      #endif
      return parser.ParseFrom(context.PayloadAsNewBuffer());
    }

    [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
    static readonly grpc::Marshaller<global::NetExchange.RtuMessage> __Marshaller_net_exchange_RtuMessage = grpc::Marshallers.Create(__Helper_SerializeMessage, context => __Helper_DeserializeMessage(context, global::NetExchange.RtuMessage.Parser));
    [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
    static readonly grpc::Marshaller<global::NetExchange.ExtMessage> __Marshaller_net_exchange_ExtMessage = grpc::Marshallers.Create(__Helper_SerializeMessage, context => __Helper_DeserializeMessage(context, global::NetExchange.ExtMessage.Parser));
    [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
    static readonly grpc::Marshaller<global::NetExchange.CmdMessage> __Marshaller_net_exchange_CmdMessage = grpc::Marshallers.Create(__Helper_SerializeMessage, context => __Helper_DeserializeMessage(context, global::NetExchange.CmdMessage.Parser));

    [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
    static readonly grpc::Method<global::NetExchange.RtuMessage, global::NetExchange.RtuMessage> __Method_MessageRtu = new grpc::Method<global::NetExchange.RtuMessage, global::NetExchange.RtuMessage>(
        grpc::MethodType.DuplexStreaming,
        __ServiceName,
        "MessageRtu",
        __Marshaller_net_exchange_RtuMessage,
        __Marshaller_net_exchange_RtuMessage);

    [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
    static readonly grpc::Method<global::NetExchange.ExtMessage, global::NetExchange.ExtMessage> __Method_MessageExt = new grpc::Method<global::NetExchange.ExtMessage, global::NetExchange.ExtMessage>(
        grpc::MethodType.DuplexStreaming,
        __ServiceName,
        "MessageExt",
        __Marshaller_net_exchange_ExtMessage,
        __Marshaller_net_exchange_ExtMessage);

    [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
    static readonly grpc::Method<global::NetExchange.CmdMessage, global::NetExchange.CmdMessage> __Method_MessageCmd = new grpc::Method<global::NetExchange.CmdMessage, global::NetExchange.CmdMessage>(
        grpc::MethodType.DuplexStreaming,
        __ServiceName,
        "MessageCmd",
        __Marshaller_net_exchange_CmdMessage,
        __Marshaller_net_exchange_CmdMessage);

    [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
    static readonly grpc::Method<global::NetExchange.RtuMessage, global::NetExchange.RtuMessage> __Method_influxDB = new grpc::Method<global::NetExchange.RtuMessage, global::NetExchange.RtuMessage>(
        grpc::MethodType.DuplexStreaming,
        __ServiceName,
        "influxDB",
        __Marshaller_net_exchange_RtuMessage,
        __Marshaller_net_exchange_RtuMessage);

    /// <summary>Service descriptor</summary>
    public static global::Google.Protobuf.Reflection.ServiceDescriptor Descriptor
    {
      get { return global::NetExchange.NetworkReflection.Descriptor.Services[0]; }
    }

    /// <summary>Client for ExProto</summary>
    public partial class ExProtoClient : grpc::ClientBase<ExProtoClient>
    {
      /// <summary>Creates a new client for ExProto</summary>
      /// <param name="channel">The channel to use to make remote calls.</param>
      [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
      public ExProtoClient(grpc::ChannelBase channel) : base(channel)
      {
      }
      /// <summary>Creates a new client for ExProto that uses a custom <c>CallInvoker</c>.</summary>
      /// <param name="callInvoker">The callInvoker to use to make remote calls.</param>
      [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
      public ExProtoClient(grpc::CallInvoker callInvoker) : base(callInvoker)
      {
      }
      /// <summary>Protected parameterless constructor to allow creation of test doubles.</summary>
      [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
      protected ExProtoClient() : base()
      {
      }
      /// <summary>Protected constructor to allow creation of configured clients.</summary>
      /// <param name="configuration">The client configuration.</param>
      [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
      protected ExProtoClient(ClientBaseConfiguration configuration) : base(configuration)
      {
      }

      [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
      public virtual grpc::AsyncDuplexStreamingCall<global::NetExchange.RtuMessage, global::NetExchange.RtuMessage> MessageRtu(grpc::Metadata headers = null, global::System.DateTime? deadline = null, global::System.Threading.CancellationToken cancellationToken = default(global::System.Threading.CancellationToken))
      {
        return MessageRtu(new grpc::CallOptions(headers, deadline, cancellationToken));
      }
      [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
      public virtual grpc::AsyncDuplexStreamingCall<global::NetExchange.RtuMessage, global::NetExchange.RtuMessage> MessageRtu(grpc::CallOptions options)
      {
        return CallInvoker.AsyncDuplexStreamingCall(__Method_MessageRtu, null, options);
      }
      [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
      public virtual grpc::AsyncDuplexStreamingCall<global::NetExchange.ExtMessage, global::NetExchange.ExtMessage> MessageExt(grpc::Metadata headers = null, global::System.DateTime? deadline = null, global::System.Threading.CancellationToken cancellationToken = default(global::System.Threading.CancellationToken))
      {
        return MessageExt(new grpc::CallOptions(headers, deadline, cancellationToken));
      }
      [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
      public virtual grpc::AsyncDuplexStreamingCall<global::NetExchange.ExtMessage, global::NetExchange.ExtMessage> MessageExt(grpc::CallOptions options)
      {
        return CallInvoker.AsyncDuplexStreamingCall(__Method_MessageExt, null, options);
      }
      [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
      public virtual grpc::AsyncDuplexStreamingCall<global::NetExchange.CmdMessage, global::NetExchange.CmdMessage> MessageCmd(grpc::Metadata headers = null, global::System.DateTime? deadline = null, global::System.Threading.CancellationToken cancellationToken = default(global::System.Threading.CancellationToken))
      {
        return MessageCmd(new grpc::CallOptions(headers, deadline, cancellationToken));
      }
      [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
      public virtual grpc::AsyncDuplexStreamingCall<global::NetExchange.CmdMessage, global::NetExchange.CmdMessage> MessageCmd(grpc::CallOptions options)
      {
        return CallInvoker.AsyncDuplexStreamingCall(__Method_MessageCmd, null, options);
      }
      [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
      public virtual grpc::AsyncDuplexStreamingCall<global::NetExchange.RtuMessage, global::NetExchange.RtuMessage> influxDB(grpc::Metadata headers = null, global::System.DateTime? deadline = null, global::System.Threading.CancellationToken cancellationToken = default(global::System.Threading.CancellationToken))
      {
        return influxDB(new grpc::CallOptions(headers, deadline, cancellationToken));
      }
      [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
      public virtual grpc::AsyncDuplexStreamingCall<global::NetExchange.RtuMessage, global::NetExchange.RtuMessage> influxDB(grpc::CallOptions options)
      {
        return CallInvoker.AsyncDuplexStreamingCall(__Method_influxDB, null, options);
      }
      /// <summary>Creates a new instance of client from given <c>ClientBaseConfiguration</c>.</summary>
      [global::System.CodeDom.Compiler.GeneratedCode("grpc_csharp_plugin", null)]
      protected override ExProtoClient NewInstance(ClientBaseConfiguration configuration)
      {
        return new ExProtoClient(configuration);
      }
    }

  }
}
#endregion
