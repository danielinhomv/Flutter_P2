import 'dart:convert';

ResponseApi responseApiFromJson(String str) =>
    ResponseApi.fromJson(json.decode(str));

String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

class ResponseApi {
  String? message;
  String? error;
  bool? success;
  dynamic data;

  ResponseApi({
    this.message,
    this.error,
    this.success,
    this.data,
  });

  factory ResponseApi.fromJson(Map<String, dynamic> json) {
    // Extrayendo los datos del campo result
    Map<String, dynamic> result = json["result"] ?? {};
    
    return ResponseApi(
      message: result["message"],
      error: result["error"],
      success: result["success"],
      data: result["data"],
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "error": error,
        "success": success,
        "data": data,
      };
}
