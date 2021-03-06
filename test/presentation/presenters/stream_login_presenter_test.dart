import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class StreamLoginPresenter {
  final Validation validation;
  StreamLoginPresenter({@required this.validation});
  void validateEmail(String email) {
    validation.validate(field: 'email', value: email);
  }
}

abstract class Validation {
  void validate({@required String field, @required String value});
}

class ValidationSpy extends Mock implements Validation {}

void main() {
  test("Should call Validation with correct email", () {
    final validation = ValidationSpy();
    final sut = StreamLoginPresenter(validation: validation);
    final email = faker.internet.email();
    sut.validateEmail(email);
    verify(validation.validate(field: 'email', value: email)).called(1);
  });
}
