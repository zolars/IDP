package userManage.dao.impl;

import Util.HBSessionDaoImpl;
import hibernatePOJO.CityBank;
import hibernatePOJO.Roles;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import userManage.dao.CityDAO;

import java.util.List;

public class CityDAOImpl implements CityDAO {

    private Session session;
    private Transaction transaction;
    private Query query;
    private Object object;

    public List getAllCity(){

        HBSessionDaoImpl hbsessionDao = new HBSessionDaoImpl();

        List<CityBank> list = hbsessionDao.search(
                "FROM CityBank");

        return list;
    }


}