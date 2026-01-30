<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <title>User Registration</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap" rel="stylesheet">

    <style>
        body {
            margin: 0;
            min-height: 100vh;
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(120deg, #1b1b2f, #162447, #1f4068);
            color: white;
            overflow: hidden;
        }
        .main-container {
            display: flex;
            height: 100vh;
        }
        /* Left card section */
        .left-section {
            flex: 0.8;
            display: flex;
            justify-content: center;
            align-items: center;
            background: #fff;
            animation: slideInLeft 1s ease forwards;
        }
        .register-card {
            background: linear-gradient(135deg, #1b1b2f, #162447, #1f4068);
            border-radius: 18px;
            padding: 20px 25px;
            width: 90%;
            max-width: 380px;
            color: #fff;
            box-shadow: 0 10px 25px rgba(0,0,0,0.4);
        }
        .register-card h2 {
            text-align: center;
            margin-bottom: 12px;
            font-weight: 700;
            color: #ff4b91;
        }
        .form-label {
            font-weight: 600;
            color: #fff;
            margin-bottom: 3px;
        }
        .form-control {
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255,255,255,0.25);
            border-radius: 10px;
            color: #fff;
            height: 38px;
            font-size: 0.9rem;
        }
        .form-control:focus {
            border-color: #ff4b91;
            box-shadow: 0 0 8px rgba(255, 75, 145, 0.6);
        }
        .btn-custom {
            background-color: #ff4b91;
            border: none;
            border-radius: 10px;
            padding: 8px;
            font-weight: 700;
            color: #fff;
            font-size: 0.95rem;
            transition: 0.25s ease;
        }
        .btn-custom:hover {
            background-color: #ff2e75;
            transform: translateY(-1px);
        }
        .btn-outline-light {
            border-radius: 10px;
            padding: 8px;
            font-weight: 700;
            font-size: 0.9rem;
        }

        /* Right text section */
        .right-section {
            flex: 1.2;
            display: flex;
            flex-direction: column;
            justify-content: center; 
            align-items: center;     
            padding: 40px;
            color: white;
            text-align: center;
            animation: slideInRight 1s ease forwards;
        }
        .right-section h1 {
            font-size: 2.4rem;
            font-weight: 700;
            color: #ff4b91;
            margin-bottom: 12px;
        }
        .right-section p {
            font-size: 1.1rem;
            color: #f0f0f0;
            line-height: 1.5;
        }

        /* Animations */
        @keyframes slideInLeft {
            from { transform: translateX(-100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        @keyframes slideInRight {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
    </style>
</head>
<body>

<div class="main-container">
    <!-- Left side Register Card -->
    <div class="left-section">
        <div class="register-card">
            <h2>Register</h2>
            <form id="registerForm" action="Registerserv" method="post" onsubmit="return finalValidate()">

                <!-- Port ID -->
                <div class="mb-2">
                    <label for="port_id" class="form-label">Port ID</label>
                    <input type="text" class="form-control" id="port_id" name="port_id" required>

                    <small class="text-danger">
                        <%= (request.getAttribute("portIdError") != null) ? request.getAttribute("portIdError") : "" %>
                    </small>
                </div>

                <!-- Full Name -->
                <div class="mb-2">
                    <label for="name" class="form-label">Full Name</label>
                    <input type="text" class="form-control" id="name" name="name" required>
                </div>

                <!-- Email -->
                <div class="mb-2">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" name="email" required oninput="validateEmail(this)">
                    <div id="emailHelp" class="form-text text-danger d-none">Invalid Email Format!</div>
                    <small class="text-danger">
                        <%= (request.getAttribute("emailError") != null) ? request.getAttribute("emailError") : "" %>
                    </small>
                </div>

               <!-- Password -->
<div class="mb-2 position-relative">
    <label for="password" class="form-label">Password</label>
    <input type="password" class="form-control" id="password" name="password" required oninput="validatePassword(this)">
    
    <!-- Eye icon inside input -->
    <span id="togglePassword" style="position:absolute; right:10px; top:38px; cursor:pointer; color:#ff4b91;">
        <i class="fa-solid fa-eye"></i>
    </span>
    
    <div id="passwordHelp" class="form-text text-danger d-none">
        Password must be 8 chars, include uppercase, lowercase, number & special char!
    </div>
    <small class="text-danger">
        <%= (request.getAttribute("passwordError") != null) ? request.getAttribute("passwordError") : "" %>
    </small>
</div>


                <!-- Location -->
                <div class="mb-2">
                    <label for="location" class="form-label">Location</label>
                    <input type="text" class="form-control" id="location" name="location" required>
                </div>

                <button type="submit" class="btn btn-custom w-100 mb-2" id="registerBtn" disabled>Register</button>
            </form>

            <!-- Already Registered Button -->
            <a href="login.jsp" class="btn btn-outline-light w-100">Already Registered? Login</a>
        </div>
    </div>

    <!-- Right side text -->
    <div class="right-section">
        <h1>Join Us Today</h1>
        <p>
            Create your account to explore our Import Export ERP System.<br>
            Get access to powerful tools, manage your ports, and grow your business with ease.
        </p>

        <!-- Added Image -->
        <img src="https://static.vecteezy.com/system/resources/previews/002/788/767/non_2x/woman-sitting-table-with-laptop-working-on-a-computer-freelance-online-education-or-social-media-concept-freelance-or-studying-concept-flat-style-illustration-isolated-on-white-vector.jpg" alt="ERP Illustration" 
             class="img-fluid mt-3 rounded shadow" style="max-width: 350px;">
    </div>
</div>

<script>
function validateEmail(input) {
    const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$/;
    const helpText = document.getElementById("emailHelp");
    if (!emailPattern.test(input.value)) {
        helpText.classList.remove("d-none");
        return false;
    } else {
        helpText.classList.add("d-none");
        return true;
    }
}

function validatePassword(input) {
    // Password must be exactly 8 chars, with at least 1 uppercase, 1 lowercase, 1 number, 1 special char
    const passPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=!]).{8}$/;
    const helpText = document.getElementById("passwordHelp");

    if (!passPattern.test(input.value)) {
        helpText.classList.remove("d-none");
        helpText.textContent = "Password must be 8 chars, include uppercase, lowercase, number & special char!";
        return false;
    } else {
        helpText.classList.add("d-none");
        return true;
    }
}


function finalValidate() {
    let emailValid = validateEmail(document.getElementById("email"));
    let passValid = validatePassword(document.getElementById("password"));
    return emailValid && passValid;
}

// Enable Register button only if fields are valid
const formInputs = document.querySelectorAll("#registerForm input");
const registerBtn = document.getElementById("registerBtn");

formInputs.forEach(input => {
    input.addEventListener("input", () => {
        if (finalValidate() &&
            document.getElementById("port_id").value.trim() !== "" &&
            document.getElementById("name").value.trim() !== "" &&
            document.getElementById("location").value.trim() !== "") {
            registerBtn.disabled = false;
        } else {
            registerBtn.disabled = true;
        }
    });
});
const togglePassword = document.getElementById("togglePassword");
const passwordInput = document.getElementById("password");

togglePassword.addEventListener("click", () => {
    const icon = togglePassword.querySelector("i");
    if (passwordInput.type === "password") {
        passwordInput.type = "text";
        icon.classList.remove("fa-eye");
        icon.classList.add("fa-eye-slash");
    } else {
        passwordInput.type = "password";
        icon.classList.remove("fa-eye-slash");
        icon.classList.add("fa-eye");
    }
});

</script>
</body>
</html>