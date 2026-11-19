package dasturlash.uz.servlet;

import dasturlash.uz.dao.UserDao;
import dasturlash.uz.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");


        User user = userDao.findByUsername(username);

        if (user == null || !user.getPassword().equals(password)) {
            req.setAttribute("error", "Username yoki parol noto'g'ri!");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }


        HttpSession session = req.getSession();
        session.setAttribute("currentUser", user);


        resp.sendRedirect(req.getContextPath() + "/todos");
    }
}