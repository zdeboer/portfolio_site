window.onload = function () {
    var form = document.getElementById("contact-form");

    form.onsubmit = function (event) {
        var errorElements = document.querySelectorAll(".error-message");
        for (var i = 0; i < errorElements.length; i++) {
            errorElements[i].remove();
        }

        var name = document.getElementById("contact-name").value.trim();
        var email = document.getElementById("contact-email").value.trim();
        var phone = document.getElementById("contact-phone").value.trim();
        var message = document.getElementById("contact-message").value.trim();

        var valid = true;

        function showError(inputId, message) {
            var input = document.getElementById(inputId);
            var error = document.createElement("div");
            error.className = "error-message";
            error.style.color = "red";
            error.style.fontSize = "0.9em";
            error.textContent = message;
            input.parentNode.appendChild(error);
            valid = false;
        }

        if (name === "") {
            showError("contact-name", "Please enter your name.");
        }

        var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (email === "") {
            showError("contact-email", "Please enter your email.");
        } else if (!emailPattern.test(email)) {
            showError("contact-email", "Please enter a valid email address.");
        }

        var phonePattern = /^\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}$/;
        if (phone !== "" && !phonePattern.test(phone)) {
            showError("contact-phone", "Please enter a valid phone number (e.g. 204-555-1234).");
        }

        if (message === "") {
            showError("contact-message", "Please enter your message.");
        }

        if (!valid) {
            event.preventDefault();
        }
    };
};
