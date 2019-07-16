import 'package:flutter/foundation.dart';
import 'package:homies/models/web_service_response.dart';
import 'package:http/http.dart' as http;

enum HttpRequest { Get, Post, Head, Update }

const int DefaultTimeoutInSeconds = 30;

class WebService {
  static WebService _instance;

  static WebService getInstance() {
    if (_instance == null) {
      _instance = WebService();
    }

    return _instance;
  }

  Map<String, String> _defaultHeaders = {};

  String apiEndpoint = "http://127.0.0.1:3000";
  String loginEndpoint = "/auth/login";

  Future<WebServiceResponse> login({@required String email, @required String password}) async {
    var uri = _getUri(loginEndpoint, parameters: {'email': email, 'password': password}).toString();

    var response = await _performHttpRequest(verb: HttpRequest.Get, uri: uri);

    return WebServiceResponse.fromHttpResponse(response);
  }

  Future<http.Response> _performHttpRequest({@required HttpRequest verb, @required String uri, String body, int timeOutInSeconds = DefaultTimeoutInSeconds}) {


  }

  Uri _getUri(String apiPath, {Map<String, String> parameters}) {
    if (parameters == null) {
      parameters = Map<String, String>();
    }

    return Uri.http(apiEndpoint, apiPath, parameters);
  }

}