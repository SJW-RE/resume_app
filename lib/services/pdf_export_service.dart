// lib/services/pdf_export_service.dart
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import '../../models/resume.dart';
import '../services/design_pdf_exporter.dart'; // 你原有的 PDF 导出类
import '../services/ats_pdf_exporter.dart'; // 你原有的 PDF 导出类

// ✅ 顶层函数：供 compute 调用
Future<Uint8List> generatePdfInIsolate({
  required Resume resume,
  required String style,
  required double scaleFactor,
}) async {
  // 在 Isolate 中重新加载字体（因为 isolate 无法共享主 isolate 的缓存）
  final fontData = await rootBundle.load('assets/fonts/SourceHanSansCN-Regular.ttf');
  final boldFontData = await rootBundle.load('assets/fonts/SourceHanSansCN-Bold.ttf');
  final faFontData = await rootBundle.load('assets/fonts/fa-solid-900.ttf');
  
  // 调用原有的导出逻辑
  return await DesignPdfExporter.generateDesignPdf(
    resume,
    style,
    userScale: scaleFactor,
  );
}