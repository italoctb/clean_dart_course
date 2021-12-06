import 'package:clean_dart_course/domain/entities/account_entity.dart';
import 'package:flutter/material.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams {
  String email;
  String password;

  AuthenticationParams({@required this.email, @required this.password});
}
