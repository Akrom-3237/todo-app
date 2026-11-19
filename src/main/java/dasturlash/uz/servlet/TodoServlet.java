package dasturlash.uz.servlet;

import dasturlash.uz.dao.TodoDao;
import dasturlash.uz.model.Todo;
import dasturlash.uz.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/todos")
public class TodoServlet extends HttpServlet {

    private final TodoDao todoDao = new TodoDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<Todo> todos = todoDao.findAllByUserId(currentUser.getId());
        req.setAttribute("todos", todos);

        req.getRequestDispatcher("/todos.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            String title = req.getParameter("title");
            if (title != null && !title.isBlank()) {
                Todo todo = new Todo();
                todo.setTitle(title);
                todo.setCompleted(false);
                todo.setUser(currentUser);
                todoDao.save(todo);
            }
        } else if ("update".equals(action)) {
            Long todoId = Long.parseLong(req.getParameter("id"));
            todoDao.update(todoId);
        } else if ("delete".equals(action)) {
            Long todoId = Long.parseLong(req.getParameter("id"));
            todoDao.delete(todoId);
        }

        resp.sendRedirect(req.getContextPath() + "/todos");
    }
}