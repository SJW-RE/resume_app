// lib/services/pdf_export_isolate.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import '../models/resume.dart';
import 'design_pdf_exporter.dart';
import 'dart:isolate';

/// 顶层函数，供 compute 调用
Future<Uint8List> generatePdfInIsolate(Map<String, dynamic> params) async {
  // 1. 从参数中取出 JSON 字符串
  final resumeJsonStr = params['resumeJson'] as String;
  final style = params['style'] as String;
  final scaleFactor = params['scaleFactor'] as double;

  // 2. 解析 JSON 字符串为 Map
  final resumeMap = jsonDecode(resumeJsonStr) as Map<String, dynamic>;

  // 3. 转换为 Resume 对象
  final resume = Resume.fromJson(resumeMap);

  // 4. 调用原有的 PDF 导出逻辑
  return await DesignPdfExporter.generateDesignPdf(
    resume,
    style,
    userScale: scaleFactor,
  );
}
