package dasturlash.uz.dao;

import dasturlash.uz.config.DbConfig;
import dasturlash.uz.model.Todo;
import jakarta.persistence.EntityManager;

import java.util.List;

public class TodoDao {

    public void save(Todo todo) {
        EntityManager entityManager = DbConfig.getEntityManager();
        try {
            entityManager.getTransaction().begin();
            entityManager.persist(todo);
            entityManager.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            entityManager.close();
        }
    }


    public List<Todo> findAllByUserId(long userId) {
        EntityManager entityManager = DbConfig.getEntityManager();
        try {
            return entityManager.createQuery("SELECT t FROM Todo t WHERE t.user.id = :userId ORDER BY t.id DESC", Todo.class)
                    .setParameter("userId", userId)
                    .getResultList();
        } finally {
            entityManager.close();
        }
    }

    public void update(long todoId) {
        EntityManager entityManager = DbConfig.getEntityManager();
        try {
            entityManager.getTransaction().begin();

            Todo todo = entityManager.find(Todo.class, todoId);

            if (todo != null) {
                todo.setCompleted(!todo.isCompleted());
            }

            entityManager.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            entityManager.close();
        }
    }

    public void delete(long todoId) {
        EntityManager entityManager = DbConfig.getEntityManager();
        try {
            entityManager.getTransaction().begin();
            Todo todo = entityManager.find(Todo.class, todoId);
            if (todo != null) {
                entityManager.remove(todo);
            }

            entityManager.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            entityManager.close();
        }
    }


}
