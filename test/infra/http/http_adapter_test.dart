import 'package:clean_dart_course/data/http/http_error.dart';
import 'package:clean_dart_course/infra/http/http_adapter.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  ClientSpy client;
  Uri url;
  HttpAdapter sut;
  Map body;
  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client: client);
    url = Uri.parse(faker.internet.httpUrl());
    body = {"any_key": "any_value"};
  });

  group("any_thing", () {
    test("Should throw serverError if invalid method", () async {
      final future = sut.request(url: url, method: "anything");
      expect(future, throwsA(HttpError.serverError));
    });
  });

  group("post", () {
    PostExpectation mockRequest() => when(
        client.post(any, headers: anyNamed("headers"), body: anyNamed("body")));

    void mockResponse(int statusCode, {body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    test("Should call post with correct values", () async {
      mockResponse(200);
      await sut.request(url: url, method: "post", body: body);
      verify(client.post(url,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: '{"any_key":"any_value"}'));
    });

    test("Should call post without body", () async {
      mockResponse(200);
      await sut.request(url: url, method: "post");
      verify(client.post(
        any,
        headers: anyNamed("headers"),
      ));
    });

    test("Should return data if post return 200", () async {
      mockResponse(200);
      final response = await sut.request(url: url, method: "post");
      expect(response, {"any_key": "any_value"});
    });

    test("Should return null if post return 200 without data", () async {
      mockResponse(200, body: '');
      final response = await sut.request(url: url, method: "post");
      expect(response, null);
    });

    test("Should return null if post return 204 without data", () async {
      mockResponse(204, body: '');
      final response = await sut.request(url: url, method: "post");
      expect(response, null);
    });

    test("Should return BadRequest if post returns 400", () async {
      mockResponse(400);
      final future = sut.request(url: url, method: "post");
      expect(future, throwsA(HttpError.badRequest));
    });
    test("Should return unauthorized if post returns 401", () async {
      mockResponse(401);
      final future = sut.request(url: url, method: "post");
      expect(future, throwsA(HttpError.unauthorized));
    });
    test("Should return forbidden if post returns 403", () async {
      mockResponse(403);
      final future = sut.request(url: url, method: "post");
      expect(future, throwsA(HttpError.forbidden));
    });
    test("Should return notFound if post returns 404", () async {
      mockResponse(404);
      final future = sut.request(url: url, method: "post");
      expect(future, throwsA(HttpError.notFound));
    });
    test("Should return serverError if post returns 500", () async {
      mockResponse(500);
      final future = sut.request(url: url, method: "post");
      expect(future, throwsA(HttpError.serverError));
    });

    test("Should return serverError if post throws", () async {
      mockError();
      final future = sut.request(url: url, method: "post");
      expect(future, throwsA(HttpError.serverError));
    });
  });
}
