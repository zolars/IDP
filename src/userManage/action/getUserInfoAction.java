package userManage.action;


import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.opensymphony.xwork2.ActionSupport;
import hibernatePOJO.User;
import hibernatePOJO.UserRoles;
import org.apache.struts2.ServletActionContext;
import userManage.dao.UserDAO;
import userManage.dao.impl.UserDAOImpl;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

//import hibernatePOJO.UserPermission;
//import net.sf.json.JSON;
//import net.sf.json.JSONObject;


public class getUserInfoAction extends ActionSupport {
    private static final long serialVersionUID = 13L;
    private String result;

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }


    /* 查询所有用户的基本信息、用户角色、用户权限
     */
    public String execute() throws Exception { //getUserTree() throws Exception{
        try {//获取数据
            HttpServletRequest request = ServletActionContext.getRequest();
            HttpSession session = request.getSession();
            request.setCharacterEncoding("utf-8");

            UserDAO dao = new UserDAOImpl();
            List<List> alluser = dao.getAllUserInfo();

            //处理 ：undefined 转为 空
            //      组织转为组织名称
            for(int i = 0; i < alluser.size(); i++){
                    List tmpur = alluser.get(i);
                    String prob = "";
                    String cityb = "";
                    String computerrom = "";
                    String role = "";

                    if (tmpur.get(3) == null)
                        prob = "";
                    else
                        prob = dao.getProBankName(tmpur.get(3).toString());
                    if (tmpur.get(4) == null)
                        cityb = "";
                    else
                        cityb = dao.getCityBankName(tmpur.get(4).toString());
                    if (tmpur.get(5) == null)
                        computerrom = "";
                    else
                        computerrom = dao.getComputerroomName(tmpur.get(5).toString());
                    if (tmpur.get(6) == null || tmpur.get(6) == " ")
                        role = "";
                    else
                        role = dao.getRoleName(tmpur.get(6).toString());

                    tmpur.set(3, prob);
                    tmpur.set(4, cityb);
                    tmpur.set(5, computerrom);
                    tmpur.set(6, role);
            }

            JSONObject jsonObject = new JSONObject();
            jsonObject.put("alluser", alluser);

            result = JSON.toJSONString(jsonObject);


        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
        return "success";//ERROR;
    }

}
