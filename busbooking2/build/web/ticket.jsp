<%@ page import="util.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    // Auth check
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String bookingIdParam = request.getParameter("bookingId");
    if (bookingIdParam == null || bookingIdParam.isEmpty()) {
        response.sendRedirect("myBookings.jsp");
        return;
    }

    int bookingId = Integer.parseInt(bookingIdParam);
    int sessionUserId = (int) session.getAttribute("userId");

    // Fetch ticket details
    String passengerName = "";
    String source        = "";
    String destination   = "";
    String busName       = "";
    int    fare          = 0;
    int    passengers    = 0;
    String seatNumbers   = "";
    String bookingDate   = "";
    int    busId         = 0;

    Connection con = null;
    try {
        con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(
            "SELECT u.name, b.bus_name, b.source, b.destination, b.fare, " +
            "bk.passengers, bk.seat_numbers, bk.booking_date, bk.bus_id " +
            "FROM bookings bk " +
            "JOIN users u  ON bk.user_id = u.id " +
            "JOIN buses b  ON bk.bus_id  = b.bus_id " +
            "WHERE bk.booking_id = ? AND bk.user_id = ?"
        );
        ps.setInt(1, bookingId);
        ps.setInt(2, sessionUserId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            passengerName = rs.getString("name");
            busName       = rs.getString("bus_name");
            source        = rs.getString("source");
            destination   = rs.getString("destination");
            fare          = rs.getInt("fare");
            passengers    = rs.getInt("passengers");
            seatNumbers   = rs.getString("seat_numbers");
            bookingDate   = rs.getTimestamp("booking_date") != null
                            ? rs.getTimestamp("booking_date").toString() : "N/A";
            busId         = rs.getInt("bus_id");
        } else {
            response.sendRedirect("myBookings.jsp");
            return;
        }
    } finally {
        if (con != null) try { con.close(); } catch (Exception ignored) {}
    }

    int totalFare = fare * passengers;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Ticket #<%= bookingId %></title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 30px 15px;
        }

        .page-title {
            color: #fff;
            font-size: 22px;
            margin-bottom: 20px;
            text-align: center;
            letter-spacing: 1px;
        }

        /* ── TICKET WRAPPER ── */
        .ticket-wrapper {
            width: 100%;
            max-width: 560px;
        }

        .ticket {
            background: #fff;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 25px 60px rgba(0,0,0,0.5);
            position: relative;
        }

        /* Header band */
        .ticket-header {
            background: linear-gradient(135deg, #11998e, #38ef7d);
            padding: 22px 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .ticket-header .brand {
            font-size: 22px;
            font-weight: 700;
            color: #fff;
            letter-spacing: 1px;
        }

        .ticket-header .status-badge {
            background: rgba(255,255,255,0.25);
            color: #fff;
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            border: 1px solid rgba(255,255,255,0.4);
        }

        /* Route section */
        .route-section {
            background: #f8fffe;
            padding: 24px 28px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 2px dashed #d0f0e8;
        }

        .city { text-align: center; }
        .city-code {
            font-size: 32px;
            font-weight: 800;
            color: #0f3460;
            letter-spacing: 2px;
        }
        .city-name {
            font-size: 12px;
            color: #666;
            margin-top: 4px;
            text-transform: uppercase;
        }

        .route-arrow {
            display: flex;
            flex-direction: column;
            align-items: center;
            flex: 1;
            padding: 0 15px;
        }
        .bus-icon { font-size: 28px; }
        .arrow-line {
            width: 100%;
            height: 2px;
            background: linear-gradient(to right, #11998e, #38ef7d);
            border-radius: 2px;
            margin: 6px 0;
            position: relative;
        }
        .arrow-line::after {
            content: '▶';
            position: absolute;
            right: -6px;
            top: -8px;
            color: #38ef7d;
            font-size: 12px;
        }
        .bus-name-label {
            font-size: 11px;
            color: #999;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Notch cutouts */
        .notch-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
        }
        .notch {
            width: 24px;
            height: 24px;
            background: linear-gradient(135deg, #1a1a2e, #0f3460);
            border-radius: 50%;
            flex-shrink: 0;
        }
        .dashed-line {
            flex: 1;
            border-top: 2px dashed #d0d0d0;
            margin: 0 4px;
        }

        /* Details grid */
        .details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
            padding: 22px 28px;
        }

        .detail-item { }
        .detail-label {
            font-size: 11px;
            color: #999;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 4px;
        }
        .detail-value {
            font-size: 15px;
            font-weight: 600;
            color: #1a1a2e;
        }

        /* Booking ID highlight */
        .booking-id-highlight {
            background: linear-gradient(135deg, #11998e, #38ef7d);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-size: 18px;
            font-weight: 800;
        }

        /* Seats strip */
        .seats-strip {
            background: #f0fdf8;
            margin: 0 28px;
            border-radius: 10px;
            padding: 12px 16px;
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 8px;
        }
        .seats-strip .label {
            font-size: 12px;
            color: #666;
            white-space: nowrap;
        }
        .seat-badges { display: flex; flex-wrap: wrap; gap: 6px; }
        .seat-badge {
            background: linear-gradient(135deg, #11998e, #38ef7d);
            color: #fff;
            font-size: 12px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 6px;
        }

        /* Total fare */
        .fare-total {
            margin: 14px 28px 20px;
            background: #1a1a2e;
            border-radius: 10px;
            padding: 14px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .fare-total .label {
            color: #ccc;
            font-size: 13px;
        }
        .fare-total .amount {
            color: #38ef7d;
            font-size: 22px;
            font-weight: 800;
        }

        /* Barcode / QR strip */
        .barcode-section {
            border-top: 2px dashed #eee;
            padding: 16px 28px;
            text-align: center;
        }
        .barcode {
            display: flex;
            justify-content: center;
            gap: 2px;
            margin-bottom: 8px;
        }
        .barcode span {
            display: inline-block;
            height: 40px;
            background: #1a1a2e;
            border-radius: 1px;
        }
        .barcode-text {
            font-size: 11px;
            color: #aaa;
            letter-spacing: 3px;
        }

        /* Action buttons */
        .actions {
            display: flex;
            gap: 12px;
            margin-top: 22px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .btn {
            padding: 12px 22px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 7px;
        }

        .btn-print {
            background: linear-gradient(135deg, #11998e, #38ef7d);
            color: #fff;
        }
        .btn-print:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(17,153,142,0.4); }

        .btn-share {
            background: linear-gradient(135deg, #6c5ce7, #a29bfe);
            color: #fff;
        }
        .btn-share:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(108,92,231,0.4); }

        .btn-copy {
            background: linear-gradient(135deg, #fd7272, #ee5a24);
            color: #fff;
        }
        .btn-copy:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(238,90,36,0.4); }

        .btn-back {
            background: rgba(255,255,255,0.15);
            color: #fff;
            border: 1px solid rgba(255,255,255,0.3);
        }
        .btn-back:hover { background: rgba(255,255,255,0.25); }

        /* Toast notification */
        .toast {
            position: fixed;
            bottom: 30px;
            left: 50%;
            transform: translateX(-50%) translateY(100px);
            background: #11998e;
            color: white;
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 14px;
            transition: transform 0.4s ease;
            z-index: 9999;
            box-shadow: 0 8px 20px rgba(0,0,0,0.3);
        }
        .toast.show { transform: translateX(-50%) translateY(0); }

        /* Print styles */
        @media print {
            body {
                background: #fff !important;
                padding: 0;
            }
            .actions, .page-title, .toast { display: none !important; }
            .ticket {
                box-shadow: none;
                border: 1px solid #ddd;
            }
            .notch { background: #333 !important; }
            .fare-total { background: #1a1a2e !important; -webkit-print-color-adjust: exact; }
        }
    </style>
</head>
<body>

<p class="page-title">🎫 Your Booking is Confirmed!</p>

<div class="ticket-wrapper">
    <!-- ══ TICKET ══ -->
    <div class="ticket" id="ticketCard">

        <!-- Header -->
        <div class="ticket-header">
            <div class="brand">🚌 BusGo</div>
            <div class="status-badge">✔ CONFIRMED</div>
        </div>

        <!-- Route -->
        <div class="route-section">
            <div class="city">
                <div class="city-code"><%= source.length() >= 3 ? source.substring(0,3).toUpperCase() : source.toUpperCase() %></div>
                <div class="city-name"><%= source %></div>
            </div>

            <div class="route-arrow">
                <div class="bus-icon">🚌</div>
                <div class="arrow-line"></div>
                <div class="bus-name-label"><%= busName %></div>
            </div>

            <div class="city">
                <div class="city-code"><%= destination.length() >= 3 ? destination.substring(0,3).toUpperCase() : destination.toUpperCase() %></div>
                <div class="city-name"><%= destination %></div>
            </div>
        </div>

        <!-- Notch divider -->
        <div class="notch-row">
            <div class="notch"></div>
            <div class="dashed-line"></div>
            <div class="notch"></div>
        </div>

        <!-- Details grid -->
        <div class="details-grid">
            <div class="detail-item">
                <div class="detail-label">Booking ID</div>
                <div class="detail-value booking-id-highlight">#BK<%= String.format("%06d", bookingId) %></div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Passenger Name</div>
                <div class="detail-value"><%= passengerName %></div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Bus ID</div>
                <div class="detail-value">BUS-<%= busId %></div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Passengers</div>
                <div class="detail-value"><%= passengers %> Person<%= passengers > 1 ? "s" : "" %></div>
            </div>
            <div class="detail-item" style="grid-column: span 2;">
                <div class="detail-label">Booking Date & Time</div>
                <div class="detail-value" style="font-size:13px;"><%= bookingDate %></div>
            </div>
        </div>

        <!-- Seat badges -->
        <div class="seats-strip">
            <span class="label">🪑 Seats:</span>
            <div class="seat-badges">
                <%
                    String[] seats = seatNumbers.split(",");
                    for (String seat : seats) {
                        seat = seat.trim();
                        if (!seat.isEmpty()) {
                %>
                    <span class="seat-badge"><%= seat %></span>
                <%
                        }
                    }
                %>
            </div>
        </div>

        <!-- Total fare -->
        <div class="fare-total">
            <span class="label">Total Fare (<%= passengers %> × ₹<%= fare %>)</span>
            <span class="amount">₹<%= totalFare %></span>
        </div>

        <!-- Barcode strip -->
        <div class="barcode-section">
            <div class="barcode" id="barcode"></div>
            <div class="barcode-text">BK<%= String.format("%06d", bookingId) %> &nbsp;•&nbsp; <%= source.toUpperCase() %> → <%= destination.toUpperCase() %></div>
        </div>

    </div><!-- end .ticket -->

    <!-- Action buttons -->
    <div class="actions">
        <button class="btn btn-print" onclick="printTicket()">🖨️ Print Ticket</button>
        <button class="btn btn-share" onclick="shareTicket()">📤 Share Ticket</button>
        <button class="btn btn-copy"  onclick="copyTicketText()">📋 Copy Details</button>
        <a href="myBookings.jsp"  class="btn btn-back">📋 My Bookings</a>
        <a href="userDashboard.jsp" class="btn btn-back">🏠 Dashboard</a>
    </div>
</div>

<!-- Toast -->
<div class="toast" id="toast"></div>

<script>
    // ── Generate decorative barcode bars ──
    (function() {
        const bc = document.getElementById('barcode');
        const seed = <%= bookingId %>;
        const widths = [1,2,3,1,2,1,3,2,1,2,3,1,2,1,2,3,1,2,1,3,2,1,2,3,1,2,1,2,3,1,2,1,3,2,1,2,1,2,3,1];
        for (let i = 0; i < widths.length; i++) {
            const bar = document.createElement('span');
            bar.style.width  = ((widths[(i + seed) % widths.length]) * 2 + 1) + 'px';
            bar.style.opacity = (i % 3 === 0) ? '0.5' : '1';
            bc.appendChild(bar);
        }
    })();

    // ── Print ──
    function printTicket() {
        window.print();
    }

    // ── Toast helper ──
    function showToast(msg) {
        const t = document.getElementById('toast');
        t.textContent = msg;
        t.classList.add('show');
        setTimeout(() => t.classList.remove('show'), 3000);
    }

    // ── Web Share API (mobile-friendly) ──
    function shareTicket() {
        const text =
            "🎫 Bus Ticket — BusGo\n" +
            "──────────────────────\n" +
            "Booking ID : #BK<%= String.format("%06d", bookingId) %>\n" +
            "Passenger  : <%= passengerName %>\n" +
            "Route      : <%= source %> → <%= destination %>\n" +
            "Bus        : <%= busName %>\n" +
            "Seats      : <%= seatNumbers %>\n" +
            "Passengers : <%= passengers %>\n" +
            "Total Fare : ₹<%= totalFare %>\n" +
            "Date       : <%= bookingDate %>\n" +
            "──────────────────────\n" +
            "Booked via BusGo 🚌";

        if (navigator.share) {
            navigator.share({
                title : "Bus Ticket #BK<%= String.format("%06d", bookingId) %>",
                text  : text
            }).then(() => showToast("✅ Ticket shared!"))
              .catch(err => {
                  if (err.name !== 'AbortError') {
                      fallbackCopy(text, "Ticket details copied — paste to share!");
                  }
              });
        } else {
            fallbackCopy(text, "📋 Ticket details copied — paste to share!");
        }
    }

    // ── Copy ticket as text ──
    function copyTicketText() {
        const text =
            "🎫 Bus Ticket — BusGo\n" +
            "Booking ID : #BK<%= String.format("%06d", bookingId) %>\n" +
            "Passenger  : <%= passengerName %>\n" +
            "Route      : <%= source %> → <%= destination %>\n" +
            "Bus        : <%= busName %>\n" +
            "Seats      : <%= seatNumbers %>\n" +
            "Passengers : <%= passengers %>\n" +
            "Total Fare : ₹<%= totalFare %>\n" +
            "Date       : <%= bookingDate %>";
        fallbackCopy(text, "📋 Details copied to clipboard!");
    }

    function fallbackCopy(text, successMsg) {
        if (navigator.clipboard && window.isSecureContext) {
            navigator.clipboard.writeText(text)
                .then(() => showToast(successMsg))
                .catch(() => execCopy(text, successMsg));
        } else {
            execCopy(text, successMsg);
        }
    }

    function execCopy(text, successMsg) {
        const ta = document.createElement('textarea');
        ta.value = text;
        ta.style.cssText = 'position:fixed;top:-9999px;left:-9999px;opacity:0;';
        document.body.appendChild(ta);
        ta.focus(); ta.select();
        try {
            document.execCommand('copy');
            showToast(successMsg);
        } catch (e) {
            showToast("⚠️ Could not copy. Please copy manually.");
        }
        document.body.removeChild(ta);
    }
</script>

</body>
</html>
