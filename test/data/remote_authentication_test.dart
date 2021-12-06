import 'package:clean_dart_course/data/http/http_client.dart';
import 'package:clean_dart_course/data/http/http_error.dart';
import 'package:clean_dart_course/data/usecases/remote_authentication.dart';
import 'package:clean_dart_course/domain/helpers/domain_error.dart';
import 'package:clean_dart_course/domain/usecases/authentication.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  test('Shold call HttpClient with correct URL', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    final accessToken = faker.guid.guid();
    final name = faker.person.name();

    final params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());

    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async => {"accessToken": accessToken, "name": name});

    await sut.auth(params);

    verify(httpClient.request(
        url: url,
        method: "post",
        body: {"email": params.email, "password": params.password}));
  });

  test('Shold throw UnexpectedError if HttpClient returns 400', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);

    final params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Shold throw UnexpectedError if HttpClient returns 404', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.notFound);

    final params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Shold throw UnexpectedError if HttpClient returns 500', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.serverError);

    final params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Shold throw InvalidCredentialsError if HttpClient returns 401',
      () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.unauthorized);

    final params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Shold throw un UnexpectedError if HttpClient returns 200', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    final accessToken = faker.guid.guid();
    final name = faker.person.name();

    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async => {"accessToken": accessToken, "name": name});

    final params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());

    final account = await sut.auth(params);

    expect(account.token, accessToken);
  });

  test('Shold return an Account if HttpClient returns 200 with invalid data',
      () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async => {"invalid_answer": "invalid_data"});

    final params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
