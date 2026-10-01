class LoginRequest {
  final String email;
  final String password;
  final String clientId = "Client1";
  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'Email': email, 'Password': password, 'ClientId': clientId};
  }
}
