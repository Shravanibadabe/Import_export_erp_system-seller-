package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.User;
import dao.UserDAO;

@WebServlet("/ProfileController")
public class ProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String portId = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("port_id".equals(c.getName())) {
                    portId = c.getValue();
                    break;
                }
            }
        }

        if (portId == null) {
            response.sendRedirect("http://localhost:8080/RegistrationLogin/login.jsp");
            return;
        }

        User user = userDAO.getUserByPortId(portId);
        request.setAttribute("user", user);
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String portId = request.getParameter("portid") != null ? request.getParameter("portid").trim() : "";
        String name = request.getParameter("sname") != null ? request.getParameter("sname").trim() : "";
        String email = request.getParameter("semail") != null ? request.getParameter("semail").trim() : "";
        String password = request.getParameter("spassword") != null ? request.getParameter("spassword").trim() : "";
        String location = request.getParameter("slocation") != null ? request.getParameter("slocation").trim() : "";

        String action = request.getParameter("update") != null ? "update" : "delete";
        String msg = "";

        if ("update".equals(action)) {
            User existing = userDAO.getUserByPortId(portId);

            if (existing != null) {
                name = name.isEmpty() ? existing.getName() : name;
                email = email.isEmpty() ? existing.getEmail() : email;
                password = password.isEmpty() ? existing.getPassword() : password;
                location = location.isEmpty() ? existing.getLocation() : location;

                // Validations
                if (!name.equals(existing.getName()) && !userDAO.isValidName(name)) {
                    msg = "Invalid Name. Only letters and spaces allowed.";
                } else if (!location.equals(existing.getLocation()) && !userDAO.isValidLocation(location)) {
                    msg = "Invalid Location. Only letters and spaces allowed.";
                } else if (!email.equals(existing.getEmail()) && !userDAO.isValidEmail(email)) {
                    msg = "Invalid Email format.";
                } else if (!password.equals(existing.getPassword()) && !userDAO.isValidPassword(password)) {
                    msg = "Password must be min 8 chars, include uppercase, lowercase, number & special char.";
                } else {
                    User updatedUser = new User();
                    updatedUser.setPortId(portId);
                    updatedUser.setName(name);
                    updatedUser.setEmail(email);
                    updatedUser.setPassword(password);
                    updatedUser.setLocation(location);

                    msg = userDAO.updateUser(updatedUser);
                }
            } else {
                msg = "User not found!";
            }

        } else if ("delete".equals(action)) {
            boolean deleted = userDAO.deleteUser(portId);
            if (deleted) {
                Cookie cookie = new Cookie("port_id", "");
                cookie.setMaxAge(0);
                cookie.setPath("/");
                response.addCookie(cookie);
                response.sendRedirect("http://localhost:8080/RegistrationLogin/register.jsp");
                return;
            } else {
                msg = "Delete failed!";
            }
        }

        request.setAttribute("msg", msg);
        doGet(request, response); // reload profile page
    }
}