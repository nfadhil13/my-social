class RegisterFormEntity {
  String fullName;
  String email;
  String password;
  String confirmPassword;

  RegisterFormEntity({
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
  });
}
