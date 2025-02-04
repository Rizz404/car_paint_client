import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/network/api_exception.dart';
import 'package:paint_car/data/local/token_sp.dart';

class ApiClient {
  final http.Client client;
  final TokenLocal tokenSp;

  ApiClient({
    required this.client,
    required this.tokenSp,
  });

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final uri = Uri.parse('${ApiConstant.baseUrl}/$endpoint');
      final headers = await _getHeaders();

      final response = await client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: 'GET request failed: $e');
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, dynamic body) async {
    try {
      final uri = Uri.parse('${ApiConstant.baseUrl}/$endpoint');
      final headers = await _getHeaders();

      final response = await client
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } catch (e) {
      throw ApiException(message: 'POST request failed: $e');
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = tokenSp.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = jsonDecode(response.body);

    if (statusCode >= 200 && statusCode < 300) {
      return responseBody;
    } else {
      throw ApiException(
        message: responseBody['message'] ?? 'Unknown error occurred',
        statusCode: statusCode,
      );
    }
  }
}
