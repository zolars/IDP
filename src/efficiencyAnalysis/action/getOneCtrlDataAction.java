package efficiencyAnalysis.action;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.opensymphony.xwork2.ActionSupport;
import efficiencyAnalysis.dao.EventDAO;
import efficiencyAnalysis.dao.impl.EventDAOImpl;
import org.apache.struts2.ServletActionContext;

import javax.servlet.http.HttpServletRequest;


public class getOneCtrlDataAction extends ActionSupport {
    private static final long serialVersionUID = 13L;
    private String result;

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    /* 获取治理设备的状态
     */
    public String execute() throws Exception {
        try {
            HttpServletRequest request = ServletActionContext.getRequest();
            request.setCharacterEncoding("utf-8");

            String did = request.getParameter("did");
            String starttime = request.getParameter("stime");
            String endtime = request.getParameter("etime");

            EventDAO dao = new EventDAOImpl();

            String rt = dao.getDeviceCtrlStatus(did, starttime, endtime);
            String name = dao.getDeviceNameCtrl(did);

            JSONObject jsonObject = new JSONObject();
            jsonObject.put("rt", rt);
            jsonObject.put("name",name);

            result = JSON.toJSONString(jsonObject);

        } catch (Exception e) {
            e.printStackTrace();
            return "failure";
        }
        return "success";
    }

}
