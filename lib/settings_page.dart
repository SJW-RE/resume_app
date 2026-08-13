import 'dart:convert';
//import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../services/resume_storage.dart';
import '../services/backup_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLoading = false;

  // ============================================================
  // 数据备份与恢复
  // ============================================================
  Future<void> _exportBackup() async {
    try {
      final jsonStr = BackupService.exportAllResumes();
      if (kIsWeb) {
        BackupService.downloadWeb(jsonStr, filename: 'resume_backup.json');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('备份文件已开始下载')));
        }
      } else {
        await BackupService.shareBackup(jsonStr);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('导出失败: $e')));
      }
    }
  }

  Future<void> _importBackup() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Web 导入功能暂不可用')));
      return;
      /*final input = html.FileUploadInputElement();
      input.accept = '.json';
      input.click();
      input.onChange.listen((event) async {
        final file = input.files?.first;
        if (file == null) return;
        final reader = html.FileReader();
        reader.readAsText(file);
        reader.onLoadEnd.listen((event) async {
          final jsonStr = reader.result as String?;
          if (jsonStr != null) {
            await _doImport(jsonStr);
          }
        });
      });*/
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('移动端导入功能开发中')));
      }
    }
  }

  Future<void> _doImport(String jsonStr) async {
    try {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('确认导入'),
          content: const Text('导入将替换所有现有数据，确认继续？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('确认导入'),
            ),
          ],
        ),
      );
      if (confirm != true) return;

      setState(() => _isLoading = true);
      final count = await BackupService.importResumes(jsonStr);
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('成功导入 $count 份简历')));
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('导入失败: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('数据备份'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 说明文字
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '备份所有简历数据为 JSON 文件，\n可在其他设备上恢复',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 导出备份
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.download,
                  color: Colors.blue,
                  size: 32,
                ),
                title: const Text(
                  '导出备份',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: const Text('导出所有简历数据为 JSON 文件'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _exportBackup,
              ),
            ),
            const SizedBox(height: 12),

            // 导入备份
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.upload,
                  color: Colors.green,
                  size: 32,
                ),
                title: const Text(
                  '导入备份',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: const Text('从 JSON 文件恢复简历数据'),
                trailing: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.chevron_right),
                onTap: _isLoading ? null : _importBackup,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
