class FormValidation {
  static String validateEmail(String value) {
    if (value.isEmpty) {
      return "Please enter email";
    }
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter Valid Email';
    }
    return null;
  }

  static String validateFirstName(String value) {
    if (value.isEmpty) {
      return "Please enter first name";
    }
    return null;
  }

  static String validateLastName(String value) {
    if (value.isEmpty) {
      return "Please enter last name";
    }
    return null;
  }

  static String validatePassword(String value) {
    if (value.isEmpty) {
      return "Please enter password";
    }
    return null;
  }

  static String validateConfirmPassword(
      String confirmPassword, String password) {
    if (confirmPassword.isEmpty) {
      return "Please enter confirm password";
    }
    if (confirmPassword != password) {
      return "Password does not match";
    }
    return null;
  }

  static String validateDob(String value) {
    if (value.isEmpty) {
      return "Please enter your date of birth";
    }
    Pattern pattern = r'^([0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4})$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return "Please enter valid date";
    }
    return null;
  }

  static validatePhone(String value) {
    if (value.isEmpty) {
      return "Please enter mobile number";
    }
    /* Pattern pattern = r'^([0-9]{10})$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return "Please enter valid phone number";
    } */
    return null;
  }

  static validateField(String value, String message) {
    if (value.isEmpty) {
      return message;
    }
    return null;
  }
}
