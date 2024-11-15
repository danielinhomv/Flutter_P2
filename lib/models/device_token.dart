import 'dart:convert';

DeviceToken deviceTokenFromMap(String str) => DeviceToken.fromJson(json.decode(str));

String deviceTokenToMap(DeviceToken data) => json.encode(data.toJson());

class DeviceToken {
    final int userId;
    final String token;

    DeviceToken({
        required this.userId,
        required this.token,
    });

    factory DeviceToken.fromJson(Map<String, dynamic> json) => DeviceToken(
        userId: json["user_id"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "token": token,
    };
}
