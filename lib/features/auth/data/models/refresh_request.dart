class RefreshRequest {
  final String refreshToken;
  final String clientId = "Client1";

  RefreshRequest({required this.refreshToken});

  Map<String, dynamic> toJson() {
    return {'RefreshToken': refreshToken, 'ClientId': clientId};
  }
}
