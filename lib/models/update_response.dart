class UpdateResponse {
  String? message;

  UpdateResponse({this.message});

  UpdateResponse.fromJson(Map<String, dynamic> json) {
    var msg = json['message'];

    if (msg is String) {
      message = msg;
    } else if (msg is List) {
      message = msg.join(", ");
    } else {
      message = "Unknown error";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    return data;
  }
}
