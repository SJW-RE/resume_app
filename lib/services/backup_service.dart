// lib/services/backup_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
//import 'dart:html' as html; // Web端使用
import '../models/resume.dart';
import 'resume_storage.dart';

class BackupService {
  /// 导出所有简历为 JSON 字符串
  static String exportAllResumes() {
    final resumes = ResumeStorage.getAllResumes();
    final jsonList = resumes.map((r) => r.toJson()).toList();
    return jsonEncode(jsonList);
  }

  /// 导入 JSON 数据并恢复简历
  static Future<int> importResumes(String jsonStr) async {
    try {
      final List<dynamic> jsonList = jsonDecode(jsonStr);
      int count = 0;
      for (var item in jsonList) {
        final resume = Resume.fromJson(item);
        await ResumeStorage.saveResume(resume);
        count++;
      }
      return count;
    } catch (e) {
      throw Exception('导入失败: $e');
    }
  }

  /// 下载 JSON 备份文件（Web端）
  static void downloadWeb(
    String jsonStr, {
    String filename = 'resume_backup.json',
  }) {
    /*if (!kIsWeb) return;
    final blob = html.Blob([jsonStr], 'application/json');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    Future.delayed(const Duration(seconds: 5), () {
      html.Url.revokeObjectUrl(url);
    });*/
  }

  /// 导出并分享文件（移动端）
  static Future<void> shareBackup(
    String jsonStr, {
    String filename = 'resume_backup.json',
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(jsonStr);
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      // 如果分享失败，至少保存到本地
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(jsonStr);
    }
  }

  /// 选择 JSON 文件导入（移动端）
  static Future<String?> pickAndReadBackupFile() async {
    // 移动端：使用 file_picker
    // 需添加依赖：file_picker: ^6.1.1
    // final result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['json'],
    // );
    // if (result != null && result.files.single.path != null) {
    //   final file = File(result.files.single.path!);
    //   return await file.readAsString();
    // }
    return null;
  }
}
