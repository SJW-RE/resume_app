// lib/services/cloudbase_service.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CloudBaseService {
  static final CloudBaseService _instance = CloudBaseService._internal();
  factory CloudBaseService() => _instance;
  CloudBaseService._internal();

  // 配置
  static const String envId = 'resume-app-d1gm2dwps2d873f70'; // ✅ 替换为你的环境 ID
  static const String region = 'ap-shanghai'; // 你的地域
  static const String baseUrl =
      'https://$envId.$region.tcb-api.tencentcloudapi.com';

  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // 存储 token 的 key
  static const String _tokenKey = 'cloudbase_access_token';
  static const String _uidKey = 'cloudbase_uid';

  /// 获取存储的 Token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// 获取存储的 UID
  Future<String?> getUid() async {
    return await _storage.read(key: _uidKey);
  }

  /// 清除 Token（退出登录）
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _uidKey);
  }

  /// 注册
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/v1/signup',
        data: {'email': email, 'password': password, 'username': username},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-CloudBase-EnvId': envId,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // 保存 token 和 uid
        if (data['token'] != null) {
          await _storage.write(key: _tokenKey, value: data['token']);
        }
        if (data['uid'] != null) {
          await _storage.write(key: _uidKey, value: data['uid'].toString());
        }
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': '注册失败'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// 登录
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/auth/v1/signin',
        data: {'email': email, 'password': password},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-CloudBase-EnvId': envId,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['token'] != null) {
          await _storage.write(key: _tokenKey, value: data['token']);
        }
        if (data['uid'] != null) {
          await _storage.write(key: _uidKey, value: data['uid'].toString());
        }
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': '登录失败'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// 退出登录
  Future<void> logout() async {
    await clearToken();
  }

  /// 获取当前用户信息
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final response = await _dio.get(
        '$baseUrl/auth/v1/user',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'X-CloudBase-EnvId': envId,
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 更新用户信息（如显示名称）
  Future<bool> updateUserInfo({required String username}) async {
    final token = await getToken();
    if (token == null) return false;

    try {
      final response = await _dio.post(
        '$baseUrl/auth/v1/user',
        data: {'username': username},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
            'X-CloudBase-EnvId': envId,
          },
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// 检查是否已登录
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
