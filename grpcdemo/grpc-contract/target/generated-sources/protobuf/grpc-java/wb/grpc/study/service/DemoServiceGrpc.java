package wb.grpc.study.service;

import static io.grpc.stub.ClientCalls.asyncUnaryCall;
import static io.grpc.stub.ClientCalls.asyncServerStreamingCall;
import static io.grpc.stub.ClientCalls.asyncClientStreamingCall;
import static io.grpc.stub.ClientCalls.asyncBidiStreamingCall;
import static io.grpc.stub.ClientCalls.blockingUnaryCall;
import static io.grpc.stub.ClientCalls.blockingServerStreamingCall;
import static io.grpc.stub.ClientCalls.futureUnaryCall;
import static io.grpc.stub.ServerCalls.asyncUnaryCall;
import static io.grpc.stub.ServerCalls.asyncServerStreamingCall;
import static io.grpc.stub.ServerCalls.asyncClientStreamingCall;
import static io.grpc.stub.ServerCalls.asyncBidiStreamingCall;

@javax.annotation.Generated("by gRPC proto compiler")
public class DemoServiceGrpc {

  // Static method descriptors that strictly reflect the proto.
  public static final io.grpc.MethodDescriptor<wb.grpc.study.dto.PingRequest,
      wb.grpc.study.dto.PingResponse> METHOD_PING =
      io.grpc.MethodDescriptor.create(
          io.grpc.MethodDescriptor.MethodType.UNARY,
          "wb.grpc.study.service.DemoService", "Ping",
          io.grpc.protobuf.ProtoUtils.marshaller(wb.grpc.study.dto.PingRequest.parser()),
          io.grpc.protobuf.ProtoUtils.marshaller(wb.grpc.study.dto.PingResponse.parser()));
  public static final io.grpc.MethodDescriptor<wb.grpc.study.dto.QueryParameter,
      wb.grpc.study.dto.PersonList> METHOD_GET_PERSON_LIST =
      io.grpc.MethodDescriptor.create(
          io.grpc.MethodDescriptor.MethodType.UNARY,
          "wb.grpc.study.service.DemoService", "getPersonList",
          io.grpc.protobuf.ProtoUtils.marshaller(wb.grpc.study.dto.QueryParameter.parser()),
          io.grpc.protobuf.ProtoUtils.marshaller(wb.grpc.study.dto.PersonList.parser()));

  public static DemoServiceStub newStub(io.grpc.Channel channel) {
    return new DemoServiceStub(channel);
  }

  public static DemoServiceBlockingStub newBlockingStub(
      io.grpc.Channel channel) {
    return new DemoServiceBlockingStub(channel);
  }

  public static DemoServiceFutureStub newFutureStub(
      io.grpc.Channel channel) {
    return new DemoServiceFutureStub(channel);
  }

  public static interface DemoService {

    public void ping(wb.grpc.study.dto.PingRequest request,
        io.grpc.stub.StreamObserver<wb.grpc.study.dto.PingResponse> responseObserver);

    public void getPersonList(wb.grpc.study.dto.QueryParameter request,
        io.grpc.stub.StreamObserver<wb.grpc.study.dto.PersonList> responseObserver);
  }

  public static interface DemoServiceBlockingClient {

    public wb.grpc.study.dto.PingResponse ping(wb.grpc.study.dto.PingRequest request);

    public wb.grpc.study.dto.PersonList getPersonList(wb.grpc.study.dto.QueryParameter request);
  }

  public static interface DemoServiceFutureClient {

    public com.google.common.util.concurrent.ListenableFuture<wb.grpc.study.dto.PingResponse> ping(
        wb.grpc.study.dto.PingRequest request);

    public com.google.common.util.concurrent.ListenableFuture<wb.grpc.study.dto.PersonList> getPersonList(
        wb.grpc.study.dto.QueryParameter request);
  }

  public static class DemoServiceStub extends io.grpc.stub.AbstractStub<DemoServiceStub>
      implements DemoService {
    private DemoServiceStub(io.grpc.Channel channel) {
      super(channel);
    }

    private DemoServiceStub(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected DemoServiceStub build(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      return new DemoServiceStub(channel, callOptions);
    }

    @java.lang.Override
    public void ping(wb.grpc.study.dto.PingRequest request,
        io.grpc.stub.StreamObserver<wb.grpc.study.dto.PingResponse> responseObserver) {
      asyncUnaryCall(
          channel.newCall(METHOD_PING, callOptions), request, responseObserver);
    }

    @java.lang.Override
    public void getPersonList(wb.grpc.study.dto.QueryParameter request,
        io.grpc.stub.StreamObserver<wb.grpc.study.dto.PersonList> responseObserver) {
      asyncUnaryCall(
          channel.newCall(METHOD_GET_PERSON_LIST, callOptions), request, responseObserver);
    }
  }

  public static class DemoServiceBlockingStub extends io.grpc.stub.AbstractStub<DemoServiceBlockingStub>
      implements DemoServiceBlockingClient {
    private DemoServiceBlockingStub(io.grpc.Channel channel) {
      super(channel);
    }

    private DemoServiceBlockingStub(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected DemoServiceBlockingStub build(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      return new DemoServiceBlockingStub(channel, callOptions);
    }

    @java.lang.Override
    public wb.grpc.study.dto.PingResponse ping(wb.grpc.study.dto.PingRequest request) {
      return blockingUnaryCall(
          channel.newCall(METHOD_PING, callOptions), request);
    }

    @java.lang.Override
    public wb.grpc.study.dto.PersonList getPersonList(wb.grpc.study.dto.QueryParameter request) {
      return blockingUnaryCall(
          channel.newCall(METHOD_GET_PERSON_LIST, callOptions), request);
    }
  }

  public static class DemoServiceFutureStub extends io.grpc.stub.AbstractStub<DemoServiceFutureStub>
      implements DemoServiceFutureClient {
    private DemoServiceFutureStub(io.grpc.Channel channel) {
      super(channel);
    }

    private DemoServiceFutureStub(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      super(channel, callOptions);
    }

    @java.lang.Override
    protected DemoServiceFutureStub build(io.grpc.Channel channel,
        io.grpc.CallOptions callOptions) {
      return new DemoServiceFutureStub(channel, callOptions);
    }

    @java.lang.Override
    public com.google.common.util.concurrent.ListenableFuture<wb.grpc.study.dto.PingResponse> ping(
        wb.grpc.study.dto.PingRequest request) {
      return futureUnaryCall(
          channel.newCall(METHOD_PING, callOptions), request);
    }

    @java.lang.Override
    public com.google.common.util.concurrent.ListenableFuture<wb.grpc.study.dto.PersonList> getPersonList(
        wb.grpc.study.dto.QueryParameter request) {
      return futureUnaryCall(
          channel.newCall(METHOD_GET_PERSON_LIST, callOptions), request);
    }
  }

  public static io.grpc.ServerServiceDefinition bindService(
      final DemoService serviceImpl) {
    return io.grpc.ServerServiceDefinition.builder("wb.grpc.study.service.DemoService")
      .addMethod(io.grpc.ServerMethodDefinition.create(
          METHOD_PING,
          asyncUnaryCall(
            new io.grpc.stub.ServerCalls.UnaryMethod<
                wb.grpc.study.dto.PingRequest,
                wb.grpc.study.dto.PingResponse>() {
              @java.lang.Override
              public void invoke(
                  wb.grpc.study.dto.PingRequest request,
                  io.grpc.stub.StreamObserver<wb.grpc.study.dto.PingResponse> responseObserver) {
                serviceImpl.ping(request, responseObserver);
              }
            })))
      .addMethod(io.grpc.ServerMethodDefinition.create(
          METHOD_GET_PERSON_LIST,
          asyncUnaryCall(
            new io.grpc.stub.ServerCalls.UnaryMethod<
                wb.grpc.study.dto.QueryParameter,
                wb.grpc.study.dto.PersonList>() {
              @java.lang.Override
              public void invoke(
                  wb.grpc.study.dto.QueryParameter request,
                  io.grpc.stub.StreamObserver<wb.grpc.study.dto.PersonList> responseObserver) {
                serviceImpl.getPersonList(request, responseObserver);
              }
            }))).build();
  }
}
