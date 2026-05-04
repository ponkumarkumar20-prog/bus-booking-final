import util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("text/html");

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE email=? AND password=?"
            );

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                HttpSession session = req.getSession();
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("name", rs.getString("name"));
                session.setAttribute("role", rs.getString("role"));

                String role = rs.getString("role");

                if ("ADMIN".equalsIgnoreCase(role)) {
                    res.sendRedirect("adminDashboard.jsp");
                } else {
                    res.sendRedirect("userDashboard.jsp");
                }

            } else {
                res.getWriter().println("<h3 style='color:red'>Invalid Email or Password</h3>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().println("<h3>Server Error: " + e.getMessage() + "</h3>");
        }
    }
}