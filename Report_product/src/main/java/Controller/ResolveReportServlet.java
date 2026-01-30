package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ReportPojo;

import java.io.IOException;

@WebServlet("/ResolveReportServlet")
public class ResolveReportServlet extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String portId = null;
		Cookie[] cookies = req.getCookies();
		if (cookies != null) {
			for (Cookie c : cookies) {
				if ("port_id".equals(c.getName())) {
					portId = c.getValue();
					break;
				}
			}
		}
		if (portId == null) {
			resp.sendRedirect("http://localhost:8080/RegistrationLogin/login.jsp");
			return;
		}

		String reportIdStr = req.getParameter("report_id");
		String filter = req.getParameter("filter");
		if (filter == null || filter.isEmpty())
			filter = "all";

		try {
			int reportId = Integer.parseInt(reportIdStr);
			ReportPojo.resolveReport(reportId);
		} catch (Exception e) {
			e.printStackTrace();
		}

		resp.sendRedirect("ReportedProductsServlet?filter=" + filter);
	}
}
