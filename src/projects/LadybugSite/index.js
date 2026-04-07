window.onload = function() {
  var form = document.getElementById("booking");

  form.onsubmit = function(event) {
    var name = document.getElementById("name").value.trim();
    var phone = document.getElementById("phone").value.trim();

    var errors = [];

    if (name === "") {
      errors.push("Please enter your name.");
    }

    var digitsOnly = phone.replace(/\D/g, "");

    if (digitsOnly.length !== 10) {
      errors.push("Invalid phone number");
    }

    if (errors.length > 0) {
      alert(errors.join("\n"));
      event.preventDefault();
    }
  };
};

