package grabData;

import Util.HBSessionDaoImpl;
import hibernatePOJO.EventCtrl;
import onlineTest.dao.impl.CtrlParameter;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CtrlSave {
    private static Map<String, List<EventCtrl>> eventCtrlMap = new HashMap<>();
    // 存各个ctrl
    private static Map<String, CtrlParameter> ctrlMap = new HashMap<>();

    /*
     * 将接收到的五个线圈的字符串解析，读取每个位（前34个位）的值（0或1），将该值依此写入返回的list中
     */
    private static List<String> dataResolve(String data) {
        List<String> rtlist = new ArrayList<>();
        int count = 0; // 计数器，区分

        for (int i = 0; i < data.length(); i += 2) {

            String s1 = data.substring(i, i + 2); // "FF";
            Integer i1 = Integer.valueOf(s1, 16);
            String bin = Integer.toBinaryString(i1);
            String binary = null;

            if (i1 > 15) { // 第一位有数
                if (bin.length() == 7) {
                    String str = "0" + bin;
                    bin = str;
                }
                if (bin.length() == 6) {
                    String str = "00" + bin;
                    bin = str;
                }
                if (bin.length() == 5) {
                    String str = "000" + bin;
                    bin = str;
                }
                binary = bin;
            } else { // 第一位无数
                if (bin.length() == 3) {
                    String str = "0" + bin;
                    bin = str;
                }
                if (bin.length() == 2) {
                    String str = "00" + bin;
                    bin = str;
                }
                if (bin.length() == 1) {
                    String str = "000" + bin;
                    bin = str;
                }

                if (i1 <= 15) { // 若第一位为0，string前面补充四个0
                    binary = "0000" + bin;
                }
            }

            if (count <= 24) {
                // 前四个线圈binary字符串循环读完
                for (int j = 0; j < binary.length(); j++) {
                    String s = binary.substring(j, j + 1);
                    rtlist.add(s);
                }
            } else {
                // 最后一个线圈binary字符串只读取前两位
                for (int j = 0; j < 2; j++) {
                    String s = binary.substring(j, j + 1);
                    rtlist.add(s);
                }
            }

            count += 8;
        }
        return rtlist;
    }

    public static void ctrlSave(String did, String data) {
        eventCtrlMap = new HashMap<>();
        eventCtrlMap.put(did, new ArrayList<>());

        // 丢弃最后两个字符
        data = data.substring(0, 10);
        List<String> list = dataResolve(data);

        // 当前时间、检测设备id、maxID
        Timestamp currenttime = new Timestamp(System.currentTimeMillis());

        // idx 重排序 8~1 16~9 .。。
        List<String> idxlist = new ArrayList<>();

        for (int idx = 7; idx >= 0; idx--) {
            idxlist.add(list.get(idx));
        }

        for (int idx = 15; idx >= 8; idx--) {
            idxlist.add(list.get(idx));
        }

        for (int idx = 23; idx >= 16; idx--) {
            idxlist.add(list.get(idx));
        }

        for (int idx = 31; idx >= 24; idx--) {
            idxlist.add(list.get(idx));
        }

        for (int idx = 33; idx >= 32; idx--) {
            idxlist.add(list.get(idx));
        }

        for (int idx = 0; idx < idxlist.size(); idx++) {
            String value = idxlist.get(idx);

            if (value.equals("1")) { // 若有告警事件
                HBSessionDaoImpl hbsessionDao = new HBSessionDaoImpl();
                EventCtrl eventCtrl = (EventCtrl)hbsessionDao.getFirst(
                        "FROM EventCtrl order by teid desc");

                int maxteid = 0;

                if (eventCtrl != null) {
                    maxteid = eventCtrl.getTeid() + 1;
                }

                EventCtrl event = new EventCtrl();
                event.setTeid(maxteid);
                event.setTime(currenttime);
                event.setCid(idx + 1);
                event.setDid(did);
                event.setValue(value);

                // eventCtrlMap.get(did).add(event);
                /************2018-12-24 马卫亮  ADD******************************/
                hbsessionDao.update("update EventCtrl set signature = 'admin',annotation = '相同类型的告警自动确认' where cid = '"+idx+1+"' signature is null ");
                /************2018-12-24 马卫亮  ADD******************************/
                hbsessionDao.insert(event);
            }
        }
    }

    public static void ctrlSave2(String did,byte[] bytes){
        boolean[] statusList=new boolean[40];   //boolean数组，数组第 i 个元素代表第 i+1 个线圈是否异常，末尾元素无意义
        int count=0;    //表示当前判断的线圈
        boolean status=false;
        for(int i=0;i<5;++i){
            byte b=bytes[i];
            for(int j=0;j<8;++j){
                int flag=(b>>j) & (0x01);
                count=i*8+j;
                if(flag==1){
                    status=true;
                }
                else{
                    status=false;
                }
                if (count == 34) { // 第35个线圈是运行标识，状态取反
                    status = !status;
                }
                statusList[count] = status;
            }
        }

//        for(int i=0;i<40;++i){
//            System.out.println(i+1+":"+statusList[i]);
//        }

        for(int i=0;i<35;++i){
            if(statusList[i]){  //若有告警事件
                HBSessionDaoImpl hbsessionDao = new HBSessionDaoImpl();
                EventCtrl eventCtrl = (EventCtrl)hbsessionDao.getFirst(
                        "FROM EventCtrl where signature is not null order by teid desc");

                int maxteid = 0;

                if(eventCtrl != null) {
                    maxteid = eventCtrl.getTeid() + 1;
                }

                EventCtrl event = new EventCtrl();
                event.setTeid(maxteid);
                event.setTime(new Timestamp(System.currentTimeMillis()));
                event.setCid(i + 1);
                event.setDid(did);
                event.setValue("1");
                // eventCtrlMap.get(did).add(event);
                /************2018-12-24 马卫亮  ADD******************************/
                hbsessionDao.update("update EventCtrl set signature = 'admin',annotation = '相同类型的告警自动确认' where cid = '"+i+1+"' signature is null ");
                /************2018-12-24 马卫亮  ADD******************************/
                hbsessionDao.insert(event);
            }
        }
    }

    public static void setCtrlMap(String did,byte[] bytes){
        boolean[] statusList=new boolean[40];   //boolean数组，数组第 i 个元素代表第 i+1 个线圈是否异常，末尾元素无意义
        int count=0;    //表示当前判断的线圈
        boolean status=false;
        for(int i=0;i<5;++i){
            byte b=bytes[i];
            for(int j=0;j<8;++j){
                int flag=(b>>j) & (0x01);
                count=i*8+j;
                if(flag==1){
                    status=true;
                }
                else{
                    status=false;
                }
                if(count==34){  //第35个线圈是运行标识，状态取反
                    status=!status;
                }
                statusList[count]=status;
            }
        }

//        for(int i=0;i<40;++i){
//            System.out.println(i+1+":"+statusList[i]);
//        }
        CtrlParameter cp = new CtrlParameter();

        cp.setCtrl1(statusList[0]);
        cp.setCtrl2(statusList[1]);
        cp.setCtrl3(statusList[2]);
        cp.setCtrl4(statusList[3]);
        cp.setCtrl5(statusList[4]);
        cp.setCtrl6(statusList[5]);
        cp.setCtrl7(statusList[6]);
        cp.setCtrl8(statusList[7]);
        cp.setCtrl9(statusList[8]);
        cp.setCtrl10(statusList[9]);
        cp.setCtrl11(statusList[10]);
        cp.setCtrl12(statusList[11]);
        cp.setCtrl13(statusList[12]);
        cp.setCtrl14(statusList[13]);
        cp.setCtrl15(statusList[14]);
        cp.setCtrl16(statusList[15]);
        cp.setCtrl17(statusList[16]);
        cp.setCtrl18(statusList[17]);
        cp.setCtrl19(statusList[18]);
        cp.setCtrl20(statusList[19]);
        cp.setCtrl21(statusList[20]);
        cp.setCtrl22(statusList[21]);
        cp.setCtrl23(statusList[22]);
        cp.setCtrl24(statusList[23]);
        cp.setCtrl25(statusList[24]);
        cp.setCtrl26(statusList[25]);
        cp.setCtrl27(statusList[26]);
        cp.setCtrl28(statusList[27]);
        cp.setCtrl29(statusList[28]);
        cp.setCtrl30(statusList[29]);
        cp.setCtrl31(statusList[30]);
        cp.setCtrl32(statusList[31]);
        cp.setCtrl33(statusList[32]);
        cp.setCtrl34(statusList[33]);

        ctrlMap.put(did, cp);
    }

    public static Map<String, List<EventCtrl>> getEventCtrlMap() {
        return eventCtrlMap;
    }

    public static Map<String, CtrlParameter> getCtrlMap() {
        return ctrlMap;
    }
}


