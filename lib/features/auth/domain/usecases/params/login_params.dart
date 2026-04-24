class LoginParams {
  final String email;
  final String password;
  final bool rememberMe;
  
  LoginParams({
    required this.email, 
    required this.password, 
    this.rememberMe = true,
  });
}
