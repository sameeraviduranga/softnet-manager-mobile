class LoginResponse {
  final bool isSuccess;
  final Data? data;
  final String? message;
  final Object? error;
  LoginResponse({required this.isSuccess, this.data, this.message, this.error});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      isSuccess: json["IsSuccess"] as bool,
      data: Data.fromJson(json["Data"] as Map<String, dynamic>),
      message: json["Message"] as String,
      error: json["Error"],
    );
  }
}

class Data {
  final String token;
  final String refreshToken;
  Data({required this.token, required this.refreshToken});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      token: json["Token"] as String,
      refreshToken: json["RefreshToken"] as String,
    );
  }
}
