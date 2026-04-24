import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/services/http_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Gerencia a sessão do SupabaseClient injetando o JWT manualmente.
class SupabaseSessionManager {
  final SupabaseClient _supabaseClient;

  SupabaseSessionManager(this._supabaseClient);

  /// Injeta o JWT manualmente criando uma sessão "fictícia" que o SDK aceite
  Future<void> setSession({
    required String accessToken,
    String? refreshToken,
  }) async {
    try {
      debugPrint('[SupabaseSessionManager] Forçando sessão manual com JWT externo...');

      // Injeta nos headers do REST
      _supabaseClient.rest.headers['Authorization'] = 'Bearer $accessToken';
      
      // Injeta no Realtime
      _supabaseClient.realtime.setAuth(accessToken);

      // Hack para o SDK considerar que existe um usuário logado (libera o .accessToken)
      // Usamos o setSession mas passando o token como se fosse a sessão atual
      // Se a versão for a 2.x, tentamos o recoverSession ou setSession(token)
      try {
        await _supabaseClient.auth.setSession(refreshToken ?? accessToken);
      } catch (e) {
        debugPrint('[SupabaseSessionManager] Aviso no auth.setSession: $e');
      }

      debugPrint('[SupabaseSessionManager] Sessão injetada. User: ${_supabaseClient.auth.currentUser?.email}');
      debugPrint('[SupabaseSessionManager] Token atual no cliente: ${_supabaseClient.auth.currentSession?.accessToken != null ? 'OK' : 'NULL'}');
      
    } catch (e) {
      debugPrint('[SupabaseSessionManager] Erro ao injetar JWT: $e');
    }
  }

  Future<void> restoreSession({
    required String accessToken,
    String? refreshToken,
  }) async {
    await setSession(accessToken: accessToken, refreshToken: refreshToken);
  }

  /// Verifica se o token atual ainda é válido no banco de dados e na API.
  Future<bool> isSessionValid(HttpService httpService) async {
    try {
      // 1. Valida no Supabase
      await _supabaseClient.from('customers').select('id').limit(1);
      
      // 2. Valida na API NestJS (fazendo um request simples de perfil ou similar)
      // Se não tiver um /auth/me, usamos o /customers que sabemos que exige auth
      await httpService.get('/customers', queryParameters: {'limit': 1});
      
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> clearSession() async {
    try {
      _supabaseClient.rest.headers.remove('Authorization');
      await _supabaseClient.auth.signOut();
    } catch (e) {
      debugPrint('[SupabaseSessionManager] Erro ao encerrar sessão: $e');
    }
  }

  bool get hasActiveSession => _supabaseClient.auth.currentSession != null || _supabaseClient.rest.headers.containsKey('Authorization');
}
