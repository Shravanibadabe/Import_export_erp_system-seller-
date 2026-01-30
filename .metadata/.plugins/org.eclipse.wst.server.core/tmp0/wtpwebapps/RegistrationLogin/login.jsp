<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Login</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
	rel="stylesheet">

<style>
body {
	margin: 0;
	font-family: 'Poppins', sans-serif;
	height: 100vh;
	display: flex;
	background: #f0f2f5;
}

.left-blog {
	flex: 1.2;
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	color: #fff;
	padding: 50px;
	background: linear-gradient(120deg, #1b1b2f, #162447, #1f4068);
	text-align: center;
}

.left-blog h1 {
	font-size: 3rem;
	font-weight: 700;
	color: #ff4b91;
}

.left-blog p {
	font-size: 1.2rem;
	max-width: 400px;
}

.right-form {
	flex: 0.8;
	display: flex;
	justify-content: center;
	align-items: center;
	padding: 50px;
	background: #fff;
}

.login-card {
	background: linear-gradient(120deg, #1b1b2f, #162447, #1f4068);
	border-radius: 20px;
	padding: 40px;
	width: 100%;
	max-width: 400px;
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.4);
	color: #fff;
}

.login-card h2 {
	text-align: center;
	margin-bottom: 25px;
	font-weight: 700;
	color: #ff4b91;
}

.form-label {
	font-weight: 600;
	color: #fff;
}

.form-control {
	background: rgba(255, 255, 255, 0.05);
	border: 1px solid rgba(255, 255, 255, 0.3);
	border-radius: 12px;
	color: #fff;
	padding: 10px;
	margin-bottom: 15px;
}

.form-control:focus {
	border-color: #ff4b91;
	box-shadow: 0 0 8px #ff4b91;
}

.btn-custom {
	background-color: #ff4b91;
	border: none;
	border-radius: 12px;
	padding: 12px;
	font-weight: bold;
	color: #fff;
	width: 100%;
}

.btn-custom:hover {
	background-color: #ff2e75;
}

.errorBox {
	background: #ffdddd;
	color: #d60000;
	border: 1px solid #ff0000;
	border-radius: 10px;
	padding: 10px;
	margin-bottom: 15px;
	text-align: center;
	font-weight: bold;
}

.back-btn {
	display: inline-block;
	padding: 8px 20px;
	background: rgba(255, 255, 255, 0.1);
	color: #ff4b91;
	border: 1px solid #ff4b91;
	border-radius: 12px;
	text-decoration: none;
	font-weight: 600;
	transition: all 0.3s ease;
	margin-top: 10px;
}

.back-btn:hover {
	background: #ff4b91;
	color: #fff;
	border-color: #ff4b91;
}
</style>
</head>
<body>

	<div class="left-blog">
		<h1>Welcome Back!</h1>
		<p>Login to your dashboard and manage orders, products, and
			reports seamlessly.</p>

		<!-- Added Image -->
		<img
			src="https://cdni.iconscout.com/illustration/premium/thumb/employee-enters-details-on-login-page-illustration-svg-png-download-8869756.png"
			alt="Login Illustration" class="img-fluid mt-4 rounded shadow"
			style="max-width: 350px;">
	</div>

	<div class="right-form">
		<div class="login-card">

			<%-- 🔴 Error message from servlet --%>
			<%
			String loginError = (String) request.getAttribute("loginError");
			if (loginError != null) {
			%>
			<div class="errorBox"><%=loginError%></div>
			<%
			}
			%>


			<h2>Login</h2>
			<form action="LoginServlet" method="post">
				<div>
					<label for="port_id" class="form-label">Port ID</label> <input
						type="text" class="form-control" id="port_id" name="port_id"
						required>
				</div>
				<div style="position: relative;">
					<label for="password" class="form-label">Password</label> <input
						type="password" class="form-control" id="password" name="password"
						required> <i class="bi bi-eye-fill" id="togglePassword"
						style="position: absolute; right: 12px; top: 38px; cursor: pointer; color: #ff4b91;"></i>
				</div>
				<button type="submit" class="btn btn-custom mt-3">Login</button>
			</form>
			<div style="text-align: center;">
				<a href="register.jsp" class="back-btn"><i
					class="fas fa-arrow-left"></i> Back</a>
			</div>
		</div>
	</div>
	<script>
		const togglePassword = document.querySelector('#togglePassword');
		const password = document.querySelector('#password');

		togglePassword.addEventListener('click', function() {
			const type = password.getAttribute('type') === 'password' ? 'text'
					: 'password';
			password.setAttribute('type', type);
			this.classList.toggle('bi-eye');
			this.classList.toggle('bi-eye-fill');
		});
	</script>
</body>
</html>