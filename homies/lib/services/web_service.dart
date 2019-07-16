import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';

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

  Map<String, String> _defaultHeaders = {
    "content-type": "application/json",
    "accept": "application/json"
  };

  String apiEndpoint = "127.0.0.1:3000";

  String loginEndpoint = "/auth/login";
  String logoutEndpoint = "/auth/logout";

  Future<WebServiceResponse> login({@required String email, @required String password}) async {
    var uri = _getUri(loginEndpoint).toString();

    var body = {
      'email': email,
      'password': password
    };

    var response = await _performHttpRequest(verb: HttpRequest.Post, uri: uri, body: json.encode(body));

    return WebServiceResponse.fromHttpResponse(response);
  }

  Future<WebServiceResponse> logout() async {
    var uri = _getUri(logoutEndpoint).toString();

    var response = await _performHttpRequest(verb: HttpRequest.Post, uri: uri);

    return WebServiceResponse.fromHttpResponse(response);
  }

  Future<http.Response> _performHttpRequest({@required HttpRequest verb, @required String uri, String body, int timeOutInSeconds = DefaultTimeoutInSeconds}) async {
    var requestHeaders = Map<String, String>.from(_defaultHeaders);

    http.Response response;
    try {
      bool cancelled = false;
      var request = CancelableOperation.fromFuture(_getHttpRequestForVerb(
        verb: verb, uri: uri, body: body, requestHeaders: requestHeaders
      ));

      var cancelTimer = Timer(Duration(seconds: timeOutInSeconds), () {
        cancelled = true;
        request.cancel();
      });

      response = await request.valueOrCancellation();
      cancelTimer.cancel();

      if (cancelled == true) {
        print("Request Cancelled");
        throw new TimeoutException('Request Cancelled');
      }

    } on TimeoutException catch (e) {
      response = http.Response('Timeout occured: ${e.message}', 602);
    } on SocketException catch (e) {
      response = http.Response('No network or network failure: ${e.message}', 602);
    } catch (e) {
      response = http.Response('General exception: ${e.message}', 602);
    }

    if (response != null && response.statusCode == 401) {
      return http.Response('Authorization Required', 601);
    }

    return response;
  }

  Future<http.Response> _getHttpRequestForVerb(
    {HttpRequest verb,
      String uri,
      String body,
      Map<String, String> requestHeaders}) {

    if (verb == HttpRequest.Post) {
      return http.post(uri, body: body, headers: requestHeaders);
    } else if (verb == HttpRequest.Get) {
      return http.get(uri, headers: requestHeaders);
    }
    
    return Future.error('No verb defined for $verb');
  }

  Uri _getUri(String apiPath, {Map<String, String> parameters}) {
    if (parameters == null) {
      parameters = Map<String, String>();
    }

    return Uri.http(apiEndpoint, apiPath, parameters);
  }

}