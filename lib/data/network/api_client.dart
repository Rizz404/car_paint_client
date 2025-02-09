// ignore_for_file: require_trailing_commas

import 'dart:async';
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
  static const Duration timeout = Duration(seconds: 30);

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
      // TODO: DELETE LATERR

      LogService.i('GET request to $uri');
      final headers = await _getHeaders(
        false,
      );
      final response = await client.get(uri, headers: headers).timeout(timeout);

      // TODO: DELETE LATERR

      LogService.i('Response GET: ${response.body}');

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      return const ApiNoInternet(message: ApiConstant.noInternetConnection);
    } on TimeoutException {
      return const ApiError(message: ApiConstant.requestTimeout);
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
    String? keyImageFile,
    List<File>? imageFiles,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstant.baseUrl}$endpoint');
      final headers = await _getHeaders(isMultiPart);

      // TODO: DELETE LATERR

      LogService.i('POST request to $uri');

      if (isMultiPart && imageFiles != null) {
        var request = http.MultipartRequest('POST', uri);
        request.headers.addAll(headers);

        final bodyMap = body as Map<String, dynamic>;
        bodyMap.forEach((key, value) {
          if (key != keyImageFile) {
            request.fields[key] = value.toString();
          }
        });

        if (keyImageFile == null) {
          return const ApiError(
              message: 'keyImageFile di api_client dan di repo nya null cuk');
        }

        for (var file in imageFiles) {
          var multipartFile = await http.MultipartFile.fromPath(
            keyImageFile,
            file.path,
          );
          request.files.add(multipartFile);
        }

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        // TODO: DELETE LATERR

        LogService.i('Response POST: ${response.body}');

        if (body is List) {
          for (int i = 0; i < body.length; i++) {
            final item = body[i] as Map<String, dynamic>;
            item.forEach((key, value) {
              request.fields['[$i]$key'] = value.toString();
            });
          }
        }
        // TODO: DELETE LATERR

        LogService.i('Response POST: ${response.body}');
        // TODO: DELETE LATERR

        LogService.i('Response POST: ${response.body}');
        // TODO: DELETE LATERR

        LogService.i('status code: ${response.statusCode}');
        return _handleResponse<T>(response, fromJson);
      }

      if (isMultiPart && imageFile != null) {
        var request = http.MultipartRequest('POST', uri);

        request.headers.addAll(headers);

        final bodyMap = body as Map<String, dynamic>;
        bodyMap.forEach((key, value) {
          if (key != keyImageFile) {
            request.fields[key] = value.toString();
          }
        });

        if (keyImageFile == null) {
          return const ApiError(
              message: 'keyImageFile di api_client dan di repo nya null cuk');
        }

        var multipartFile =
            await http.MultipartFile.fromPath(keyImageFile, imageFile.path);
        request.files.add(multipartFile);

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        // TODO: DELETE LATERR

        LogService.i('Response POST: ${response.body}');
        // TODO: DELETE LATERR

        LogService.i('status code: ${response.statusCode}');

        return _handleResponse<T>(response, fromJson);
      }

      final response = await client
          .post(
            uri,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(timeout);

      // TODO: DELETE LATERR

      LogService.i('status code: ${response.statusCode}');

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      return const ApiNoInternet(message: ApiConstant.noInternetConnection);
    } catch (e) {
      // TODO: DELETE LATERR

      LogService.e('POST request failed: $e');
      return ApiError(message: 'POST request failed: $e');
    }
  }

  Future<ApiResponse<T>> patch<T>(
    String endpoint,
    dynamic body, {
    T Function(Map<String, dynamic>)? fromJson,
    bool isMultiPart = false,
    String? keyImageFile,
    File? imageFile,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstant.baseUrl}$endpoint');
      final headers = await _getHeaders(isMultiPart);

      // TODO: DELETE LATERR

      LogService.i('PATCH request to $uri');

      if (isMultiPart && imageFile != null) {
        var request = http.MultipartRequest('PATCH', uri);

        request.headers.addAll(headers);

        final bodyMap = body as Map<String, dynamic>;
        bodyMap.forEach((key, value) {
          if (key != keyImageFile) {
            request.fields[key] = value.toString();
          }
        });

        if (keyImageFile == null) {
          return const ApiError(
              message: 'keyImageFile di api_client dan di repo nya null cuk');
        }

        var multipartFile = await http.MultipartFile.fromPath(
          keyImageFile,
          imageFile.path,
        );
        request.files.add(multipartFile);

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        // TODO: DELETE LATERR

        LogService.i('Response PATCH: ${response.body}');
        // TODO: DELETE LATERR

        LogService.i('status code: ${response.statusCode}');

        return _handleResponse<T>(response, fromJson);
      } else {
        final response = await client
            .patch(
              uri,
              headers: headers,
              body: jsonEncode(body),
            )
            .timeout(timeout);

        // TODO: DELETE LATERR

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

      // TODO: DELETE LATERR

      LogService.i('DELETE request to $uri');

      final response = await client
          .delete(
            uri,
            headers: headers,
          )
          .timeout(timeout);

      // TODO: DELETE LATERR

      LogService.i('Response DELETE: ${response.body}');
      // TODO: DELETE LATERR

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
    try {
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      if (responseBody is! Map<String, dynamic>) throw const FormatException();
      final statusCode = response.statusCode;
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
      final paginationData =
          responseBody['pagination'] as Map<String, dynamic>?;
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
    } on FormatException {
      return ApiError<T>(message: ApiConstant.invalidFormatRes);
    } catch (e) {
      return ApiError<T>(message: ApiConstant.unknownError);
    }
  }
}
