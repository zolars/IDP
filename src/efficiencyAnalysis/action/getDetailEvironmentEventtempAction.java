package efficiencyAnalysis.action;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.opensymphony.xwork2.ActionSupport;
import efficiencyAnalysis.dao.EventDAO;
import efficiencyAnalysis.dao.impl.EventDAOImpl;
import hibernatePOJO.EventPower;
import org.apache.struts2.ServletActionContext;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;


public class getDetailEvironmentEventtempAction extends ActionSupport {
    private static final long serialVersionUID = 13L;
    private String result;

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }


    /* 根据测量地点（市行名称）获取详细的 第二页环境事件-温度
     */
    public String execute() throws Exception {
        try {//获取数据
            HttpServletRequest request = ServletActionContext.getRequest();
            request.setCharacterEncoding("utf-8");

            String cbname = request.getParameter("cbname");
            String starttime = request.getParameter("stime");
            String endtime = request.getParameter("etime");

            EventDAO dao = new EventDAOImpl();

            List<EventPower> pedata = new ArrayList();

            if((starttime == null && endtime == null)||(starttime.equals(" ") && endtime.equals(" ")))
                pedata = dao.getLocalLastDetailEnvironmentEventtemp(cbname);

            else
                pedata = dao.getLocalAllDetailEnvironmentEventtemp(cbname, starttime, endtime);

            JSONObject jsonObject = new JSONObject();
            jsonObject.put("allpelist", pedata);

            result = JSON.toJSONString(jsonObject); // List转json

        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
        return "success";
    }

}
