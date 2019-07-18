import 'dart:typed_data';

import 'package:http/http.dart' as http;

class WebServiceResponse {
  final Map<String, String> headers;
  final String body;
  final int statusCode;
  final Uint8List bodyBytes;

  bool get hasError => statusCode > 399;

  WebServiceResponse({this.bodyBytes, this.body, this.headers, this.statusCode});

  WebServiceResponse.emptySuccess()
    : body = '{}',
      bodyBytes = Uint8List(0),
      headers = {},
      statusCode = 200;

  WebServiceResponse.fromHttpResponse(http.Response response)
    : body = response.body,
      bodyBytes = response.bodyBytes,
      headers = response.headers,
      statusCode = response.statusCode;
}