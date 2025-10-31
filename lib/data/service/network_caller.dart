import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  final Map<String, dynamic>? body;
  final String? errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.body,
    this.errorMessage,
  });
}

class NetworkCaller {
  static const String _defaultErrorMessage = 'Something Went Wrong';

  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, null);
      Response response = await get(uri);
      _logResponse(url, response);
      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          body: decodedJson,
        );
      } else {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedJson['data'] ?? _defaultErrorMessage,
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> postRequest({
    required String url,
    Map<String, String>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url, body);
      Response response = await post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      _logResponse(url, response);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          body: decodedJson,
        );
      } else {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedJson['data'] ?? _defaultErrorMessage,
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> multipartRequest({
    required String url,
    required Map<String, String> fields,
    String? fileField,
    File? file,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      var request = MultipartRequest('POST', uri);

      // Add fields
      request.fields.addAll(fields);

      // Add file if provided
      if (file != null && fileField != null) {
        request.files.add(
          await MultipartFile.fromPath(
            fileField,
            file.path,
            contentType: MediaType('image', 'jpeg'), // Adjust content type as needed
          ),
        );
      }

      _logRequest(url, fields);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      // _logResponse is not directly applicable here as we have a StreamedResponse
      debugPrint(
        '============ Respond =============\n'
            'RESPONSE\n'
            'URL         : $url\n'
            'STATUS CODE : ${response.statusCode}\n'
            'BODY        : $responseBody\n'
            '=========================\n',
      );


      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(responseBody);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          body: decodedJson,
        );
      } else {
        final decodedJson = jsonDecode(responseBody);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedJson['data'] ?? _defaultErrorMessage,
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }


  static void _logRequest(String url, Map<String, String>? body) {
    debugPrint(
      '============ Request =============\n'
          'REQUEST\n'
          'URL  : $url\n'
          'BODY : $body\n'
          '=========================\n',
    );
  }

  static void _logResponse(String url, Response response) {
    debugPrint(
      '============ Respond =============\n'
          'RESPONSE\n'
          'URL         : $url\n'
          'STATUS CODE : ${response.statusCode}\n'
          'BODY        : ${response.body}\n'
          '=========================\n',
    );
  }
}
