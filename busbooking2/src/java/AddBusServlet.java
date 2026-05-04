import util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AddBusServlet")
public class AddBusServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            res.sendRedirect("login.jsp");
            return;
        }

        String busName     = req.getParameter("busName");
        String source      = req.getParameter("source");
        String destination = req.getParameter("destination");
        String fareParam   = req.getParameter("fare");

        // Input validation
        if (busName == null || busName.trim().isEmpty() ||
            source == null || source.trim().isEmpty() ||
            destination == null || destination.trim().isEmpty() ||
            fareParam == null || fareParam.trim().isEmpty()) {

            res.getWriter().println("Error: All fields are required.");
            return;
        }

        int fare;
        try {
            fare = Integer.parseInt(fareParam.trim());
        } catch (NumberFormatException e) {
            res.getWriter().println("Error: Fare must be a valid number.");
            return;
        }

        // Column order matches exactly: bus_name, source, destination, fare
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "INSERT INTO buses (bus_name, source, destination, fare) VALUES (?, ?, ?, ?)"
             )) {

            ps.setString(1, busName.trim());
            ps.setString(2, source.trim());
            ps.setString(3, destination.trim());
            ps.setInt(4, fare);

            ps.executeUpdate();

            res.sendRedirect("adminViewBus.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().println("Error adding bus: " + e.getMessage());
        }
    }
}