package concurrency.CompletableFutureTest;

import io.netty.bootstrap.Bootstrap;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelFutureListener;

import java.net.InetSocketAddress;

public class NettyWay {

    public void asyncBlockWay(Bootstrap bootstrap, String host, int port) {
        // Start the connection attempt.
        ChannelFuture future = bootstrap.connect(new InetSocketAddress(host, port));

        // Wait until the connection is closed or the connection attempt fails.
        future.channel().closeFuture().awaitUninterruptibly();

        // Shut down thread pools to exit.
//        bootstrap.releaseExternalResources();
    }

    public void asyncNonBlockWay(Bootstrap bootstrap, String host, int port) {
        // Start the connection attempt.
        ChannelFuture Future = bootstrap.connect(new InetSocketAddress(host, port));

        Future.addListener(new ChannelFutureListener() {
            public void operationComplete(final ChannelFuture Future) throws Exception {

            }
        });

        // Shut down thread pools to exit.
//        bootstrap.releaseExternalResources();
    }

}
