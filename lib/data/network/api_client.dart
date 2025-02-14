// ignore_for_file: require_trailing_commas

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/local/token_sp.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';

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
    CancelToken? cancelToken,
    int retryMax = 3,
  }) async {
    return _executeRequestWithRetry(() async {
      Uri uri = Uri.parse('${ApiConstant.baseUrl}$endpoint');
      if (queryParameters != null) {
        uri = uri.replace(queryParameters: queryParameters);
      }
      LogService.i('GET request to $uri');
      final headers = await _getHeaders(false);
      final response = await client.get(uri, headers: headers).timeout(timeout);
      LogService.i('Response GET: ${response.body}');
      return _handleResponse<T>(response, fromJson);
    }, cancelToken: cancelToken, maxRetries: retryMax);
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint,
    dynamic body, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
    bool isMultiPart = false,
    File? imageFile,
    String? keyImageFile,
    List<File>? imageFiles,
    CancelToken? cancelToken,
    int retryMax = 3,
  }) async {
    return _executeRequestWithRetry(() async {
      Uri uri = Uri.parse('${ApiConstant.baseUrl}$endpoint');
      if (queryParameters != null) {
        uri = uri.replace(queryParameters: queryParameters);
      }
      final headers = await _getHeaders(isMultiPart);
      LogService.i('POST request to $uri');

      if (isMultiPart && imageFiles != null) {
        return _sendMultipartRequest<T>(
          'POST',
          uri,
          headers,
          body as Map<String, dynamic>,
          keyImageFile,
          imageFiles: imageFiles,
          fromJson: fromJson,
        );
      }

      if (isMultiPart && imageFile != null) {
        return _sendMultipartRequest<T>(
          'POST',
          uri,
          headers,
          body as Map<String, dynamic>,
          keyImageFile,
          imageFile: imageFile,
          fromJson: fromJson,
        );
      }

      final response = await client
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(timeout);
      LogService.i('Response POST: ${response.body}');
      LogService.i('status code POST: ${response.statusCode}');
      return _handleResponse<T>(response, fromJson);
    }, cancelToken: cancelToken, maxRetries: retryMax);
  }

  Future<ApiResponse<T>> patch<T>(
    String endpoint,
    dynamic body, {
    T Function(Map<String, dynamic>)? fromJson,
    bool isMultiPart = false,
    String? keyImageFile,
    File? imageFile,
    List<File>? imageFiles,
    CancelToken? cancelToken,
    int retryMax = 3,
  }) async {
    return _executeRequestWithRetry(() async {
      final uri = Uri.parse('${ApiConstant.baseUrl}$endpoint');
      final headers = await _getHeaders(isMultiPart);
      LogService.i('PATCH request to $uri');
      LogService.i('body: $body');

      if (isMultiPart && imageFiles != null) {
        return _sendMultipartRequest<T>(
          'PATCH',
          uri,
          headers,
          body as Map<String, dynamic>,
          keyImageFile,
          imageFiles: imageFiles,
          fromJson: fromJson,
        );
      }

      if (isMultiPart && imageFile != null) {
        return _sendMultipartRequest<T>(
          'PATCH',
          uri,
          headers,
          body as Map<String, dynamic>,
          keyImageFile,
          imageFile: imageFile,
          fromJson: fromJson,
        );
      }

      final response = await client
          .patch(uri, headers: headers, body: jsonEncode(body))
          .timeout(timeout);
      LogService.i('Response PATCH: ${response.body}');
      LogService.i('status code: patch ${response.statusCode}');
      return _handleResponse<T>(response, fromJson);
    }, cancelToken: cancelToken, maxRetries: retryMax);
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(Map<String, dynamic>)? fromJson,
    CancelToken? cancelToken,
    int retryMax = 3,
  }) async {
    return _executeRequestWithRetry(() async {
      final uri = Uri.parse('${ApiConstant.baseUrl}$endpoint');
      final headers = await _getHeaders(false);
      LogService.i('DELETE request to $uri');
      final response =
          await client.delete(uri, headers: headers).timeout(timeout);
      LogService.i('Response DELETE: ${response.body}');
      LogService.i('status code DELETE: ${response.statusCode}');
      return _handleResponse<T>(response, fromJson);
    }, cancelToken: cancelToken, maxRetries: retryMax);
  }

  Future<ApiResponse<T>> _sendMultipartRequest<T>(
    String method,
    Uri uri,
    Map<String, String> headers,
    Map<String, dynamic> bodyMap,
    String? keyImageFile, {
    File? imageFile,
    List<File>? imageFiles,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    if (keyImageFile == null) {
      return const ApiError(
          message: 'keyImageFile di api_client dan di repo nya null');
    }

    final request = http.MultipartRequest(method, uri);
    request.headers.addAll(headers);

    LogService.i('bodyMap: $bodyMap');

    bodyMap.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    if (imageFiles != null) {
      for (var file in imageFiles) {
        final multipartFile =
            await http.MultipartFile.fromPath(keyImageFile, file.path);
        request.files.add(multipartFile);
      }
    } else if (imageFile != null) {
      final multipartFile =
          await http.MultipartFile.fromPath(keyImageFile, imageFile.path);
      request.files.add(multipartFile);
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse<T>(response, fromJson);
  }

  Future<ApiResponse<T>> _executeRequestWithRetry<T>(
    Future<ApiResponse<T>> Function() request, {
    CancelToken? cancelToken,
    int maxRetries = 3,
  }) async {
    int attempt = 0;
    while (true) {
      if (cancelToken?.isCancelled == true) {
        return ApiError<T>(
          message: ApiConstant.cancelTokenException,
        );
      }

      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return const ApiNoInternet(
          message: ApiConstant.socketException,
        );
      }

      try {
        final response = await request().timeout(timeout, onTimeout: () {
          cancelToken?.cancel();
          return ApiError<T>(
            message: ApiConstant.requestTimeout,
          );
        });

        if (response is ApiError &&
            (response.message == ApiConstant.noInternetConnection ||
                response.message == ApiConstant.requestTimeout)) {
          if (attempt < maxRetries) {
            attempt++;
            LogService.i(
                'Mengulangi request karena error server (message: ${response.message}), percobaan ke-$attempt');
            await Future.delayed(const Duration(seconds: 1));
            continue;
          }
        }
        return response;
      } catch (e) {
        if (attempt < maxRetries) {
          attempt++;
          LogService.i(
              'Mengulangi request karena exception: $e, percobaan ke-$attempt');
          await Future.delayed(const Duration(seconds: 1));
          continue;
        }
        if (cancelToken?.isCancelled == true) {
          return ApiError<T>(
            message: ApiConstant.cancelTokenException,
          );
        }
        return ApiError<T>(
          message: _getUserFriendlyErrorMessage(e, maxRetries, attempt),
        );
      }
    }
  }

  String _getUserFriendlyErrorMessage(
    Object error,
    int maxRetries,
    int attempts,
  ) {
    switch (error) {
      case TimeoutException _:
        return ApiConstant.requestTimeout;
      case SocketException _:
        return ApiConstant.socketException;
      case http.ClientException _:
        return ApiConstant.clientException;
      case HttpException _:
        return ApiConstant.httpException;
      case FormatException _:
        return ApiConstant.formatException;
      case HandshakeException _:
        return ApiConstant.handshakeException;
      default:
        return ApiConstant.unknownError;
    }
  }

  Future<Map<String, String>> _getHeaders(bool isMultiPart) async {
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

      LogService.i('Response: $responseBody');

      if (statusCode >= 300) {
        return ApiError<T>(
          message: message,
          errors: errors,
        );
      }

      final data = responseBody['data'];
      final paginationData =
          responseBody['pagination'] as Map<String, dynamic>?;

      if (paginationData == null) {
        return ApiSuccess<T>(
          message: message,
          data: fromJson?.call(data) ?? data as T,
        );
      }

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
      LogService.e('Error: $e');
      return ApiError<T>(message: ApiConstant.unknownError);
    }
  }
}
