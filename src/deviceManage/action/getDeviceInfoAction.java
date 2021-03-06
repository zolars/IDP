package deviceManage.action;

import com.alibaba.fastjson.JSON;
import com.opensymphony.xwork2.ActionSupport;
import deviceManage.dao.DeviceDAO;
import deviceManage.dao.impl.DeviceDAOImpl;
import org.apache.struts2.ServletActionContext;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;


public class getDeviceInfoAction extends ActionSupport {
    private static final long serialVersionUID = 13L;
    private String result;

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }


    /* 根据设备名称查询设备其他信息
     */
    public String execute() throws Exception {
        List qstdata = new ArrayList();
        try {
            HttpServletRequest request = ServletActionContext.getRequest();
            request.setCharacterEncoding("utf-8");

            String devicetype = request.getParameter("devicetype");
            String devicename = request.getParameter("devicename");

            if (devicetype.equals("其他传感器")) {
                devicetype = "temp";
            }

            if (devicetype.equals("IDP_JC")) {
                devicetype = "IDP";
            }

            if (devicetype.equals("IDP_ZL")) {
                devicetype = "ctrl";
            }

            DeviceDAO dao = new DeviceDAOImpl();

            qstdata = dao.getDeviceDataByName(devicetype, devicename);

            result = JSON.toJSONString(qstdata);

        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        } finally {
            qstdata = null;
        }
        return "success";
    }

}
