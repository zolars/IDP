package userManage.action;

import Util.ToHex;
import com.opensymphony.xwork2.ActionSupport;
import hibernatePOJO.User;
import org.apache.struts2.ServletActionContext;
import userManage.dao.UserDAO;
import userManage.dao.impl.UserDAOImpl;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.List;

public class UserLoginAction extends ActionSupport {
    private static final long serialVersionUID = 12L;

    private String username;
    private String password;

    public String getUsername() {
        return username;
    }


    public void setUsername(String username) {
        this.username = username;
    }


    public String getPassword() {
        return password;
    }


    public void setPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] bytes = md.digest(password.getBytes("utf-8"));
            String passwd = ToHex.toHex(bytes);
            this.password = passwd;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /*
       1.登录验证过程，获取username及将uid放到session
       2.若登录成功，获取用户所拥有权限对应的界面，放到session
     */
    public String execute() throws Exception {

        HttpServletRequest request = ServletActionContext.getRequest();
        HttpSession session = request.getSession();

        User user = new User();

        user.setUname(username);
        user.setPassword(password);

        UserDAO dao = new UserDAOImpl();
        if (dao.login(user)) {
            String userid = dao.getUserId(user);
            String rid = dao.getUserRolesByUid(userid).getRid();
            user.setRid(rid);
            session.setAttribute("userrole", rid);

            if (userid != "") {
                session.setMaxInactiveInterval(604800);
                session.setAttribute("userid", userid);
                session.setAttribute("username", username);
                user.setUid(userid);

                List menulist = new ArrayList();
                List mlist = new ArrayList();
                mlist = dao.getUserDynamicMenu(user);

                //为保证顺序，对mlist进行排序，5放在开始位置，后面顺序不管
                for(int i = 0; i < mlist.size(); i++) {
                    String temp = mlist.get(0).toString();
                    if(mlist.get(i).equals("5")) {
                        mlist.set(i, temp);
                        mlist.set(0, "5");
                    }
                }

                for (int i = 0; i < mlist.size(); i++) {
                    String s = (String) mlist.get(i);
                    switch (s) {
                        case "5":
                            menulist.add("province.jsp");
                            menulist.add("onlineDetect.jsp");
                            menulist.add("history.jsp");
                            menulist.add("efficiencyAnalysis.jsp");
                            menulist.add("efficiencyDevice.jsp");
                            // menulist.add("efficiencyAssessment.jsp");
                            menulist.add("reportChart.jsp");
                            break;
                        case "1":
                            menulist.add("systemMng.jsp/item8");
                            break;
                        case "2":
                            menulist.add("systemMng.jsp/item1");
                            break;
                        case "3":
                            menulist.add("systemMng.jsp/item6");
                            break;
                        case "4":
                            menulist.add("systemMng.jsp/item4");
                            break;
                        case "6":
                            menulist.add("systemMng.jsp/item9");
                            break;
                        case "7":
                            menulist.add("systemMng.jsp/item2");
                            break;
                        case "8":
                            menulist.add("systemMng.jsp/item3");
                            break;
                        case "9":
                            menulist.add("systemMng.jsp/item7");
                            break;
                        case "10":
                            menulist.add("systemMng.jsp/item4/secsubItem1");
                            break;
                        case "11":
                            menulist.add("systemMng.jsp/item4/secsubItem2");
                            break;
                        case "12":
                            menulist.add("systemMng.jsp/item4/secsubItem3");
                            break;
                        case "13":
                            menulist.add("systemMng.jsp/item4/secsubItem4");
                            break;
                        case "14":
                            menulist.add("systemMng.jsp/item4/secsubItem5");
                            break;
                        case "15":
                            menulist.add("systemMng.jsp/item4/secsubItem6");
                            break;
                        case "16":
                            menulist.add("systemMng.jsp/item6/trisubItem1");
                            break;
                        case "17":
                            menulist.add("systemMng.jsp/item6/trisubItem2");
                            break;
                        case "18":
                            menulist.add("systemMng.jsp/item6/trisubItem3");
                            break;
                        default:
                            break;
                    }
                }

                //remove deplicate url
                for (int i = 0; i < menulist.size() - 1; i++) {
                    for (int j = menulist.size() - 1; j > i; j--) {
                        if (menulist.get(j).equals(menulist.get(i))) {
                            menulist.remove(j);
                        }
                    }
                }
                session.setAttribute("menulist", menulist);
            }
            return "success";
        }
        return "failure";
    }

}
