package dasturlash.uz.servlet;

import dasturlash.uz.dao.UserDao;
import dasturlash.uz.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String username = req.getParameter("username");
        String password = req.getParameter("password");


        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            req.setAttribute("error", "Username va parolni kiritish majburiy");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }


        User existingUser = userDao.findByUsername(username);
        if (existingUser != null) {
            req.setAttribute("error", "Bu username allaqachon band! Boshqasini tanlang.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }


        User newUser = new User();
        newUser.setFullName(fullName);
        newUser.setUsername(username);
        newUser.setPassword(password);

        userDao.save(newUser);


        resp.sendRedirect(req.getContextPath() + "/login");
    }
}