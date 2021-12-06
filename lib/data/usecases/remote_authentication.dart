import 'package:clean_dart_course/data/http/http_client.dart';
import 'package:clean_dart_course/data/http/http_error.dart';
import 'package:clean_dart_course/data/models/remote_account_model.dart';
import 'package:clean_dart_course/domain/entities/account_entity.dart';
import 'package:clean_dart_course/domain/helpers/domain_error.dart';
import 'package:clean_dart_course/domain/usecases/authentication.dart';
import 'package:flutter/material.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({@required this.httpClient, @required this.url});

  @override
  Future<AccountEntity> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    try {
      final httpResponse =
          await httpClient.request(url: url, method: "post", body: body);
      final model = RemoteAccountModel.fromJson(httpResponse);
      return model.toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  String email;
  String password;

  RemoteAuthenticationParams({@required this.email, @required this.password});

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(
          email: params.email, password: params.password);

  Map toJson() => {"email": email, "password": password};
}
