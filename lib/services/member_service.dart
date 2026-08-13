// lib/services/member_service.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/member.dart';
import 'cloudbase_service.dart';

class MemberService {
  static const String collection = 'members';

  /// 获取当前用户的会员信息
  static Future<Member?> getMemberInfo() async {
    final uid = await CloudBaseService().getUid();
    if (uid == null) return null;

    final token = await CloudBaseService().getToken();
    if (token == null) return null;

    try {
      final dio = Dio();
      final envId = CloudBaseService.envId;
      final response = await dio.get(
        'https://$envId.ap-shanghai.tcb-api.tencentcloudapi.com/database/v1/collections/$collection/documents',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final documents = data['data'] as List? ?? [];
        // 查找当前用户的会员记录
        for (var doc in documents) {
          if (doc['uid'] == uid) {
            return Member.fromJson(doc);
          }
        }
        // 如果没有记录，创建默认免费会员
        return await _createDefaultMember(uid);
      }
      return null;
    } catch (e) {
      print('获取会员信息失败: $e');
      return null;
    }
  }

  /// 创建默认免费会员
  static Future<Member> _createDefaultMember(String uid) async {
    final member = Member(uid: uid, level: 'free');
    await updateMember(member);
    return member;
  }

  /// 更新会员信息（升级/续费）
  static Future<bool> updateMember(Member member) async {
    final token = await CloudBaseService().getToken();
    if (token == null) return false;

    try {
      final dio = Dio();
      final envId = CloudBaseService.envId;

      // 先查询是否存在记录
      final queryResponse = await dio.get(
        'https://$envId.ap-shanghai.tcb-api.tencentcloudapi.com/database/v1/collections/$collection/documents',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (queryResponse.statusCode == 200) {
        final documents = queryResponse.data['data'] as List? ?? [];
        var existingDoc = documents.firstWhere(
          (doc) => doc['uid'] == member.uid,
          orElse: () => null,
        );

        if (existingDoc != null) {
          // 更新已有记录
          final docId = existingDoc['_id'];
          await dio.patch(
            'https://$envId.ap-shanghai.tcb-api.tencentcloudapi.com/database/v1/collections/$collection/documents/$docId',
            data: member.toJson(),
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
            ),
          );
        } else {
          // 新增记录
          await dio.post(
            'https://$envId.ap-shanghai.tcb-api.tencentcloudapi.com/database/v1/collections/$collection/documents',
            data: member.toJson(),
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
            ),
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      print('更新会员信息失败: $e');
      return false;
    }
  }

  /// 升级会员（模拟支付，实际接入支付 SDK）
  static Future<bool> upgradeToPremium({int months = 1}) async {
    final uid = await CloudBaseService().getUid();
    if (uid == null) return false;

    // 计算过期时间
    final expireAt = DateTime.now().add(Duration(days: months * 30));
    final member = Member(uid: uid, level: 'premium', expireAt: expireAt);

    return await updateMember(member);
  }
}
