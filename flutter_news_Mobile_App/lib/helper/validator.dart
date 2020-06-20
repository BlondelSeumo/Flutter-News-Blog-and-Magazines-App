class FormValidator {
  static FormValidator _instance;

  factory FormValidator() => _instance ??= new FormValidator._();

  FormValidator._();

  String validatePassword(String value) {
//    String pattern = r'(^((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\W]).{6,20})$)';
//    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return "Password is Required";
    } else if (value.length < 6) {
      return "Password must minimum six characters";
//    } else if (!regExp.hasMatch(value)) {
//      return "one upper, lowercase, number & Special character";
    }
    return null;
  }

  String validateEmail(String value) {
    String pattern =
        r'(\D)+(\w)*((\.(\w)+)?)+@(\D)+(\w)*((\.(\D)+(\w)*)+)?(\.)[a-z]{2,}$';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String validateTextInput(String value) {
    String pattern = r'(^[A-Za-z\s]+$)';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return "This is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Only letters allowed";
    }
    return null;
  }

  String validatePhone(String value) {
    String pattern = r'(^[0-9\+\- \s]+$)';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return "This is Required";
    } else if (value.length < 10) {
      return "Phone number minimum ten digit.";
   } else if (!regExp.hasMatch(value)) {
      return "Only number, + and - allowed";
    }
    return null;
  }


  String validateDOB(String value) {
    String pattern = r'(^(([1-2][0-9])|([1-9])|(3[0-1]))/((1[0-2])|([1-9]))/[0-9]{4}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return "This is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalide Date - Must be DD/MM/YYYY";
    }
    return null;
  }

  String validateRequired(String value) {
    if (value.isEmpty) {
      return "This is Required";
    }
    return null;
  }
}
