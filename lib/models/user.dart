import 'dart:convert';

User userfromJson(String str) => User.fromJson(json.decode(str));

String usertoJson(User data) => json.encode(data.toJson());

class User {
    final int userId;
    final String userName;
    final String? userEmail;
    final String token;

    User({
        required this.userId,
        required this.userName,
        required this.userEmail,
        required this.token,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        userName: json["user_name"],
        userEmail: json["user_email"] is bool ? null : json["user_email"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "user_email": userEmail,
        "token": token,
    };
}
