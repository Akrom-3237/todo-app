package dasturlash.uz.config;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class DbConfig {

    private static final EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("todo-pu");

    public static EntityManager getEntityManager(){
        return entityManagerFactory.createEntityManager();
    }
}
