package Util;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;

import java.security.PrivateKey;
import java.util.List;
import java.util.Properties;
import Util.AESUtil;

public class HBSessionDaoImpl implements HBSessionDao{
    private static SessionFactory sessionFactory;
    private static Session onlineSession;

    static {
        //创建配置对象
        Configuration cfg = new Configuration().configure("/hibernate.cfg.xml");
        //decode password
        Properties props = cfg.getProperties();
        String username = cfg.getProperty("connection.username");
        String password = cfg.getProperty("connection.password");

        String key = "12345678";
        byte[] s = new byte[8]; //s 为密文
        s[0] = (byte)23;
        s[1] = (byte)38;
        s[2] = (byte)64;
        s[3] = (byte)-35;
        s[4] = (byte)80;
        s[5] = (byte)-128;
        s[6] = (byte)118;
        s[7] = (byte)37;

        byte[] deMsgBytes = AESUtil.decrypt(s,key.getBytes());

        props.setProperty("connection.username", new String(deMsgBytes));
        props.setProperty("connection.password", new String(deMsgBytes));
        props.setProperty("hibernate.connection.username", new String(deMsgBytes));
        props.setProperty("hibernate.connection.password", new String(deMsgBytes));

        //创建服务注册对象
        StandardServiceRegistry serviceRegistry = new StandardServiceRegistryBuilder()
                .applySettings(props).build();
        //创建会话工厂对象
        sessionFactory = cfg.buildSessionFactory(serviceRegistry);
        onlineSession = sessionFactory.openSession();
    }

    public Session getOnlineSession() {
        return onlineSession;
    }

    @Override
    public List search(String hql) {
        Session session = sessionFactory.openSession();
        Transaction transaction = session.beginTransaction();
      /*  List alist = null;
        alist = session.createQuery(hql).list();*/
        Query query = session.createQuery(hql);
        List alist = query.list();

        if (alist.size() == 0) {
            transaction.commit();
            session.close();
            return null;
        } else {
            transaction.commit();
            session.close();
            return alist;
        }
    }

    @Override
    public List searchWithNum(String hql, int num) {
        //查询不用事务管理
        Session session = sessionFactory.openSession();
        Transaction transaction = session.beginTransaction();
        Query query = session.createQuery(hql);
        query.setMaxResults(num);
        List alist = query.list();
        transaction.commit();
        session.close();
        return alist;
    }

    @Override
    public Object getFirst(String hql) {
        //查询不用事务管理
        Session session = sessionFactory.openSession();
        Transaction transaction = session.beginTransaction();
        List alist = null;
        Object aobject = null;
        alist = session.createQuery(hql).list();

        if (alist.size() == 0) {
            transaction.commit();
            session.close();
            return null;
        } else {
            transaction.commit();
            aobject = alist.get(0);
            session.close();
            return aobject;
        }
    }

    public List getAll(String hql) {
        //查询不用事务管理
        Session session = sessionFactory.openSession();
        Transaction transaction = session.beginTransaction();
        List alist = null;
        Object aobject = null;
        alist = session.createQuery(hql).list();

        if (alist.size() == 0) {
            transaction.commit();
            session.close();
            return null;
        } else {
            transaction.commit();
            session.close();
            return alist;
        }
    }

    //使用HQL语句删除数据
    @Override
    public boolean delete(String hql, String id) {
        try {
            Session session = sessionFactory.openSession();
            Transaction transaction = session.beginTransaction();
            Query q = session.createQuery(hql);
            q.setString(0, id);
            q.executeUpdate();
            transaction.commit();
            session.close();

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    //使用HQL语句插入数据
    @Override
    public boolean insert(Object obj) {
        Session session = sessionFactory.openSession();
        Transaction transaction;
        try {
            transaction = session.beginTransaction();
            session.save(obj);
            transaction.commit();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            session.close();
        }
        return true;
    }

    //使用HQL语句更新数据Object obj
    public boolean update(String hql) {
        try {
            Session session = sessionFactory.openSession();
            Transaction transaction = session.beginTransaction();
            Query q = session.createQuery(hql);
            q.executeUpdate();
            transaction.commit();
            session.close();

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

}
