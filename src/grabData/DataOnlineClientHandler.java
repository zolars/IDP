package grabData;

import deviceJobManager.DeviceManager;
import hibernatePOJO.*;
import hibernatePOJO.Dictionary;
import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import io.netty.channel.socket.SocketChannel;

import java.util.*;

class DataOnlineClientHandler extends ChannelInboundHandlerAdapter {
    private Map<String, Float> map = null;
    private List<Dictionary> dic = null;
    private List<DictionaryPlus> dicPlus = null;
    private ByteBuf recMsg = null;

    private int[] slaveId = new int[22];
    private int[] fCode = new int[22];
    private int[] addr = new int[22];
    private int[] len = new int [22];
    private String[] name = new String[643];
    private Integer[] factor = new Integer[643];

    private int part = 0;
    private int count = 0;

    //监测点id
    private String did = "";

    public DataOnlineClientHandler(String did) {
        this.did = did;
        this.map = new HashMap<String, Float>();
        DataOnline.getParmMap().put(did, new PowerparmMonitor()); //把实时数据对象的引用暂存起来
        DataOnline.getXbMap().put(did, new PowerxbMonitor());
        DataOnline.getSxdyMap().put(did, new PowersxdyMonitor());
        DataOnline.getOnlineDataMap().put(did, this.map); //把实时数据map的引用存起来
    }
    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {

        /*2019-03-04*/
        for(Devices d:DeviceManager.getFirstConnection().keySet()){
            if(d.getDid().toString()==this.did){
                DeviceManager.getFirstConnection().put(d,true);
            }
        }
        /*2019-03-04*/

        // record ctx in DeviceManager
        System.out.println(did+": channel active");
        DeviceManager.getCtxMap().put(this.did+"-1",ctx);

        dicPlus = DataOnline.getDicPlus();
        dic = DataOnline.getDic();

        for (int i = 0; i < dic.size(); i++) {
            name[i] = dic.get(i).getItem();
            factor[i] = dic.get(i).getCoefficient();
        }
        for (int i = 0; i < dicPlus.size(); i++) {
            slaveId[i] = dicPlus.get(i).getSlaveid();
            fCode[i] = dicPlus.get(i).getFunctioncode();
            addr[i] = dicPlus.get(i).getStart();
            len[i] = dicPlus.get(i).getLength();
        }
        ByteBuf sendMsg = ctx.alloc().buffer();
        sendMsg.writeBytes(createMsg(slaveId[part], fCode[part], addr[part], len[part]));
        SocketChannel sc = (SocketChannel) ctx.channel();
        sc.writeAndFlush(sendMsg);
    }


    @Override
    public void handlerAdded(ChannelHandlerContext ctx) throws Exception {
        recMsg = ctx.alloc().buffer();
    }

    @Override
    public void handlerRemoved(ChannelHandlerContext ctx) throws Exception {
        recMsg.release();
        recMsg = null;
    }

    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
        ByteBuf buf = (ByteBuf) msg;
        recMsg.writeBytes(buf);
        buf.release();
        //数据累积
        if (recMsg.readableBytes() < 2 * len[part] + 9) {
            return;
        }
        dataResolve(recMsg, addr[part], len[part]);
        recMsg.clear();
        if (part < 21) {
            part++;
        } else {
            part = 0;
            count = 0;
            //取到一次完整的实时数据，暂存起来
            DataOnline.tempSave(did, map);
        }
        // sleep 1s
        Thread.sleep(1000);

        ByteBuf sendMsg = ctx.alloc().buffer(12);
        sendMsg.writeBytes(createMsg(slaveId[part], fCode[part], addr[part], len[part]));
        SocketChannel sc = (SocketChannel) ctx.channel();
        sc.writeAndFlush(sendMsg);
    }

    @Override
    public void channelInactive(ChannelHandlerContext ctx) throws Exception {
        //remove map,so that old data will not be recorded in database
        DataOnline.getParmMap().remove(this.did);
        DataOnline.getXbMap().remove(this.did);
        DataOnline.getSxdyMap().remove(this.did);
        DataOnline.getOnlineDataMap().remove(this.did);
        //remove ctx in DeviceManager
        DeviceManager.getCtxMap().remove(this.did+"-1");
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        cause.printStackTrace();
        ctx.close();
    }
    //readLength单位是2字节
    public byte[] createMsg(int slaveId, int functionCode, int address, int readLength) {
        byte[] msg = new byte[12];
        msg[0] = 0;
        msg[1] = 0;
        msg[2] = 0;
        msg[3] = 0;
        msg[4] = 0;
        msg[5] = 6;
        msg[6] = ((byte) slaveId);
        msg[7] = ((byte) functionCode);
        msg[8] = ((byte)(address >> 8));
        msg[9] = ((byte)(address & 0xFF));
        msg[10] = ((byte)(readLength >> 8));
        msg[11] = ((byte)(readLength & 0xFF));
        return msg;
    }

    public void dataResolve(ByteBuf buf, int addr, int len) {
        float temp = 0;
        buf.skipBytes(9); //跳过前9个字节，与数据无关
        for (int i = addr / 2; i < (len + addr) / 2; i++) {
            temp = Float.intBitsToFloat((int) buf.readUnsignedInt());
            map.put(name[count], temp * factor[count]);
            count++;
        }
//        Set<String> didSet = map.keySet();
//        Iterator<String> iterator = didSet.iterator();
//        String did = iterator.next();
//        map.get(did);
    }
}
