

import util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/BookSeatServlet")
public class BookSeatServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String seat = req.getParameter("seat");
        String name = req.getParameter("name");

        // ✅ Validation
        if (seat == null || name == null || name.trim().isEmpty()) {
            res.getWriter().println("Invalid input!");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();

            String query = "INSERT INTO booking(seat_number, passenger_name) VALUES (?, ?)";
            ps = con.prepareStatement(query);

            ps.setString(1, seat);
            ps.setString(2, name);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                // ✅ Pass data to success page
                res.sendRedirect("success.jsp?seat=" + seat + "&name=" + name);
            } else {
                res.getWriter().println("Booking failed!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().println("Error: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}