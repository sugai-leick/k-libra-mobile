import 'package:flutter/services.dart';
import 'package:flutter_app/core/failures/app_exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class IRememberEmailService {
  Future<void> saveEmail(String email);
  Future<String?> getEmail();
}

class RememberEmailService implements IRememberEmailService {
  final FlutterSecureStorage _storage;
  static const String _emailKey = 'EMAILKEY';

  RememberEmailService({required storage}) : _storage = storage;
  @override
  Future<String?> getEmail() async {
    try {
      return await _storage.read(key: _emailKey);
    } on PlatformException catch (e) {
      throw AppException(
        message: 'Não foi possivel ler o email, por favor insira o manualmente',
      );
    }
  }

  @override
  Future<void> saveEmail(String email) async {
    try {
      await _storage.write(key: _emailKey, value: email);
    } on PlatformException catch (e) {
      throw AppException(
        message: 'Não foi possivel salvar o seu email para login futuro',
      );
    }
  }
}
