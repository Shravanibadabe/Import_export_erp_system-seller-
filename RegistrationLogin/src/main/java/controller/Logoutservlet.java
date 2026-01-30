package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet implementation class Logoutservlet
 */
@WebServlet("/Logoutservlet")
public class Logoutservlet extends HttpServlet {
	
	    protected void doGet(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {

	        // Delete the port_id cookie
	        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("port_id", "");
	        cookie.setMaxAge(0);
	        response.addCookie(cookie);

	        // Invalidate session if any
	        HttpSession session = request.getSession(false);
	        if(session != null){
	            session.invalidate();
	        }

	        // Redirect to registration page
	        response.sendRedirect("login.jsp");
	    }
	}