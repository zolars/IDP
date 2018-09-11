package systemMng.action;


import com.alibaba.fastjson.JSONObject;
import com.opensymphony.xwork2.ActionSupport;
import hibernatePOJO.RolesPermission;
import org.apache.struts2.ServletActionContext;
import systemMng.dao.PermissionDAO;
import systemMng.dao.impl.PermissionDAOImpl;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

//import hibernatePOJO.UserPermission;
//import net.sf.json.JSON;
//import net.sf.json.JSONObject;


public class getOneRolesFunctionsAction extends ActionSupport {
    //private static final long serialVersionUID = 13L;
    private JSONObject result;

    public JSONObject getResult() {
        return result;
    }

    public void setResult(JSONObject result) {
        this.result = result;
    }

    /* 查询角色拥有的功能
     */
    public String execute() throws Exception {
        try {//获取数据
            HttpServletRequest request = ServletActionContext.getRequest();
            HttpSession session = request.getSession();
            request.setCharacterEncoding("utf-8");

            String rid = request.getParameter("rid");

            PermissionDAO dao = new PermissionDAOImpl();
            RolesPermission ptree = dao.getRolesPermissionTree(rid);

            String pstr = ptree.getPid();
            String pset[] = pstr.split(",");

            List<String> rtlist = new ArrayList<>();

            for(int i = 0 ; i < pset.length; i++){
                System.out.println(pset[i]);
                rtlist.add(pset[i]);
            }

            JSONObject jsonObject = new JSONObject();
            jsonObject.put("allrptree", rtlist);

            result = jsonObject;
            //result = JSON.toJSONString(jsonObject);

        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
        return "success";
    }

}