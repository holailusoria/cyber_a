extension UserCredentialValidator on String{
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool isValidUsername() {
    return RegExp(r'^[A-Za-z0-9]+$').hasMatch(this) && length >=6 && length <=16;
  }

  bool isValidPassword() {
    return length >=6 && length <=16;
  }
}