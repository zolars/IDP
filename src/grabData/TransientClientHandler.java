package grabData;

import Util.HBSessionDaoImpl;
import com.alibaba.fastjson.JSON;

import hibernatePOJO.EventPower;
import hibernatePOJO.EventsType;
import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;

import java.nio.charset.Charset;
import java.util.Arrays;
import java.util.List;

public class TransientClientHandler extends ChannelInboundHandlerAdapter {
    private static Charset charset=Charset.forName("UTF-8");
    private boolean newResponse=true;
    private short resLength=0;
    private ByteBuf tempBuf;
    private String did="";

    public TransientClientHandler(String did) {
        this.did=did;
    }

    public void handlerAdded(ChannelHandlerContext ctx) throws Exception {
        //super.handlerAdded(ctx);
        tempBuf=ctx.alloc().buffer();
    }

    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
        ByteBuf buf=(ByteBuf)msg;
        if(newResponse){
            resLength=buf.getShort(2);
            newResponse=false;
            //System.out.println("响应长度: "+resLength);
        }
        tempBuf.writeBytes(buf);
        buf.release();
        if(tempBuf.readableBytes()>=resLength){
            newResponse=true;
            //MD5校验
            byte[] resContent=new byte[resLength-16];
            byte[] resChkSum=new byte[16];
            tempBuf.readBytes(resContent);//读取response的消息体
            tempBuf.readBytes(resChkSum);//读取response的校验和
            byte[] contentCheckCode=TransientUtil.mergeByteArray(resContent,TransientUtil.getCheckCode().getBytes());
            if(Arrays.equals(TransientUtil.md5(contentCheckCode),resChkSum)){
                //System.out.println("校验通过");
                String res=new String(resContent,10,resContent.length-10,"UTF-8");
                //System.out.println("响应消息体: "+res);
                //数据存入数据库
                TransientResponse tr=JSON.parseObject(res, TransientResponse.class);//反序列化
                List<EventPower> events=tr.getResult();
                if(events.size() > 0){
                    HBSessionDaoImpl hbsessionDao = new HBSessionDaoImpl();
                    for(EventPower e:events){
                        dataResolve(hbsessionDao, e);
                        hbsessionDao.insert(e);
                    }
                    hbsessionDao=null;
                }
            }
            tempBuf.clear();
        }

    }

    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {
        //System.out.println("建立连接");
        //把channel存入map,用于发送transientRequest
        DataOnline.getTransientChannelMap().put(this.did, ctx.channel());

         /* ByteBuf sendMsg = ctx.alloc().buffer(8);

      sendMsg.writeBytes(createMsg());
        // System.out.println("send:"+ByteBufUtil.hexDump(sendMsg));//打印发送数据
        SocketChannel sc = (SocketChannel) ctx.channel();
        sc.writeAndFlush(sendMsg);*/

    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        //super.exceptionCaught(ctx, cause);
        cause.printStackTrace();
        ctx.close();
    }

    public void dataResolve(HBSessionDaoImpl hbsessionDao, EventPower e){
        EventsType et = (EventsType)hbsessionDao.getFirst("FROM EventsType where subtype='"+ e.getSubtype() +"'");
        Integer cid = et.getCid();
        e.setDid(did);
        e.setCid(cid);
    }
}
