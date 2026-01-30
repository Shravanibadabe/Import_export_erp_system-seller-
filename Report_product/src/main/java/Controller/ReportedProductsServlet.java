package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ReportPojo;

import java.io.IOException;
import java.util.List;

@WebServlet("/ReportedProductsServlet")
public class ReportedProductsServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		// 1. Try to get portId from request parameter first
		String portId = req.getParameter("port_id");

		// 2. If not in parameter, check cookies
		if (portId == null) {
			Cookie[] cookies = req.getCookies();
			if (cookies != null) {
				for (Cookie c : cookies) {
					if ("port_id".equals(c.getName())) {
						portId = c.getValue();
						break;
					}
				}
			}
		}

		// 3. If still null → redirect to login
		if (portId == null) {
			resp.sendRedirect("login.jsp");
			return;
		}

		// 4. Get filter, default to "all"
		String filter = req.getParameter("filter");
		if (filter == null || filter.isEmpty())
			filter = "all";

		try {
			// Fetch reports
			List<ReportPojo> reports = ReportPojo.getReports(portId, filter);
			req.setAttribute("reports", reports);
			req.setAttribute("filter", filter);
			req.setAttribute("portId", portId);
		} catch (Exception e) {
			e.printStackTrace();
			req.setAttribute("msg", "Error fetching reports");
		}

		req.getRequestDispatcher("reported_products.jsp").forward(req, resp);
	}
}
