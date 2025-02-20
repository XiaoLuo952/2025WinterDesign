class ApiResponse<T> {
  final int code;
  final String msg;
  final T? data;

  ApiResponse({
    required this.code,
    required this.msg,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T? Function(dynamic) fromJson) {
    return ApiResponse(
      code: json['code'] as int,
      msg: json['msg'] as String,
      data: json['data'] != null ? fromJson(json['data']) : null,
    );
  }
} 