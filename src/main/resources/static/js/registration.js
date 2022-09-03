function validateForm() {
    var errorCounter = 0;
    errorCounter += validateLogin();
    errorCounter += validateName();
    errorCounter += validateSurname();
    errorCounter += validateEmail();
    errorCounter += validatePass();
    errorCounter += validateRepeatPass();
    errorCounter += validateBrthday();

    if (errorCounter > 0) {
        return false;
    }

    return true;
}

function validateLogin() {
    var errorCounter = 0;
    var loginFld = document.getElementById("login");
    var loginErr = document.getElementById("loginError");

    if (loginFld.value.length <= 0) {
        loginFld.style.borderBlockColor = '#FF0000';
        loginFld.style.borderInlineColor = '#FF0000';
        loginErr.style.display = "block";
        loginErr.style.color = "#FF0000";
        errorCounter++;
    } else {
        loginFld.style.borderBlockColor = '#00FF00';
        loginFld.style.borderInlineColor = '#00FF00';
        loginErr.style.display = "none";
    }
    return errorCounter;
}

function validateName() {
    var errorCounter = 0;
    var nameFld = document.getElementById("name");
    var nameErr = document.getElementById("nameError");

    if (nameFld.value.length <= 0) {
        nameFld.style.borderBlockColor = '#FF0000';
        nameFld.style.borderInlineColor = '#FF0000';
        nameErr.style.display = "block";
        nameErr.style.color = "#FF0000";
        errorCounter++;
    } else {
        nameFld.style.borderBlockColor = '#00FF00';
        nameFld.style.borderInlineColor = '#00FF00';

        nameErr.style.display = "none";
    }
    return errorCounter;
}

function validateSurname() {
    var errorCounter = 0;
    var surnameFld = document.getElementById("surname");
    var surnameErr = document.getElementById("surnameError");

    if (surnameFld.value.length <= 0) {
        surnameFld.style.borderBlockColor = '#FF0000';
        surnameFld.style.borderInlineColor = '#FF0000';
        surnameErr.style.display = "block";
        surnameErr.style.color = "#FF0000";
        errorCounter++;
    } else {
        surnameFld.style.borderBlockColor = '#00FF00';
        surnameFld.style.borderInlineColor = '#00FF00';
        surnameErr.style.display = "none";
    }

    return errorCounter;
}

function validateEmail() {
    var errorCounter = 0;
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    var emailFld = document.getElementById("email");
    var emailErr = document.getElementById("emailError");
    var validationErr = document.getElementById("validationErr");

    if (emailFld.value <= 0) {
        validationErr.style.display = "none";
        emailFld.style.borderBlockColor = '#FF0000';
        emailFld.style.borderInlineColor = '#FF0000';
        emailErr.style.display = "block";
        emailErr.style.color = "#FF0000";
        errorCounter++;
    } else {
        if (!re.test(String(emailFld.value).toLowerCase())) {
            emailErr.style.display = "none";
            emailFld.style.borderBlockColor = '#FF0000';
            emailFld.style.borderInlineColor = '#FF0000';
            validationErr.style.display = "block";
            validationErr.style.color = "#FF0000";
            errorCounter++;
        } else {
            emailFld.style.borderBlockColor = '#00FF00';
            emailFld.style.borderInlineColor = '#00FF00';
            emailErr.style.display = "none";
            validationErr.style.display = "none";
        }
    }

    return errorCounter;
}

function validatePass() {
    var errorCounter = 0;
    var passFld = document.getElementById("password");
    var passErr = document.getElementById("passwordError");

    if (passFld.value.length <= 0) {
        passFld.style.borderBlockColor = '#FF0000';
        passFld.style.borderInlineColor = '#FF0000';
        passErr.style.display = "block";
        passErr.style.color = "#FF0000";
        errorCounter++;
    } else {
        passFld.style.borderBlockColor = '#00FF00';
        passFld.style.borderInlineColor = '#00FF00';
        passErr.style.display = "none";
    }

    return errorCounter;
}

function validateRepeatPass() {
    var errorCounter = 0;
    var passFld = document.getElementById("password");
    var repeatPassFld = document.getElementById("repeatPswd");
    var repeatPassErr = document.getElementById("repeatPassError");
    var matchingErr = document.getElementById("matchingError");

    if (repeatPassFld.value.length <= 0) {
        matchingErr.style.display = "none";
        repeatPassFld.style.borderBlockColor = '#FF0000';
        repeatPassFld.style.borderInlineColor = '#FF0000';
        repeatPassErr.style.display = "block";
        repeatPassErr.style.color = "#FF0000";
        errorCounter++;
    } else {
        if (passFld.value.localeCompare(repeatPassFld.value) !== 0) {
            repeatPassErr.style.display = "none";
            repeatPassFld.style.borderBlockColor = '#FF0000';
            repeatPassFld.style.borderInlineColor = '#FF0000';
            matchingErr.style.display = "block";
            matchingErr.style.color = "#FF0000";
            errorCounter++;
        } else {
            repeatPassFld.style.borderBlockColor = '#00FF00';
            repeatPassFld.style.borderInlineColor = '#00FF00';
            matchingErr.style.display = "none";
        }
    }

    return errorCounter;
}

function validateBrthday() {
    var errorCounter = 0;
    var brthDay = document.getElementById("brthDays");
    var brthMonth = document.getElementById("brthMonths");
    var brthYearFld = document.getElementById("brthYears");
    var brthErr = document.getElementById("brthErr");

    if (!((new Date().getFullYear() - parseInt(brthYearFld.value)) >= 16)) {
        brthDay.style.borderBlockColor = '#FF0000';
        brthDay.style.borderInlineColor = '#FF0000';
        brthMonth.style.borderBlockColor = '#FF0000';
        brthMonth.style.borderInlineColor = '#FF0000';
        brthYearFld.style.borderBlockColor = '#FF0000';
        brthYearFld.style.borderInlineColor = '#FF0000';
        brthErr.style.display = "block";
        brthErr.style.color = "#FF0000";
        errorCounter++;
    } else {
        brthDay.style.borderBlockColor = '#00FF00';
        brthDay.style.borderInlineColor = '#00FF00';
        brthMonth.style.borderBlockColor = '#00FF00';
        brthMonth.style.borderInlineColor= '#00FF00';
        brthYearFld.style.borderBlockColor = '#00FF00';
        brthYearFld.style.borderInlineColor = '#00FF00';
        brthErr.style.display = "none";
    }

    return errorCounter;
}










