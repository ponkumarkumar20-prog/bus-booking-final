<%@ page contentType="text/html; charset=UTF-8" %>
<%
    // success.jsp is now just a fallback — ticket.jsp is the main confirmation page.
    // If someone lands here without a bookingId, send them to myBookings.
    String bookingId = request.getParameter("bookingId");
    if (bookingId != null && !bookingId.isEmpty()) {
        response.sendRedirect("ticket.jsp?bookingId=" + bookingId);
    } else {
        response.sendRedirect("myBookings.jsp");
    }
%>
