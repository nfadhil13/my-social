class RegisterFormEntity {
  String fullName;
  String email;
  String password;
  String username;
  String confirmPassword;

  RegisterFormEntity({
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.username = '',
  });
}
