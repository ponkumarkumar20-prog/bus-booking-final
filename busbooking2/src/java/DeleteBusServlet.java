import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import util.DBConnection;

@WebServlet("/DeleteBusServlet")
public class DeleteBusServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            res.sendRedirect("login.jsp");
            return;
        }

        String idStr = req.getParameter("id");

        if (idStr == null || idStr.isEmpty()) {
            res.sendRedirect("adminViewBus.jsp");
            return;
        }

        int id = Integer.parseInt(idStr);

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                con.prepareStatement("DELETE FROM buses WHERE bus_id=?");

            ps.setInt(1, id);
            ps.executeUpdate();

            res.sendRedirect("adminViewBus.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
