package grabData;

import com.alibaba.fastjson.JSON;
import hibernatePOJO.Dictionary;
import hibernatePOJO.DictionaryPlus;

import java.util.List;
import java.util.Map;

public class DataOnline {
    private static String data=null;
    public static List<Dictionary> dic=null;
    public static List<DictionaryPlus> dicPlus=null;

    public static String getData() {
        return data;
    }


    public static void setData(Map<String,Float> map) {
        String text= JSON.toJSONString(map);
        data=text;
    }
}


