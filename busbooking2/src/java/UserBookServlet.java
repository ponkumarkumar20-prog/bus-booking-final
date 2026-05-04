import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import util.DBConnection;

@WebServlet("/UserBookServlet")
public class UserBookServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            int busId      = Integer.parseInt(req.getParameter("busId"));
            int passengers = Integer.parseInt(req.getParameter("passengers"));
            String seatNumbers = req.getParameter("seatNumbers");

            con = DBConnection.getConnection();

            // Insert booking and retrieve generated booking ID
            ps = con.prepareStatement(
                "INSERT INTO bookings (user_id, bus_id, passengers, seat_numbers) VALUES (?, ?, ?, ?)",
                PreparedStatement.RETURN_GENERATED_KEYS
            );

            ps.setInt(1, userId);
            ps.setInt(2, busId);
            ps.setInt(3, passengers);
            ps.setString(4, seatNumbers);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int bookingId = rs.getInt(1);
                    // Redirect to ticket page with bookingId
                    res.sendRedirect("ticket.jsp?bookingId=" + bookingId);
                } else {
                    res.sendRedirect("userDashboard.jsp");
                }
            } else {
                res.getWriter().println("Booking failed!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().println("Error: " + e.getMessage());

        } finally {
            try { if (rs  != null) rs.close();  } catch (Exception ignored) {}
            try { if (ps  != null) ps.close();  } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}
