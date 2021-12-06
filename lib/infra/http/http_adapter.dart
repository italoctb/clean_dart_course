import 'dart:convert';

import 'package:clean_dart_course/data/http/http_client.dart';
import 'package:clean_dart_course/data/http/http_error.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter({@required this.client});
  @override
  Future<Map> request({@required url, @required method, body}) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    var response = Response("", 500);
    try {
      if (method == "post") {
        response = await client.post(url, headers: headers, body: jsonBody);
      }
    } catch (error) {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body.isEmpty ? null : jsonDecode(response.body);
      case 204:
        return null;
      case 400:
        return throw HttpError.badRequest;
      case 401:
        return throw HttpError.unauthorized;
      case 403:
        return throw HttpError.forbidden;
      case 404:
        return throw HttpError.notFound;
      case 500:
        return throw HttpError.serverError;
    }
    return null;
  }
}
