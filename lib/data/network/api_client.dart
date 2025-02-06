import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/local/token_sp.dart';
import 'package:paint_car/dependencies/services/log_service.dart';

class ApiClient {
  final http.Client client;
  final TokenLocal tokenSp;

  const ApiClient({
    required this.client,
    required this.tokenSp,
  });

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstant.baseUrl}/$endpoint');
      final headers = await _getHeaders();
      final response = await client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 15));

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      return ApiNoInternet(message: ApiConstant.noInternetConnection);
    } catch (e) {
      return ApiError(message: 'GET request failed: $e');
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint,
    dynamic body, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstant.baseUrl}/$endpoint');
      final headers = await _getHeaders();
      final response = await client
          .post(
            uri,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      return ApiNoInternet(message: ApiConstant.noInternetConnection);
    } catch (e) {
      return ApiError(message: 'POST request failed: $e');
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = tokenSp.getToken();
    return {
      'Content-Type': ApiConstant.contentType,
      'Accept': ApiConstant.contentType,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    final statusCode = response.statusCode;
    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    final message = responseBody['message'] as String? ?? 'Unknown message';

    if (statusCode >= 300) {
      return ApiError<T>(message: message);
    }
    final data = responseBody['data'];
    if (!responseBody.containsKey('pagination')) {
      return ApiSuccess<T>(
        message: message,
        data: fromJson?.call(data) ?? data as T,
      );
    }
    final paginationData = responseBody['pagination'] as Map<String, dynamic>;
    final pagination = Pagination.fromMap(paginationData);

    return ApiSuccessPagination(
      message: message,
      data: fromJson?.call({'data': data}) ?? data as T,
      pagination: pagination,
    );
  }
}
