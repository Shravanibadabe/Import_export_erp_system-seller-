<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="java.sql.*,java.util.*" %>
         
<%
    jakarta.servlet.http.Cookie[] cookies = request.getCookies();
    String sellerPortId = null;
    if(cookies != null){
        for(jakarta.servlet.http.Cookie c : cookies){
            if("port_id".equals(c.getName())){
                sellerPortId = c.getValue();
                break;
            }
        }
    }
    if(sellerPortId == null){
        response.sendRedirect("http://localhost:8080/RegistrationLogin/login.jsp");
        return;
    }
%>
<%
    String ctx = request.getContextPath();

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    int totalOrders = 0;
    double revenue = 0.0;
    String concernName = "";
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/import_export_db?useSSL=false&serverTimezone=UTC",
                "root",
                ""
        );
        ps = conn.prepareStatement("SELECT name FROM users WHERE port_id = ?");
        ps.setString(1, sellerPortId);
        rs = ps.executeQuery();
        if (rs.next()) {
            concernName = rs.getString("name");
        }
        rs.close(); ps.close();
        // ✅ Total Orders of logged-in seller
        ps = conn.prepareStatement("SELECT COUNT(*) FROM orders WHERE seller_port_id = ?");
        ps.setString(1, sellerPortId);
        rs = ps.executeQuery();
        if (rs.next()) totalOrders = rs.getInt(1);
        rs.close(); ps.close();

        // ✅ Revenue of logged-in seller
        ps = conn.prepareStatement("SELECT COALESCE(SUM(total_amount),0) FROM orders WHERE seller_port_id = ?");
        ps.setString(1, sellerPortId);
        rs = ps.executeQuery();
        if (rs.next()) revenue = rs.getDouble(1);
        rs.close(); ps.close();

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignore) {}
        if (ps != null) try { ps.close(); } catch (Exception ignore) {}
        if (conn != null) try { conn.close(); } catch (Exception ignore) {}
    }

    String growthMsg;
    if (revenue > 5000)       growthMsg = "High Growth 🚀";
    else if (revenue >= 2000) growthMsg = "Moderate Growth 📈";
    else                      growthMsg = "Needs Improvement 📉";

    String progressMsg;
    if (revenue > 5000)       progressMsg = "You’re on fire 🔥";
    else if (revenue >= 2000) progressMsg = "Solid Growth 💪";
    else                      progressMsg = "Keep pushing 🚀";

    int target = 5000;
    double percent = Math.min((revenue / target) * 100, 100.0);

    String chartColor;
    if (revenue > 5000)       chartColor = "#4CAF50";
    else if (revenue >= 2000) chartColor = "#FF9800";
    else                      chartColor = "#F44336";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  
  <title>Sell Hub — Seller Dashboard</title>
<link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@500;700&family=Poppins:wght@400;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.css"/>

 <style>
    :root {
      --purple-1: #6a11cb; --pink: #ff6bd6; --accent: #f5a623;
      --text-soft: #bbb; --purple-2: #b670f5; --text: #fff;
    }
    * { box-sizing: border-box; }
    body { margin:0; font-family: Arial, sans-serif; background:#0e0a1f; color:#fff; overflow-x:hidden; }

    /* NAVBAR */
    .nav { position:sticky; top:0; z-index:100; backdrop-filter:blur(12px);
      background:linear-gradient(135deg, rgba(106,17,203,.65), rgba(182,112,245,.25));
      box-shadow:0 8px 30px rgba(0,0,0,.45);
    }
    .nav-inner { display:flex; align-items:center; justify-content:space-between;
      height:75px; max-width:1200px; margin:auto; padding:0 20px;
    }
    .brand { display:flex; align-items:center; gap:12px; text-decoration:none;
      font-weight:800; font-size:1.4rem; background:linear-gradient(90deg,#fff,var(--accent));
      -webkit-background-clip:text; color:transparent;
    }
    .brand-logo { width:48px; height:48px; border-radius:50%;
      border:2px solid rgba(182,112,245,.5);
      box-shadow:0 0 12px rgba(182,112,245,.6), 0 0 22px rgba(106,17,203,.4);
      animation:logoFloat 3s infinite ease-in-out, logoGlow 4s infinite ease-in-out;
      transition:transform .4s, box-shadow .4s;
    }
    .brand-logo:hover { transform:scale(1.1) rotate(5deg);
      box-shadow:0 0 18px rgba(182,112,245,.9), 0 0 28px rgba(106,17,203,.6);
    }
    @keyframes logoFloat { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-5px)} }
    @keyframes logoGlow {
      0%,100%{ box-shadow:0 0 12px rgba(182,112,245,.6),0 0 22px rgba(106,17,203,.4) }
      50%{ box-shadow:0 0 18px rgba(182,112,245,.9),0 0 30px rgba(106,17,203,.6) }
    }

    .nav-links { display:flex; align-items:center; gap:26px; }
    .nav-link {
      position:relative; text-decoration:none; color:#f0f0f5; font-weight:600; font-size:1.10rem;
      padding:10px 16px; border-radius:10px; transition:all .35s ease;
      text-shadow:0 0 6px rgba(255,255,255,.4);
    }
    .nav-link:hover {
      transform:translateY(-2px); color:#fff; background:rgba(255,255,255,.08);
      text-shadow:0 0 8px rgba(255,255,255,.9), 0 0 14px rgba(186,85,255,.6), 0 0 22px rgba(121,82,255,.4);
    }
    .nav-link::after {
      content:""; position:absolute; left:50%; bottom:-6px; width:0%; height:3px;
      background:linear-gradient(90deg,#ff00cc,#3333ff); border-radius:4px; transition:all .35s ease; transform:translateX(-50%);
    }
    .nav-link:hover::after { width:65%; }
    .nav-link.active { color:#fff; text-shadow:0 0 14px rgba(255,50,200,.9), 0 0 22px rgba(100,150,255,.7); }
    .nav-link.active::after { width:70%; }

    .nav-cta { display:flex; gap:14px; }
    .btn { padding:10px 20px; border-radius:12px; font-weight:700; font-size:.95rem; cursor:pointer;
      text-decoration:none; border:none; background:linear-gradient(135deg,#ff00cc,#3333ff); color:#fff;
      box-shadow:0 0 12px rgba(255,0,204,.6); transition:all .35s ease;
    }
    .btn:hover { transform:translateY(-2px) scale(1.05); box-shadow:0 0 18px rgba(255,0,204,.9), 0 0 25px rgba(51,51,255,.7); }
    .btn-profile { background:rgba(255,255,255,.1); border:1px solid rgba(255,255,255,.2); color:#fff; }
    .btn-profile:hover { background:rgba(255,255,255,.18); transform:translateY(-2px); }
    .btn-logout { background:linear-gradient(135deg, var(--purple-1), var(--pink)); color:#fff; box-shadow:0 6px 16px rgba(182,112,245,.4); }
    .btn-logout:hover { transform:translateY(-2px) scale(1.03); box-shadow:0 10px 22px rgba(182,112,245,.55); }
/* HEADER */
.welcome-header {
  text-align: center;
  padding: 60px 20px 80px;
  background: linear-gradient(180deg, #2b0f48 0%, #0d0d1a 100%);
  position: relative;
  overflow: hidden;
}

/* Animated gradient overlay for cinematic feel */
.welcome-header::before {
  content: "";
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle at center, rgba(255, 79, 209, 0.15) 0%, transparent 70%);
  animation: pulse 6s infinite alternate ease-in-out;
}

/* Heading */
.welcome-header h1 {
  font-size: 3rem;
  font-weight: 800;
  color: #f3e9ff;
  margin-bottom: 15px;
  text-shadow: 0px 0px 15px rgba(255, 79, 209, 0.6), 
               0px 0px 30px rgba(120, 50, 255, 0.4);
  animation: fadeInDown 1s ease forwards;
}

/* Subtext */
.welcome-header p {
  font-size: 1.2rem;
  color: #d8d8ff;
  letter-spacing: 0.5px;
  animation: fadeInUp 1.3s ease forwards;
}

.welcome-header p span {
  font-weight: 700;
  color: #ff4fd1;
  text-shadow: 0px 0px 10px rgba(255, 79, 209, 0.7);
}

/* Rocket Emoji Animation */
.welcome-header h1 span.rocket {
  display: inline-block;
  animation: rocketFloat 2s infinite ease-in-out;
}

/* ANIMATIONS */
@keyframes pulse {
  0% { transform: scale(1); opacity: 0.6; }
  100% { transform: scale(1.2); opacity: 0.3; }
}

@keyframes fadeInDown {
  0% { opacity: 0; transform: translateY(-20px); }
  100% { opacity: 1; transform: translateY(0); }
}

@keyframes fadeInUp {
  0% { opacity: 0; transform: translateY(20px); }
  100% { opacity: 1; transform: translateY(0); }
}

@keyframes rocketFloat {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-8px) rotate(5deg); }
}

    /* MAIN WRAPPER */
    .container{max-width:1200px; margin:26px auto; padding:0 16px; display:grid; gap:28px}


/* Randomized Light Sweep Motion */
@keyframes lightSweep {
  0%   { transform: translateX(-120%) rotate(5deg); opacity: 0; }
  10%  { transform: translateX(-90%) rotate(5deg); opacity: 0.5; }
  30%  { transform: translateX(-40%) rotate(5deg); opacity: 0.8; }
  40%  { transform: translateX(-20%) rotate(5deg); opacity: 0.6; }
  55%  { transform: translateX(10%) rotate(5deg);  opacity: 0.8; }
  70%  { transform: translateX(40%) rotate(5deg);  opacity: 0.4; }
  85%  { transform: translateX(80%) rotate(5deg);  opacity: 0.7; }
  100% { transform: translateX(120%) rotate(5deg); opacity: 0; }
}

/* Glowing Pulse Around Carousel */
@keyframes glowPulse {
  0%, 100% {
    box-shadow: 
      0 0 35px rgba(255,77,148,0.45),
      0 0 65px rgba(77,172,255,0.3);
  }
  50% {
    box-shadow: 
      0 0 55px rgba(255,77,148,0.7),
      0 0 95px rgba(77,172,255,0.45);
  }
}

/* Slides */
.swiper-slide {
  position: relative;
  transform: translateZ(0);
  overflow: hidden;
}

/* Ken Burns Effect */
.swiper-slide img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  animation: kenburns 12s ease-in-out infinite;
}

@keyframes kenburns {
  0%   { transform: scale(1.1) translate(0, 0); }
  50%  { transform: scale(1.2) translate(-2%, -2%); }
  100% { transform: scale(1.1) translate(0, 0); }
}

/* Overlay */
.slide-overlay {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: flex-end;
  padding: 24px;
  background: none;
}

/* Caption Glow */
.slide-caption {
  background: rgba(21,23,41,0.55);
  border: 1px solid rgba(255,255,255,.12);
  padding: 14px 18px;
  border-radius: 14px;
  max-width: 70%;
  backdrop-filter: blur(10px);
  opacity: 0;
  transform: translateY(20px) scale(0.95);
  transition: all 0.8s ease;
  box-shadow: 0 0 15px rgba(255,77,148,0.4);
}

.swiper-slide-active .slide-caption {
  opacity: 1;
  transform: translateY(0) scale(1);
  animation: captionPop 0.9s ease forwards,
             captionGlow 3s ease-in-out infinite alternate;
  animation-delay: 0.2s;
}

@keyframes captionPop {
  0% { opacity: 0; transform: translateY(30px) scale(0.95); }
  100% { opacity: 1; transform: translateY(0) scale(1); }
}

@keyframes captionGlow {
  from { box-shadow: 0 0 12px rgba(255,77,148,0.4); }
  to   { box-shadow: 0 0 22px rgba(77,172,255,0.6); }
}

.slide-caption h3 {
  margin: 0 0 6px;
  font-size: 20px;
  font-weight: 600;
  color: #fff;
  text-shadow: 0 0 8px rgba(255,77,148,0.9),
               0 0 14px rgba(77,172,255,0.6);
}

.slide-caption p {
  margin: 0;
  color: #c9c9e6;
  font-size: 14px;
  text-shadow: 0 0 6px rgba(0,0,0,0.7);
}

/* Navigation Arrows with Glow */
.swiper-button-next,
.swiper-button-prev {
  color: #fff;
  transition: transform 0.3s ease, color 0.3s ease, text-shadow 0.3s ease;
  text-shadow: 0 0 10px rgba(255,77,148,0.6);
  z-index: 3;
}

.swiper-button-next:hover,
.swiper-button-prev:hover {
  color: #ff4d94;
  text-shadow: 0 0 16px rgba(255,77,148,1),
               0 0 24px rgba(77,172,255,0.8);
  transform: scale(1.3);
}

/* Animated Glowing Pagination Dots */
.swiper-pagination-bullet {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: linear-gradient(135deg, #ff4d94, #4d96ff, #ff4d94);
  background-size: 300% 300%;
  opacity: 0.6;
  transition: all 0.3s ease;
  box-shadow: 0 0 8px rgba(255,77,148,0.6);
  animation: bulletGlow 6s ease-in-out infinite;
}

.swiper-pagination-bullet-active {
  opacity: 1;
  transform: scale(1.4);
  box-shadow: 0 0 14px rgba(255,77,148,0.9),
              0 0 22px rgba(77,172,255,0.7);
  animation: bulletGlowActive 4s ease-in-out infinite;
}

/* Animated Gradient Flow */
@keyframes bulletGlow {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

@keyframes bulletGlowActive {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}
/* ================================
   STATS — Cinematic Cards (Luxury Charcoal + Rose Gold)
================================= */
.stats {
  display: flex;
  gap: 40px;                /* proper spacing */
  justify-content: center;  /* center cards */
  margin: 20px auto 0;
  max-width: 1000px;
  flex-wrap: wrap;          /* responsive */
}

.stat-card {
  flex: 0 0 260px;
  position: relative;
  background: linear-gradient(135deg, #1E174C, #A45EBF, #E44BA8);

  background-size: 300% 300%;
  padding: 20px;
  border-radius: 16px;
  text-align: center;
  cursor: pointer;
  color: #fff;
  box-shadow: 0 0 25px rgba(183, 110, 121, 0.35); /* subtle rose-gold glow */
  transition: transform 0.4s ease, box-shadow 0.4s ease;
  overflow: hidden;
  animation: gradientShift 10s ease infinite;
}

/* Hover — cinematic lift + stronger glow */
.stat-card:hover {
  transform: translateY(-10px) scale(1.05);
  box-shadow: 0 0 35px rgba(183, 110, 121, 0.6),
              0 0 55px rgba(255, 182, 193, 0.45);
}

/* Shimmer sweep */
.stat-card::after {
  content: "";
  position: absolute;
  top: 0; left: -75%;
  width: 50%; height: 100%;
  background: linear-gradient(
    120deg,
    transparent 0%,
    rgba(255,255,255,0.25) 50%,
    transparent 100%
  );
  transform: skewX(-20deg);
  animation: shimmer 6s infinite;
}

/* Numbers */
.stat-card h2 {
  font-size: 1.9rem;
  margin: 8px 0;
  color: #fff;
  text-shadow: 0 0 10px rgba(255,255,255,0.5),
               0 0 18px rgba(183,110,121,0.9); /* rose gold glow */
  animation: numberGlow 3s ease-in-out infinite alternate;
}

/* Labels */
.stat-card p {
  font-size: 1rem;
  color: rgba(240, 240, 240, 0.85);
  letter-spacing: 0.5px;
}

/* Icon / Emoji inside card */
.stat-card .icon {
  font-size: 28px;
  display: block;
  margin: 8px 0;
  animation: iconPulse 2.5s ease-in-out infinite;
  text-shadow: 0 0 8px rgba(255, 200, 200, 0.8),
               0 0 14px rgba(183,110,121,0.8);
}

/* ✨ Bouncy Glowing Emoji */
.stat-card p .emoji {
  display: inline-block;
  font-size: 1.4rem;
  margin-left: 6px;
  filter: drop-shadow(0 0 6px rgba(255, 182, 193, 0.8));
  animation: emojiBounce 2.2s infinite ease-in-out,
             emojiGlow 3s infinite alternate;
}

/* Animations */
@keyframes gradientShift {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

@keyframes shimmer {
  0% { left: -75%; }
  50% { left: 125%; }
  100% { left: 125%; }
}

@keyframes numberGlow {
  from { text-shadow: 0 0 10px rgba(255,255,255,0.4); }
  to   { text-shadow: 0 0 18px rgba(183,110,121,1),
                     0 0 26px rgba(255,182,193,0.9); }
}

@keyframes iconPulse {
  0%, 100% { transform: scale(1); opacity: 0.85; }
  50%      { transform: scale(1.15); opacity: 1; }
}

@keyframes emojiBounce {
  0%, 100% { transform: translateY(0); }
  30% { transform: translateY(-6px) rotate(-6deg); }
  60% { transform: translateY(0) rotate(3deg); }
}

@keyframes emojiGlow {
  0% { filter: drop-shadow(0 0 4px rgba(183,110,121,0.7)); }
  100% { filter: drop-shadow(0 0 10px rgba(255,182,193,1)); }
}


  /* PROGRESS CARD (Cinematic Upgrade) */
.cinematic-heading {
  text-align: center;
  font-size: 2rem;
  font-weight: 700;
  color: #fff;
  letter-spacing: 1px;
  margin: 30px 0 10px;
  text-shadow: 0 0 15px #ff4d4d, 0 0 25px #ff9900;
  animation: fadeInDown 1.2s ease;
}

@keyframes fadeInDown {
  from {
    opacity: 0;
    transform: translateY(-30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Wrap Section */
.progress-wrap {
  display: flex;
  flex-direction: column; /* stack heading + card */
  align-items: center;    /* center everything */
  gap: 1.5rem;
  margin: 2rem 0;
}

/* Card */
.progress-card {
  text-align: center;
  background: rgba(255,255,255,0.05);
  border-radius: 24px;
  padding: 30px 24px;
   width: 500px;           /* increased width */
  min-height: 450px;     /* bigger card */
  margin: 0 auto;
  box-shadow: 0 8px 32px rgba(0,0,0,0.35);
  position: relative;
  overflow: hidden;
  animation: cardIn .6s ease both;
  backdrop-filter: blur(12px);
}

@keyframes cardIn { 
  from { opacity: 0; transform: translateY(10px) scale(0.95)} 
  to   { opacity: 1; transform: translateY(0) scale(1)} 
}

/* Circle Container */
.progress-widget {
  position: relative;
  width: 220px;
  height: 220px;
  margin: 0 auto;
}
/* SVG Circle */
.pcircle { transform: rotate(-90deg); }
.pcircle .bg {
  fill: none;
  stroke: #2a2a3d;
  stroke-width: 16;
}
.pcircle .bar {
  fill: none;
  stroke: url(#pgGrad);
  stroke-width: 16;
  stroke-linecap: round;
  stroke-dasharray: 720;
  stroke-dashoffset: 720;
  filter: drop-shadow(0 0 6px rgba(255,50,50,0.9));
  transition: stroke-dashoffset 1s ease;
}


/* Ensure progress text stays centered */
.progress-text {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);  /* perfect center */
  font-size: 2.2rem;
  font-weight: 800;
  color: #00ff88;   /* same as circle */
  text-align: center;
  text-shadow: 0 0 16px rgba(0,255,120,0.8);
  line-height: 1;   /* fixes vertical offset */
  pointer-events: none;
}


/* Progress Labels Container */
.progress-labels {
  display: grid;
  grid-template-columns: 1fr 1fr; /* Target | Progress */
  gap: 2rem; /* spacing between two columns */
  width: 100%;
  margin-top: 2rem;
  text-align: center;
}

/* Each column stacks label + value */
.progress-col {
  display: flex;
  flex-direction: column;
  align-items: center; /* center label + value */
}

/* Label (sits above value) */
.progress-col .label {
  font-size: 1rem;
  font-weight: 500;
  color: #ddd;
  display: flex;
  align-items: center;
  gap: 6px;
  margin-bottom: 0.3rem;
  justify-content: center;
}

/* Value + Button container */
.value-wrap {
  display: flex;
  align-items: center;
  gap: 6px; /* spacing between value & button */
  justify-content: center;
}

/* Value */
.value-wrap .value {
  font-weight: bold;
  font-size: 1.2rem;
  color: #ff4d94;
  text-shadow: 0 0 8px rgba(255, 77, 148, 0.8);
  white-space: nowrap;
}

/* Button */
.value-wrap button {
  background: #fff;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  padding: 4px 6px;
  transition: background 0.3s ease;
}

.value-wrap button:hover {
  background: #ff4d88;
  color: #fff;
}


/* Edit button */
#editTargetBtn {
  background: #fff;
  border: none;
  padding: 4px 6px;
  border-radius: 6px;
  cursor: pointer;
  transition: background 0.3s ease;
}

#editTargetBtn:hover {
  background: #ff4d88;
  color: #fff;
}


/* 🎬 Cinematic Values */
#targetValue, 
#progressValue {
  font-size: 1.6rem;   /* bigger than labels */
  font-weight: 200;
  color: #fff;
  text-shadow: 0 0 10px rgba(255, 0, 120, 0.8),
               0 0 20px rgba(255, 0, 120, 0.6),
               0 0 30px rgba(255, 0, 120, 0.4);
  transition: all 0.3s ease-in-out;
}

/* Hover cinematic zoom */
#targetValue:hover, 
#progressValue:hover {
  transform: scale(1.1);
  color: #ff4dff;
  text-shadow: 0 0 20px rgba(255, 77, 255, 1),
               0 0 40px rgba(255, 0, 200, 0.8);
}


/* Growth message below circle */
/* Growth Heading (Low Growth, High Growth, etc.) */
.growth-msg{
  text-align: center;
  font-size: 1.2rem;
  font-weight: 600;
  color: #cfcfcf;
  margin: 16px 0 20px 0; /* adds space above & below */
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.growth-msg.show {
  opacity: 1;
  transform: translateY(0);
}

/* Animations */
@keyframes fadeUp {
  from { opacity:0; transform: translateY(10px);}
  to   { opacity:1; transform: translateY(0);}
}/* TOP PRODUCTS - Cinematic Premium */
/* TOP PRODUCTS - Cleaner Neutral Background */
.top-products { 
  padding:60px 20px 80px; 
  background: #0d0d0d; /* Deep dark neutral background */
  text-align:center; 
  position:relative;
  overflow:hidden;
}


/* Light glow background effect */
.top-products::before {
  content:"";
  position:absolute;
  top:-100px; left:-100px;
  width:300px; height:300px;
  background:radial-gradient(circle, rgba(255,79,209,.3), transparent 70%);
  filter:blur(80px);
  animation: floatGlow 6s ease-in-out infinite alternate;
}
.top-products::after {
  content:"";
  position:absolute;
  bottom:-120px; right:-120px;
  width:300px; height:300px;
  background:radial-gradient(circle, rgba(106,17,203,.35), transparent 70%);
  filter:blur(100px);
  animation: floatGlow 8s ease-in-out infinite alternate-reverse;
}

@keyframes floatGlow {
  from { transform: translateY(0) translateX(0); }
  to { transform: translateY(-40px) translateX(40px); }
}


/* Title */
.top-products h2 { 
  font-size:2.5rem; 
  margin-bottom:36px; 
  font-weight:700;
  color:#fff; /* Pure white text */
  text-shadow:
    0 0 10px rgba(255, 79, 209, 0.8),   /* Pink glow */
    0 0 20px rgba(255, 79, 209, 0.7),
    0 0 40px rgba(155, 77, 255, 0.6),   /* Purple outer glow */
    0 0 60px rgba(155, 77, 255, 0.5);
}

/* Grid */
.product-grid { 
  display:grid; 
  grid-template-columns:repeat(auto-fit,minmax(240px,1fr)); 
  gap:32px; 
  max-width:1150px; 
  margin:auto; 
}

/* Product Card */
.product-card { 
  background:#fff; 
  color:#000; 
  border-radius:18px; 
  overflow:hidden; 
  box-shadow:0 8px 22px rgba(0,0,0,.35);
  transform:translateY(40px) scale(.96); 
  transition:transform .6s cubic-bezier(0.25, 1, 0.5, 1), 
             box-shadow .6s ease, 
             opacity .6s ease;
  cursor:pointer; 
  opacity:0;
  perspective:1000px;
}

.product-card.visible { 
  opacity:1; 
  transform:translateY(0) scale(1); 
}

/* Hover = cinematic depth */
.product-card:hover { 
  transform: translateY(-8px) scale(1.05) rotateX(2deg) rotateY(2deg);
  box-shadow:0 18px 50px rgba(225,21,132,.6);
}

/* Image */
.product-card img { 
  width:100%; 
  height:220px; 
  object-fit:cover; 
  display:block; 
  transition: transform .6s ease;
}
.product-card:hover img {
  transform: scale(1.08);
}

/* Info */
.product-info { 
  padding:18px 18px 22px; 
}

.product-info h3 { 
  font-size:1.15rem; 
  margin:0 0 10px; 
  font-weight:700;
}

.product-info p { 
  font-weight:800; 
  font-size:1.25rem; 
  margin:0; 
  background: linear-gradient(90deg,#ff4fd1,#8e44ff);
  -webkit-background-clip:text;
  -webkit-text-fill-color:transparent;
  text-shadow:0 0 12px rgba(255,79,209,.5);
}


    /* SIDEBAR (Notes/To-Do) */
   /* SIDEBAR TOGGLE BUTTON */
#sidebarToggle {
  position: fixed;
  right: 20px;
  bottom: 20px;
  z-index: 10000;
  background: #ffffff; /* button stays white */
  border: 2px solid #d633ff; /* purple-pink border */
  color: #d633ff; /* icon color (hamburger lines) */
  font-size: 1.6rem;
  padding: 14px 20px;
  border-radius: 50%;
  box-shadow: 0 0 12px rgba(214, 51, 255, 0.8), 0 4px 12px rgba(0,0,0,0.4);
  cursor: pointer;
  transition: 0.3s ease;
  text-shadow: 0 0 8px rgba(255, 51, 204, 0.9), 0 0 16px rgba(214, 51, 255, 0.7); /* purple-pink glow */
}

#sidebarToggle:hover {
  transform: scale(1.15) rotate(8deg);
  box-shadow: 0 0 20px rgba(214, 51, 255, 1), 0 6px 18px rgba(0,0,0,0.5);
  text-shadow: 0 0 12px rgba(255, 51, 204, 1), 0 0 28px rgba(214, 51, 255, 1); /* stronger glow */
}


/* SIDEBAR BASE */
.sidebar {
  position: fixed;
  top: 0;
  right: -380px;
  width: 360px;
  height: 100%;
  background: rgba(10, 15, 30, 0.98); /* deep navy */
  backdrop-filter: blur(20px);
  box-shadow: -5px 0 25px rgba(0, 0, 0, 0.6);
  border-left: 2px solid rgba(255, 255, 255, 0.15); /* silver accent */
  transition: right .5s ease;
  z-index: 998;
  overflow-y: auto;
  color: #f8fafc;
  border-radius: 16px 0 0 16px;
}
.sidebar.active { right: 0; }

/* HEADER */
.sidebar-header {
  padding: 20px;
  font-size: 1.5rem;
  font-weight: 700;
  color: #e2e8f0; /* silver white */
  text-align: center;
  letter-spacing: 1px;
}

 /* TABS */
    .sidebar-tabs {
      display: flex;
      border-bottom: 1px solid rgba(255,255,255,.08);
    }
    .sidebar-tabs button {
      flex: 1;
      padding: 12px;
      border: none;
      background: rgba(255, 255, 255, 0.05);
      color: #cbd5e1;
      font-weight: 600;
      cursor: pointer;
      transition: .3s;
    }
    .sidebar-tabs button.active {
      background: linear-gradient(135deg, #94a3b8, #e2e8f0); /* silver gradient */
      color: #0f172a;
      font-weight: 700;
    }
    .sidebar-tabs button:hover {
      color: #e2e8f0;
    }

    /* CONTENT */
    .sidebar-content {
      padding: 20px;
    }
    .tab-content {
      display: none;
      animation: fadeIn .5s ease;
    }
    .tab-content.active { display: block; }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    /* INPUTS */
    .tab-content input {
      width: 100%;
      padding: 12px 14px;
      border-radius: 10px;
      border: none;
      margin-bottom: 10px;
      background: #1e293b;
      color: #f1f5f9;
      outline: none;
      transition: 0.3s;
    }
    .tab-content input:focus {
      background: #0f172a;
      box-shadow: 0 0 6px rgba(255, 255, 255, 0.6);
    }

    /* ADD BUTTONS */
    .tab-content button.addBtn {
      display: inline-block;
      width: 100%;
      padding: 10px;
      background: linear-gradient(135deg, #94a3b8, #e2e8f0); /* silver */
      color: #0f172a;
      font-weight: 700;
      border: none;
      border-radius: 10px;
      cursor: pointer;
      transition: .3s;
      margin-bottom: 15px;
    }
    .tab-content button.addBtn:hover {
      background: linear-gradient(135deg, #e2e8f0, #f8fafc);
      box-shadow: 0 0 10px rgba(255, 255, 255, 0.8);
    }

    /* LISTS (Notes & To-Do items) */
    .tab-content ul {
      list-style: none;
      padding: 0;
    }
    .tab-content li {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background: rgba(255, 255, 255, 0.06);
      padding: 12px 14px;
      border-radius: 12px;
      margin-bottom: 12px;
      color: #f1f5f9;
      transition: 0.3s;
      box-shadow: 0 2px 6px rgba(0,0,0,0.4);
    }
    .tab-content li:hover {
      background: rgba(255, 255, 255, 0.1);
      transform: translateX(3px);
    }

    /* DELETE + EDIT ICONS */
    .tab-content li button {
      all: unset; /* reset */
      cursor: pointer;
      font-size: 1.3rem;
      margin-left: 12px;
      transition: .3s;
    }
    .tab-content li button.deleteBtn {
      color: #f87171;
    }
    .tab-content li button.deleteBtn:hover {
      color: #fca5a5;
      transform: scale(1.2);
    }
    .tab-content li button.editBtn {
      color: #facc15;
    }
    .tab-content li button.editBtn:hover {
      color: #fde047;
      transform: scale(1.2);
    }

    /* TO-DO CHECKBOXES */
    .tab-content li input[type="checkbox"] {
      accent-color: #e2e8f0;
      margin-right: 10px;
      transform: scale(1.2);
    }
    .tab-content li.completed {
      text-decoration: line-through;
      color: #94a3b8;
    }

    /* TOAST */
    .toast {
      position: fixed;
      bottom: 20px;
      right: 20px;
      background: #4caf50;
      color: #fff;
      padding: 10px 20px;
      border-radius: 5px;
      opacity: 0;
      transition: opacity 0.5s;
      z-index: 1000;
    }
    .toast.show { opacity:1; }
  

   /* ✨ MOTIVATION POPUP */
#motivationPopup{
  position:fixed;
  top:20px;
  left:50%;
  transform:translateX(-50%) scale(.96);
  background:linear-gradient(135deg,#6a11cb,#ff6bd6);
  color:#fff;
  font:600 1.05rem/1.4 system-ui, -apple-system, Segoe UI, Roboto, sans-serif;
  padding:16px 26px;
  border-radius:14px;
  box-shadow:0 0 18px rgba(255,105,255,.7), 0 6px 20px rgba(0,0,0,.35);
  text-align:center;
  max-width:440px;
  z-index:100000;           /* sits above everything */
  display:none;             /* default hidden */
  opacity:0;
  pointer-events:auto;
}
#motivationPopup.show{
  display:block !important; /* override any inline display */
  animation:popupFade .45s ease forwards, glowPulse 2s ease-in-out infinite;
}
#motivationPopup .close-btn{
  position:absolute; top:6px; right:10px;
  font-size:1.2rem; line-height:1;
  cursor:pointer; opacity:.85; transition:.2s;
}
#motivationPopup .close-btn:hover{ opacity:1; transform:scale(1.15); }

@keyframes popupFade{
  from{ opacity:0; transform:translateX(-50%) translateY(-8px) scale(.96); }
  to{   opacity:1; transform:translateX(-50%) translateY(0)     scale(1); }
}
@keyframes glowPulse{
  0%,100%{ box-shadow:0 0 14px rgba(255,105,255,.7), 0 6px 18px rgba(0,0,0,.4); }
  50%{    box-shadow:0 0 24px rgba(255,105,255,1), 0 8px 24px rgba(0,0,0,.55); }
}

/* ==============================
   RESPONSIVE DESIGN
================================*/

/* For tablets and smaller screens */
@media (max-width: 1024px) {
  .nav-inner {
    padding: 0 12px;
    height: 65px;
  }
  .brand { font-size: 1.2rem; }
  .brand-logo { width: 40px; height: 40px; }
  .nav-links { gap: 10px; }
  .nav-link { font-size: 1rem; padding: 8px 12px; }
  .btn { padding: 8px 14px; font-size: 0.9rem; }
  .welcome-header h1 { font-size: 2.4rem; }
  .welcome-header p { font-size: 1rem; }
  .swiper { height: 260px; border-radius: 18px; }
}

/* For mobile screens */
@media (max-width: 768px) {
  .nav-inner {
    flex-direction: column;
    align-items: flex-start;
    height: auto;
    padding: 12px 16px;
    gap: 12px;
  }
  .nav-links {
    flex-direction: column;
    width: 100%;
    gap: 8px;
  }
  .nav-link {
    display: block;
    width: 100%;
    text-align: left;
    padding: 10px;
    border-radius: 8px;
    font-size: 1rem;
  }
  .nav-cta {
    width: 100%;
    justify-content: flex-start;
    flex-wrap: wrap;
    gap: 10px;
  }
  .btn {
    flex: 1;
    text-align: center;
  }
  .welcome-header {
    padding: 40px 16px 60px;
  }
  .welcome-header h1 { font-size: 1.8rem; }
  .welcome-header p { font-size: 0.95rem; }
  .swiper { height: 200px; border-radius: 14px; }
}

/* For very small devices (phones <480px) */
@media (max-width: 480px) {
  .brand { font-size: 1rem; gap: 8px; }
  .brand-logo { width: 34px; height: 34px; }
  .nav-link { font-size: 0.9rem; padding: 8px 10px; }
  .btn { font-size: 0.85rem; padding: 7px 10px; }
  .welcome-header h1 { font-size: 1.5rem; }
  .welcome-header p { font-size: 0.85rem; }
  .swiper { height: 160px; }
}
/* HAMBURGER BUTTON */
.nav-toggle {
  display: none;
  font-size: 1.8rem;
  cursor: pointer;
  color: #fff;
  text-shadow: 0 0 8px rgba(255,255,255,.6);
  transition: transform 0.3s ease;
}

.nav-toggle:hover {
  transform: scale(1.1);
}

/* Mobile Menu Hidden by Default */
@media (max-width: 768px) {
  .nav-toggle {
    display: block;
  }
  .nav-links {
    display: none;
    flex-direction: column;
    width: 100%;
    background: linear-gradient(135deg, rgba(106,17,203,.95), rgba(182,112,245,.25));
    border-radius: 12px;
    padding: 10px 0;
  }
  .nav-links.show {
    display: flex;
  }
  .nav-link {
    padding: 12px;
    width: 100%;
    text-align: left;
  }
  .nav-cta {
    flex-direction: column;
    gap: 8px;
    width: 100%;
    padding: 10px;
  }
}


  </style>
</head>
<body>
  <!-- NAVBAR -->
  <nav class="nav">
    <div class="nav-inner">
      <a href="<%= ctx %>/dashboard.jsp" class="brand">
        <img src="<%= ctx %>/image/logo.png" alt="Logo" class="brand-logo" />
        Seller Hub
      </a>
      <!-- HAMBURGER MENU BUTTON -->
<div class="nav-toggle" onclick="toggleMenu()">☰</div>
      
       <div class="nav-links">
        <a href="dashboard.jsp" class="nav-link">Home</a>
<a href="http://localhost:8080/ProductManagement/ProductServlet" class="nav-link">
    Product Management
</a>



<a href="http://localhost:8080/OrderManagement/ListOrdersServlet?seller_port_id=<%= sellerPortId %>" class="nav-link">
    Order Management
</a>

<a href="http://localhost:8080/Report_product/ReportedProductsServlet?port_id=<%= sellerPortId %>" class="nav-link">
    Reported Products
</a>

      
      </div>
      <div class="nav-cta">
        <a href="http://localhost:8080/ProfileManagement/ProfileController?port_id=<%= sellerPortId %>" class="btn btn-profile">Profile</a>
       <% if(sellerPortId != null) { %>
    <!-- Active Logout button -->
    <a href="Logoutservlet" class="btn btn-danger">Logout</a>
<% } else { %>
    <!-- Disabled if port_id not set -->
    <button class="btn btn-danger" disabled>Logout</button>
<% } %>

      </div>
    </div>
  </nav>

  <!-- HEADER -->
  <header class="welcome-header">
  <h1>Welcome, <%= concernName %> 🚀</h1> 
    <p>Your journey to <span>bigger sales</span> starts today!</p>
  </header>


 <!-- ====== STATS ====== -->
<section class="stats">
  <div class="stat-card">
    <span class="icon">📦</span>
    <h2 class="counter" data-target="<%= totalOrders %>"><%= totalOrders %></h2>
    <p>Total Orders</p>
  </div>

  <div class="stat-card">
    <span class="icon">💰</span>
    <h2>$<span class="counter" data-target="<%= revenue %>"><%= String.format("%.2f", revenue) %></span></h2>
    <p>Total Revenue</p>
  </div>

  <div class="stat-card">
    <span class="icon">📈</span>
    <h2><%= growthMsg %></h2>
    <p>Growth Status</p>
  </div>
</section>
 <!-- TOP SELLING PRODUCTS -->
  
  </main>


   <!-- SELLER'S PROGRESS SECTION -->
<section class="progress-wrap">
  
  <!-- 🔥 Cinematic Heading -->
  <h2 class="cinematic-heading">⚡ Seller's Progress ⚡</h2>

  <!-- PROGRESS CARD -->
  <div class="progress-card" id="progressCard">

    <!-- Progress Circle -->
    <div class="progress-widget">
      <canvas id="progressCircle" width="220" height="220"></canvas>
      <div id="progressText" class="progress-text">0%</div>
    </div>

    <!-- Growth Message -->
    <div id="growthMsg" class="growth-msg"></div>

    <!-- Dynamic Labels -->
    <div class="progress-labels">
      <!-- Target Column -->
      <div class="progress-col">
        <span class="label">🎯 Target:</span>
        <div class="value-wrap">
          <span class="value" id="targetValue"></span>
          <button id="editTargetBtn">✏️</button>
        </div>
      </div>

      <!-- Progress Column -->
      <div class="progress-col">
        <span class="label">📊 Progress:</span>
        <div class="value-wrap">
          <span class="value" id="progressValue"></span>
        </div>
      </div>
    </div>
  </div>
</section> <!-- ✅ section ends here -->


<!-- ✅ SIDEBAR placed outside section -->
<button id="sidebarToggle" title="Open quick tools">☰</button>
<div id="sidebar" class="sidebar" aria-hidden="true">
 <div class="container">
    <h2>📌 Quick Tools</h2>
    <div class="sidebar-tabs">
      <button id="notesTab" class="active">Notes</button>
      <button id="todoTab">To-Do</button>
    </div>

    <div class="sidebar-content">
      <!-- Notes -->
      <div id="notesContent" class="tab-content active">
        <input type="text" id="noteInput" placeholder="Add a new note...">
        <button class="addBtn" onclick="addNote()">Add Note</button>
        <ul id="notesList"></ul>
      </div>

      <!-- To-Do -->
      <div id="todoContent" class="tab-content">
        <input type="text" id="todoInput" placeholder="Add a new task...">
        <button class="addBtn" onclick="addTask()">Add Task</button>
        <ul id="todoList"></ul>
      </div>
    </div>
  </div>

  <div id="toast" class="toast"></div>
  </div>
</div>

<div id="motivationPopup">
  <span class="close-btn">&times;</span>
  <span id="motivationText"></span>

  <!-- JS libs -->
<script src="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

<script>
//===== Swiper (Cinematic Carousel) =====
const heroSwiper = new Swiper('.swiper', {
  loop: true,
  speed: 1000,
  autoplay: { delay: 4000, disableOnInteraction: false },
  parallax: true,
  effect: 'slide',
  pagination: { el: '.swiper-pagination', clickable: true, dynamicBullets: true },
  navigation: { nextEl: '.swiper-button-next', prevEl: '.swiper-button-prev' },
  on: {
    slideChangeTransitionStart: function () {
      document.querySelectorAll('.slide-caption').forEach(el => el.classList.remove('animated'));
    },
    slideChangeTransitionEnd: function () {
      const activeCaption = document.querySelector('.swiper-slide-active .slide-caption');
      if (activeCaption) activeCaption.classList.add('animated');
    }
  }
});

// ===== Progress Circle (dynamic + cinematic) =====
const circleEl = document.getElementById('progressCircle');
const ctx2d = circleEl.getContext('2d');
const progressText = document.getElementById('progressText');
const growthText = document.getElementById('growthMsg');
const headingEl = document.getElementById('progressHeading');
const revenueVal = <%= revenue %>;   // from backend

function formatMoney(value) {
  return "$" + Number(value).toLocaleString(undefined, {
    minimumFractionDigits: 2, maximumFractionDigits: 2
  });
}
function getGrowthMsg(val, percent) {
  if (percent <= 0) return "🚫 No growth yet, keep pushing!";
  if (percent < 30) return "🌱 Low Growth";
  if (percent < 70) return "📈 Moderate Growth";
  if (percent < 100) return "🚀 High Growth";
  return "🌟 Outstanding!";
}
function getGlowColor(percent) {
  if (percent <= 30) return "#ff4d4d";
  if (percent <= 70) return "#ffcc00";
  return "#00e676";
}
function drawCircle(progress) {
  const w = circleEl.width, h = circleEl.height;
  const cx = w / 2, cy = h / 2, r = 85;
  ctx2d.clearRect(0, 0, w, h);
  ctx2d.lineWidth = 16; ctx2d.lineCap = 'round';
  ctx2d.beginPath(); ctx2d.strokeStyle = "#2a2a3d"; ctx2d.arc(cx, cy, r, 0, Math.PI * 2); ctx2d.stroke();
  const glowColor = getGlowColor(progress);
  ctx2d.shadowColor = glowColor; ctx2d.shadowBlur = 18;
  const start = -Math.PI / 2, end = start + (Math.PI * 2) * (progress / 100);
  ctx2d.beginPath(); ctx2d.strokeStyle = glowColor; ctx2d.arc(cx, cy, r, start, end); ctx2d.stroke();
  ctx2d.shadowBlur = 0;
  progressText.textContent = Math.round(progress) + '%';
  progressText.style.color = glowColor;
  progressText.style.textShadow = `0 0 15px ${glowColor}`;
}
function easeOutCubic(t) { return 1 - Math.pow(1 - t, 3); }
function animateCircleTo(targetPercent, duration = 1400, onComplete) {
  const startTime = performance.now();
  function step(now) {
    const elapsed = now - startTime;
    const t = Math.min(elapsed / duration, 1);
    const eased = easeOutCubic(t);
    const current = targetPercent * eased;
    drawCircle(current);
    if (t < 1) requestAnimationFrame(step);
    else if (onComplete) onComplete();
  }
  requestAnimationFrame(step);
}

// ===== Editable Target Revenue =====
const targetSpan = document.getElementById("targetValue");
const editBtn = document.getElementById("editTargetBtn");
const progressValEl = document.getElementById("progressValue");

function recalcAndAnimate() {
  const target = Number(localStorage.getItem("targetRevenue")) || 5000;
  const percent = Math.min(100, Math.round((revenueVal / target) * 100));
  targetSpan.textContent = formatMoney(target);
  progressValEl.textContent = formatMoney(revenueVal);
  animateCircleTo(percent, 1400, () => {
    growthText.textContent = getGrowthMsg(revenueVal, percent);
    growthText.classList.add("show");
    if (headingEl) headingEl.classList.add("animate");
  });
}
if (targetSpan && editBtn) {
  editBtn.addEventListener("click", () => {
    const currentVal = targetSpan.textContent.replace(/[^0-9]/g, "");
    const input = document.createElement("input");
    input.type = "number"; input.value = currentVal || 5000; input.style.width = "90px";
    targetSpan.replaceWith(input); input.focus();
    function saveTarget() {
      const newVal = parseInt(input.value) || 5000;
      targetSpan.textContent = formatMoney(newVal);
      input.replaceWith(targetSpan);
      localStorage.setItem("targetRevenue", newVal);
      recalcAndAnimate();
    }
    input.addEventListener("blur", saveTarget);
    input.addEventListener("keypress", e => { if (e.key === "Enter") saveTarget(); });
  });
  const savedTarget = localStorage.getItem("targetRevenue");
  if (savedTarget) targetSpan.textContent = formatMoney(savedTarget);
}
const progressCardEl = document.getElementById('progressCard');
if ('IntersectionObserver' in window) {
  const io = new IntersectionObserver((entries) => {
    entries.forEach(entry => { if (entry.isIntersecting) { recalcAndAnimate(); io.unobserve(entry.target); } });
  }, { threshold: 0.5 });
  io.observe(progressCardEl);
} else { recalcAndAnimate(); }

// ===== Animate Product Cards =====
const productCards = document.querySelectorAll('.product-card');
const revealObserver = new IntersectionObserver(entries => {
  entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
}, { threshold: 0.22 });
productCards.forEach(card => revealObserver.observe(card));

// ===== Sidebar Toggle =====
const sidebar = document.getElementById('sidebar');
const sidebarToggle = document.getElementById('sidebarToggle');
if (sidebar && sidebarToggle){
  sidebarToggle.addEventListener('click', () => {
    sidebar.classList.toggle('active');
    const open = sidebar.classList.contains('active');
    sidebar.setAttribute('aria-hidden', open ? 'false' : 'true');
  });
}
//===== Tabs =====
const notesTab = document.getElementById('notesTab');
const todoTab = document.getElementById('todoTab');
const notesContent = document.getElementById('notesContent');
const todoContent = document.getElementById('todoContent');
if (notesTab && todoTab){
  notesTab.addEventListener('click', () => {
    notesTab.classList.add('active'); todoTab.classList.remove('active');
    notesContent.classList.add('active'); todoContent.classList.remove('active');
  });
  todoTab.addEventListener('click', () => {
    todoTab.classList.add('active'); notesTab.classList.remove('active');
    todoContent.classList.add('active'); notesContent.classList.remove('active');
  });
}

// ===== Notes + Tasks LocalStorage =====
const noteInput = document.getElementById('noteInput'),
      notesList = document.getElementById('notesList');
const todoInput = document.getElementById('todoInput'),
      todoList = document.getElementById('todoList');
const toast = document.getElementById('toast');

function showToast(msg){
  toast.textContent = msg;
  toast.classList.add("show");
  setTimeout(()=>toast.classList.remove("show"), 2000);
}

function loadData(key, list, type){
  const data = JSON.parse(localStorage.getItem(key) || '[]');
  list.innerHTML = '';
  data.forEach((t, i) => {
    const li = document.createElement('li');
    const span = document.createElement('span');
    span.textContent = t;
    li.appendChild(span);

    const actions = document.createElement('div');
    actions.className="actions";

    if (type === 'notes'){
      const editBtn = document.createElement('button');
      editBtn.textContent = '✏️';
      editBtn.className = "editBtn";
      editBtn.onclick = () => {
        const newText = prompt("Edit your note:", t);
        if(newText){
          data[i] = newText;
          localStorage.setItem(key, JSON.stringify(data));
          loadData(key, list, type);
          showToast("Note updated ✏️");
        }
      };
      actions.appendChild(editBtn);
    }

    const btn = document.createElement('button');
    btn.textContent = '❌';
    btn.className = "deleteBtn";
    btn.onclick = () => { removeData(key, i); loadData(key, list, type); };
    actions.appendChild(btn);

    li.appendChild(actions);
    list.appendChild(li);
  });
}

function saveData(key, val){
  const data = JSON.parse(localStorage.getItem(key) || '[]');
  data.push(val);
  localStorage.setItem(key, JSON.stringify(data));
}

function removeData(key, i){
  const data = JSON.parse(localStorage.getItem(key) || '[]');
  data.splice(i,1);
  localStorage.setItem(key, JSON.stringify(data));
  showToast("Deleted ❌");
}

window.addNote = function(){
  if (noteInput.value.trim()){
    saveData('notes', noteInput.value.trim());
    noteInput.value=''; 
    loadData('notes', notesList, 'notes');
    showToast("Note saved ✅");
  }
}

window.addTask = function(){
  if (todoInput.value.trim()){
    saveData('tasks', todoInput.value.trim());
    todoInput.value=''; 
    loadData('tasks', todoList, 'tasks');
    showToast("Task added ✅");
  }
}

loadData('notes', notesList, 'notes');
loadData('tasks', todoList, 'tasks');
//===== Motivation Popup =====
(function(){
  function ready(fn){ 
    if(document.readyState !== "loading") fn(); 
    else document.addEventListener("DOMContentLoaded", fn, { once:true }); 
  }

  ready(function(){
    var popup      = document.getElementById("motivationPopup");
    var popupText  = document.getElementById("motivationText");
    var closeBtn   = popup ? popup.querySelector(".close-btn") : null;
    if(!popup || !popupText){ 
      console.error("Motivation popup: missing HTML nodes."); 
      return; 
    }

    var messages = [
      "✨ Keep pushing! You're closer than you think!",
      "🚀 Small progress is still progress!",
      "💡 Stay curious, keep learning!",
      "🌱 Growth comes one step at a time.",
      "🔥 Believe in yourself — you got this!",
      "🌟 Every day is a fresh start.",
      "💪 Consistency beats intensity.",
      "⚡ You are stronger than you think.",
      "🎯 Focus on progress, not perfection.",
      "😃 Smile, you’re doing great!"
    ];

    function randomMsg(){ 
      return messages[Math.floor(Math.random()*messages.length)]; 
    }

    function showPopup(){
      popupText.textContent = randomMsg();
      popup.classList.add("show");

      clearTimeout(popup._hideTimer);
      popup._hideTimer = setTimeout(function(){ 
        popup.classList.remove("show"); 
      }, 5000); // stays for 5 sec
    }

    if(closeBtn){ 
      closeBtn.addEventListener("click", function(){ 
        popup.classList.remove("show"); 
      }); 
    }

    // Show first popup after 5s
    setTimeout(function(){
      showPopup();
      // Then every 20s
      setInterval(showPopup, 20000);
    }, 5000);
  });
})();

function toggleMenu() {
  const navLinks = document.querySelector('.nav-links');
  const toggleBtn = document.querySelector('.nav-toggle');
  navLinks.classList.toggle('show');
  toggleBtn.textContent = navLinks.classList.contains('show') ? '✖' : '☰';
}
</script>

</body>
</html>