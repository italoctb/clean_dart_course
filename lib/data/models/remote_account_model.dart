import 'package:clean_dart_course/data/http/http_error.dart';
import 'package:clean_dart_course/domain/entities/account_entity.dart';

class RemoteAccountModel {
  final String token;

  RemoteAccountModel(this.token);

  factory RemoteAccountModel.fromJson(Map httpResponse) {
    if (!httpResponse.containsKey("accessToken")) {
      return throw HttpError.invalidData;
    }
    return RemoteAccountModel(httpResponse["accessToken"]);
  }

  AccountEntity toEntity() => AccountEntity(token);
}
