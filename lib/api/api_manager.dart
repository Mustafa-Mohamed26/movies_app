import 'dart:convert';

import 'package:movies_app/api/api_constants.dart';
import 'package:movies_app/api/end_points.dart';
import 'package:movies_app/models/user_request.dart';
import 'package:movies_app/models/user_response.dart';
import 'package:http/http.dart' as http;

class ApiManager {
  // Register Function
  static Future<UserResponse?> register(UserRequest userRequest) async {
    Uri url = Uri.https(ApiConstants.baseUrl, EndPoints.registerApi);
    try {
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json", // to be able to send json
        },
        body: jsonEncode(userRequest.toJson()), // to be able to send the user
      );
      var responseBody = response.body;
      var json = jsonDecode(responseBody);
      return UserResponse.fromJson(json);
    } catch (e) {
      throw Exception(e);
    }
  }
}
