package grabData;

import deviceJobManager.HeartBeatHandler;
import io.netty.bootstrap.Bootstrap;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelOption;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioSocketChannel;
import io.netty.handler.timeout.IdleStateHandler;

import java.util.concurrent.TimeUnit;


public class DataOnlineClient extends Thread {
    private String host;
    private int port;
    private String did;

    public DataOnlineClient(String host, int port, String did) {
        this.host = host;
        this.port = port;
        this.did = did;
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
                    // heart beat check
                    ch.pipeline().addLast(new IdleStateHandler(0, HeartBeatHandler.timeout,0, TimeUnit.SECONDS))
                            .addLast(new HeartBeatHandler(host,port,did,1))
                            .addLast(new DataOnlineClientHandler(did));
                }
            });

            ChannelFuture f = b.connect(host, port).sync();
            if(f.isSuccess()) {
                f.channel().closeFuture().sync();
            } else {
                System.out.println("============================重新建立连接");
                run();
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("============================重新建立连接");
            run();
        } finally {
            workerGroup.shutdownGracefully();
        }
    }
}
