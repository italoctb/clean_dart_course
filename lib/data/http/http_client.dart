import 'package:flutter/material.dart';

abstract class HttpClient {
  Future<Map> request({@required url, @required method, @required body});
}
