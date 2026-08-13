import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/resume.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResumeStorage {
  static Box<String> get box => Hive.box<String>('resumes_json');

  static Future<void> saveResume(Resume resume) async {
    try {
      final jsonStr = jsonEncode(resume.toJson());
      await box.put(resume.id, jsonStr);
      print('✅ 保存成功: ${resume.name}, ID: ${resume.id}');
      print('✅ 数据内容: $jsonStr');
    } catch (e) {
      print('❌ 保存失败: $e');
      rethrow;
    }
  }

  static List<Resume> getAllResumes() {
    try {
      return box.values
          .map((jsonStr) {
            try {
              final Map<String, dynamic> map = jsonDecode(jsonStr);
              return Resume.fromJson(map);
            } catch (e) {
              print('⚠️ 单条数据解析失败: $e');
              print('⚠️ 原始数据: $jsonStr');
              return null; // 跳过损坏的数据
            }
          })
          .whereType<Resume>()
          .toList(); // 过滤掉 null
    } catch (e) {
      print('❌ 读取所有简历失败: $e');
      return [];
    }
  }

  static Future<void> deleteResume(String id) async {
    try {
      await box.delete(id);
      print('✅ 删除成功: $id');
    } catch (e) {
      print('❌ 删除失败: $e');
      rethrow;
    }
  }

  static Resume? getResume(String id) {
    try {
      final jsonStr = box.get(id);
      if (jsonStr == null) return null;
      return Resume.fromJson(jsonDecode(jsonStr));
    } catch (e) {
      print('❌ 获取简历失败: $e');
      return null;
    }
  }

  // 调试方法：打印所有存储的数据
  static void debugPrintAll() {
    print('📦 存储的原始数据:');
    for (var key in box.keys) {
      print('Key: $key');
      print('Data: ${box.get(key)}');
    }
    print('📊 共 ${box.keys.length} 条数据');
  }

static Future<void> clearAll() async {
  final prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys();
  for (var key in keys) {
    if (key.startsWith('resume_')) {
      await prefs.remove(key);
    }
  }
}

}
