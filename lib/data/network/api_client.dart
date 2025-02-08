// ignore_for_file: require_trailing_commas

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
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
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Uri uri = Uri.parse('${ApiConstant.baseUrl}$endpoint');
      if (queryParameters != null) {
        uri = uri.replace(queryParameters: queryParameters);
      }
      LogService.i('GET request to $uri');
      final headers = await _getHeaders(
        false,
      );
      final response = await client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 15));

      LogService.i('Response GET: ${response.body}');

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      return const ApiNoInternet(message: ApiConstant.noInternetConnection);
    } catch (e) {
      return ApiError(message: 'GET request failed: $e');
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint,
    dynamic body, {
    T Function(Map<String, dynamic>)? fromJson,
    bool isMultiPart = false,
    File? imageFile,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstant.baseUrl}$endpoint');
      final headers = await _getHeaders(isMultiPart);

      LogService.i('POST request to $uri');

      if (isMultiPart && imageFile != null) {
        var request = http.MultipartRequest('POST', uri);

        request.headers.addAll(headers);

        final bodyMap = body as Map<String, dynamic>;
        bodyMap.forEach((key, value) {
          if (key != ApiConstant.logoKey) {
            request.fields[key] = value.toString();
          }
        });

        var multipartFile = await http.MultipartFile.fromPath(
            ApiConstant.logoKey, imageFile.path);
        request.files.add(multipartFile);

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        LogService.i('Response POST: ${response.body}');
        LogService.i('status code: ${response.statusCode}');

        return _handleResponse<T>(response, fromJson);
      } else {
        final response = await client
            .post(
              uri,
              headers: headers,
              body: jsonEncode(body),
            )
            .timeout(const Duration(seconds: 15));

        LogService.i('status code: ${response.statusCode}');

        return _handleResponse<T>(response, fromJson);
      }
    } on SocketException {
      return const ApiNoInternet(message: ApiConstant.noInternetConnection);
    } catch (e) {
      return ApiError(message: 'POST request failed: $e');
    }
  }

  Future<ApiResponse<T>> patch<T>(
    String endpoint,
    dynamic body, {
    T Function(Map<String, dynamic>)? fromJson,
    bool isMultiPart = false,
    File? imageFile,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstant.baseUrl}$endpoint');
      final headers = await _getHeaders(isMultiPart);

      LogService.i('PATCH request to $uri');

      if (isMultiPart && imageFile != null) {
        var request = http.MultipartRequest('PATCH', uri);

        request.headers.addAll(headers);

        final bodyMap = body as Map<String, dynamic>;
        bodyMap.forEach((key, value) {
          if (key != ApiConstant.logoKey) {
            request.fields[key] = value.toString();
          }
        });

        var multipartFile = await http.MultipartFile.fromPath(
          ApiConstant.logoKey,
          imageFile.path,
        );
        request.files.add(multipartFile);

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        LogService.i('Response PATCH: ${response.body}');
        LogService.i('status code: ${response.statusCode}');

        return _handleResponse<T>(response, fromJson);
      } else {
        final response = await client
            .post(
              uri,
              headers: headers,
              body: jsonEncode(body),
            )
            .timeout(const Duration(seconds: 15));

        LogService.i('status code: ${response.statusCode}');

        return _handleResponse<T>(response, fromJson);
      }
    } on SocketException {
      return const ApiNoInternet(message: ApiConstant.noInternetConnection);
    } catch (e) {
      return ApiError(message: 'PATCH request failed: $e');
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstant.baseUrl}$endpoint');
      final headers = await _getHeaders(false);

      LogService.i('DELETE request to $uri');

      final response = await client
          .delete(
            uri,
            headers: headers,
          )
          .timeout(const Duration(seconds: 15));

      LogService.i('Response DELETE: ${response.body}');
      LogService.i('status code: ${response.statusCode}');

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      return const ApiNoInternet(message: ApiConstant.noInternetConnection);
    } catch (e) {
      return ApiError(message: 'DELETE request failed: $e');
    }
  }

  Future<Map<String, String>> _getHeaders(
    bool isMultiPart,
  ) async {
    final token = tokenSp.getToken();
    return {
      'Content-Type': isMultiPart
          ? ApiConstant.multipartFormData
          : ApiConstant.applicationJson,
      'Accept': ApiConstant.applicationJson,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    final statusCode = response.statusCode;
    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    final message =
        responseBody['message'] as String? ?? ApiConstant.unknownError;
    final errors = responseBody['errors'];

    if (statusCode >= 300) {
      return ApiError<T>(
        message: message,
        errors: errors,
      );
    }

    final data = responseBody['data'];
    final paginationData = responseBody['pagination'] as Map<String, dynamic>?;
    // ! kalo pagination nya gaada
    if (paginationData == null) {
      return ApiSuccess<T>(
        message: message,
        data: fromJson?.call(data) ?? data as T,
      );
    }
    // ! kalo pagination nya ada
    final combinedData = {
      'data': data,
      'pagination': paginationData,
    };

    return ApiSuccess<T>(
      message: message,
      data: fromJson?.call(combinedData) ?? combinedData as T,
    );
  }
}
