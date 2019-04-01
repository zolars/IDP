package deviceManage.action;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.opensymphony.xwork2.ActionSupport;
import deviceManage.dao.DeviceDAO;
import deviceManage.dao.impl.DeviceDAOImpl;
import org.apache.struts2.ServletActionContext;

import javax.servlet.http.HttpServletRequest;

public class deleteOneDeviceAction extends ActionSupport {
    private static final long serialVersionUID = 13L;
    private String result;

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }


    // 删除一个设备
    // 2019.03.14 chen: DELETE devicve from device table and related table
    public String execute() throws Exception {
        try {//获取数据
            HttpServletRequest request = ServletActionContext.getRequest();
            request.setCharacterEncoding("utf-8");

            String did = request.getParameter("did");
            String belongid = request.getParameter("belongid");
            String belonglevel = request.getParameter("belonglevel");
            String devtype = request.getParameter("devtype");

            DeviceDAO dao = new DeviceDAOImpl();

            Boolean rt = dao.deleteOneDeviceInfoAndBelongPosition(did, belongid, belonglevel, devtype);
            JSONObject jsonObject = new JSONObject();

            if (rt) {
                jsonObject.put("提示", "删除成功！");
            } else {
                jsonObject.put("提示", "删除失败，请重试！");
            }
            result = JSON.toJSONString(jsonObject);

        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
        return "success";
    }

}