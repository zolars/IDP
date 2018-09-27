package grabData;

import io.netty.bootstrap.Bootstrap;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelOption;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioSocketChannel;


public class CtrlDataClient extends Thread {
    private String host;
    private int port;
    private String did;

    public CtrlDataClient(String host, int port, String did) {
        this.host = host;
        this.port = port;
        this.did = did;
        System.out.println(host + port + did);
    }

    @Override
    public void run() {
        EventLoopGroup workerGroup = new NioEventLoopGroup();
        try {
            Bootstrap b = new Bootstrap();
            b.group(workerGroup);
            b.channel(NioSocketChannel.class);
            b.option(ChannelOption.SO_KEEPALIVE, Boolean.valueOf(true));
            b.handler(new ChannelInitializer<SocketChannel>() {
                public void initChannel(SocketChannel ch)
                        throws Exception {
                    ch.pipeline().addLast(new CtrlDataClientHandler(did));
                    //System.out.println("HANDLER-BUILT#####################################");

                }
            });
            ChannelFuture f = b.connect(host, port).sync();
            f.channel().closeFuture().sync();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            workerGroup.shutdownGracefully();
        }
    }
}