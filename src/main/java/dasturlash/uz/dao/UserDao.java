package dasturlash.uz.dao;

import dasturlash.uz.config.DbConfig;
import dasturlash.uz.model.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;

public class UserDao {

    public void save(User user) {
        EntityManager entityManager = DbConfig.getEntityManager();
        try {
            entityManager.getTransaction().begin();
            entityManager.persist(user);
            entityManager.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            entityManager.close();
        }
    }


    public User findByUsername(String username) {

        EntityManager entityManager = DbConfig.getEntityManager();
        try {
            return entityManager.createQuery("SELECT u FROM User u WHERE u.username = :username", User.class)
                    .setParameter("username", username)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            entityManager.close();
        }
    }
}




