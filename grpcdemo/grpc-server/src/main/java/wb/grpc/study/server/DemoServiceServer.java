package wb.grpc.study.server;

import io.grpc.ServerImpl;
import io.grpc.inprocess.InProcessServerBuilder;
import io.grpc.netty.NettyServerBuilder;
import wb.grpc.study.service.DemoServiceGrpc;
import wb.grpc.study.service.impl.DemoServiceImpl;


public class DemoServiceServer {

    private int port = 50051;
    private ServerImpl server;

    private void start() throws Exception {
        server = NettyServerBuilder.forPort(port)
                                   .addService(DemoServiceGrpc.bindService(new DemoServiceImpl()))
                                   .build().start();

        server = InProcessServerBuilder.forName("testServer")
                                       .addService(DemoServiceGrpc.bindService(new DemoServiceImpl()))
                                       .build().start();

        System.out.println("Server started, listening on " + port);
        Runtime.getRuntime().addShutdownHook(new Thread() {
            @Override
            public void run() {
                System.out.println("*** shutting down gRPC server since JVM is shutting down");
                DemoServiceServer.this.stop();
                System.out.println("*** server shut down");
            }
        });
    }

    private void stop() {
        if (server != null) {
            server.shutdown();
        }
    }


    public static void main(String[] args) throws Exception {
        final DemoServiceServer server = new DemoServiceServer();
        server.start();
    }

}
