
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import '../models/resume.dart';

class PdfExporter {
  // 现有方法：导出 ATS 模板
  static Future<Uint8List> generateAtsPdf(Resume resume) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load(
      'assets/fonts/SourceHanSansCN-VF.ttf',
    );
    final font = pw.Font.ttf(fontData.buffer.asByteData());

    final content = _buildContent(resume, font);

    // 每页最多显示 80 个 Widget 项（比之前更紧凑）
    const int itemsPerPage = 80;
    int totalItems = content.length;

    for (int i = 0; i < totalItems; i += itemsPerPage) {
      final pageItems = content.skip(i).take(itemsPerPage).toList();
      pdf.addPage(
        pw.Page(
          margin: const pw.EdgeInsets.all(48), // 减小页边距
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: pageItems,
            );
          },
        ),
      );
    }

    return await pdf.save();
  }

  static List<pw.Widget> _buildContent(Resume resume, pw.Font font) {
    final List<pw.Widget> content = [];

    // ---- 个人信息（紧凑） ----
    content.add(
      pw.Text(
        resume.personal.fullName,
        style: pw.TextStyle(
          font: font,
          fontSize: 22,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
    content.add(pw.SizedBox(height: 2));
    content.add(
      pw.Text(
        resume.personal.jobTitle,
        style: pw.TextStyle(font: font, fontSize: 13, color: PdfColors.grey),
      ),
    );
    content.add(pw.SizedBox(height: 6));

    final contacts = <pw.Widget>[];
    if (resume.personal.phone.isNotEmpty) {
      contacts.add(
        pw.Text(
          '电话：${resume.personal.phone}',
          style: pw.TextStyle(font: font, fontSize: 10),
        ),
      );
    }
    if (resume.personal.email.isNotEmpty) {
      contacts.add(
        pw.Text(
          '邮箱：${resume.personal.email}',
          style: pw.TextStyle(font: font, fontSize: 10),
        ),
      );
    }
    if (contacts.isNotEmpty) {
      content.add(pw.Wrap(spacing: 12, children: contacts));
    }
    content.add(pw.Divider(thickness: 0.5));
    content.add(pw.SizedBox(height: 4));

    // ---- 工作经历 ----
    if (resume.workExperiences.isNotEmpty) {
      content.add(
        pw.Text(
          '工作经历',
          style: pw.TextStyle(
            font: font,
            fontSize: 15,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );
      content.add(pw.SizedBox(height: 4));

      for (final exp in resume.workExperiences) {
        final expChildren = <pw.Widget>[];
        expChildren.add(
          pw.Text(
            '${exp.position} @ ${exp.company}',
            style: pw.TextStyle(
              font: font,
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        );
        expChildren.add(
          pw.Text(
            '${exp.startDate.year} - ${exp.endDate?.year ?? '至今'}',
            style: pw.TextStyle(
              font: font,
              fontSize: 10,
              color: PdfColors.grey,
            ),
          ),
        );
        if (exp.description.isNotEmpty) {
          expChildren.add(pw.SizedBox(height: 2));
          final lines = exp.description.split('\n');
          for (final line in lines) {
            final trimmed = line.trim();
            if (trimmed.isNotEmpty) {
              expChildren.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 6, bottom: 1),
                  child: pw.Text(
                    '- $trimmed',
                    style: pw.TextStyle(font: font, fontSize: 10.5),
                  ),
                ),
              );
            }
          }
        }
        expChildren.add(pw.SizedBox(height: 4));
        content.add(
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: expChildren,
          ),
        );
      }
      content.add(pw.SizedBox(height: 4));
    }

    // ---- 教育经历 ----
    if (resume.educations.isNotEmpty) {
      content.add(
        pw.Text(
          '教育经历',
          style: pw.TextStyle(
            font: font,
            fontSize: 15,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );
      content.add(pw.SizedBox(height: 4));

      for (final edu in resume.educations) {
        final eduChildren = <pw.Widget>[];
        eduChildren.add(
          pw.Text(
            '${edu.degree} @ ${edu.school}',
            style: pw.TextStyle(
              font: font,
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        );
        eduChildren.add(
          pw.Text(
            '${edu.startDate.year} - ${edu.endDate?.year ?? '至今'}',
            style: pw.TextStyle(
              font: font,
              fontSize: 10,
              color: PdfColors.grey,
            ),
          ),
        );
        if (edu.description.isNotEmpty) {
          eduChildren.add(pw.SizedBox(height: 2));
          final lines = edu.description.split('\n');
          for (final line in lines) {
            final trimmed = line.trim();
            if (trimmed.isNotEmpty) {
              eduChildren.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 6, bottom: 1),
                  child: pw.Text(
                    '- $trimmed',
                    style: pw.TextStyle(font: font, fontSize: 10.5),
                  ),
                ),
              );
            }
          }
        }
        eduChildren.add(pw.SizedBox(height: 6));
        content.add(
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: eduChildren,
          ),
        );
      }
      content.add(pw.SizedBox(height: 4));
    }

    // ---- 项目经验 ----
    if (resume.projects.isNotEmpty) {
      content.add(
        pw.Text(
          '项目经验',
          style: pw.TextStyle(
            font: font,
            fontSize: 15,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );
      content.add(pw.SizedBox(height: 4));

      for (final proj in resume.projects) {
        final projChildren = <pw.Widget>[];
        projChildren.add(
          pw.Text(
            proj.name,
            style: pw.TextStyle(
              font: font,
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        );
        if (proj.role.isNotEmpty) {
          projChildren.add(
            pw.Text(
              '角色: ${proj.role}',
              style: pw.TextStyle(
                font: font,
                fontSize: 10,
                color: PdfColors.grey,
              ),
            ),
          );
        }
        if (proj.description.isNotEmpty) {
          projChildren.add(pw.SizedBox(height: 2));
          final lines = proj.description.split('\n');
          for (final line in lines) {
            final trimmed = line.trim();
            if (trimmed.isNotEmpty) {
              projChildren.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 6, bottom: 1),
                  child: pw.Text(
                    '- $trimmed',
                    style: pw.TextStyle(font: font, fontSize: 10.5),
                  ),
                ),
              );
            }
          }
        }
        projChildren.add(pw.SizedBox(height: 4));
        content.add(
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: projChildren,
          ),
        );
      }
      content.add(pw.SizedBox(height: 4));
    }

    // ---- 技能（单行显示，更紧凑） ----
    if (resume.skills.isNotEmpty) {
      content.add(
        pw.Text(
          '技能',
          style: pw.TextStyle(
            font: font,
            fontSize: 15,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );
      content.add(pw.SizedBox(height: 3));
      content.add(
        pw.Text(
          resume.skills.map((s) => s.name).join(' 、 '),
          style: pw.TextStyle(font: font, fontSize: 11),
        ),
      );
      content.add(pw.SizedBox(height: 4));
    }

    // ---- 个人总结 ----
    if (resume.summary.isNotEmpty) {
      content.add(
        pw.Text(
          '个人总结',
          style: pw.TextStyle(
            font: font,
            fontSize: 15,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );
      content.add(pw.SizedBox(height: 3));
      content.add(
        pw.Text(
          resume.summary,
          style: pw.TextStyle(font: font, fontSize: 10.5, height: 1.5),
        ),
      );
    }

    return content;
  }

  // ... 原有的 ATS 导出代码（保持不变）

  // 新增：导出设计模板
  static Future<Uint8List> generateDesignPdf(
    Resume resume,
    String style,
  ) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load(
      'assets/fonts/SourceHanSansCN-VF.ttf',
    );
    final font = pw.Font.ttf(fontData.buffer.asByteData());

    // 根据风格选择配色方案
    final theme = _getThemeForStyle(style);

    final content = _buildDesignContent(resume, font, theme);

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(0),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: content,
          );
        },
      ),
    );

    return await pdf.save();
  }

  // 配色方案
  static _ThemeColors _getThemeForStyle(String style) {
    switch (style) {
      case 'modern':
        return _ThemeColors(
          primary: PdfColors.blue700,
          secondary: PdfColors.amber600,
          background: PdfColors.white,
          text: PdfColors.black,
        );
      case 'classic':
        return _ThemeColors(
          primary: PdfColors.indigo900,
          secondary: PdfColors.amber400,
          background: PdfColors.grey50,
          text: PdfColors.black,
        );
      case 'creative':
        return _ThemeColors(
          primary: PdfColors.pink600,
          secondary: PdfColors.cyan600,
          background: PdfColors.white,
          text: PdfColors.black,
        );
      case 'dark':
        return _ThemeColors(
          primary: PdfColors.purple300,
          secondary: PdfColors.teal300,
          background: PdfColors.grey900,
          text: PdfColors.white,
        );
      default:
        return _ThemeColors(
          primary: PdfColors.blue700,
          secondary: PdfColors.amber600,
          background: PdfColors.white,
          text: PdfColors.black,
        );
    }
  }

  // lib/services/pdf_exporter.dart

  static List<pw.Widget> _buildDesignContent(
    Resume resume,
    pw.Font font,
    _ThemeColors theme,
  ) {
    final List<pw.Widget> content = [];

    // 左右分栏放在 Expanded 中，自动填满页面高度
    content.add(
      pw.Expanded(
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // ---- 左侧栏（35%） ----
            pw.Expanded(
              flex: 35,
              child: pw.Container(
                decoration: pw.BoxDecoration(
                  color: PdfColor(0.8, 0.9, 1.0), // 浅蓝色
                ),
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(14),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      // 头像
                      pw.SizedBox(height: 24),
                      pw.Container(
                        width: 130,
                        height: 130,
                        decoration: pw.BoxDecoration(
                          color: theme.primary,
                          shape: pw.BoxShape.circle,
                        ),
                        child: pw.Center(
                          child: pw.Text(
                            resume.personal.fullName.isNotEmpty
                                ? resume.personal.fullName[0]
                                : '?',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 28,
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 24),

                      // 基础信息
                      pw.Container(
                        width: double.infinity,
                        padding: const pw.EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        decoration: pw.BoxDecoration(
                          borderRadius: pw.BorderRadius.circular(6),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.SizedBox(height: 20),
                            if (resume.personal.phone.isNotEmpty)
                              pw.Text(
                                '电话：${resume.personal.phone}',
                                style: pw.TextStyle(font: font, fontSize: 12),
                              ),
                            pw.SizedBox(height: 20),
                            if (resume.personal.email.isNotEmpty)
                              pw.Text(
                                '邮箱：${resume.personal.email}',
                                style: pw.TextStyle(font: font, fontSize: 12),
                              ),
                            pw.SizedBox(height: 14),
                            if (resume.personal.phone.isEmpty &&
                                resume.personal.email.isEmpty)
                              pw.Text(
                                '未填写联系方式',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColors.grey,
                                ),
                              ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 16),

                      // 技能特长
                      _buildPdfSectionTitle(
                        '技能特长',
                        font,
                        icon: '◆',
                        color: theme.primary,
                      ),
                      pw.SizedBox(height: 20),
                      if (resume.skills.isNotEmpty)
                        pw.Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: resume.skills.map((s) {
                            return pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: pw.BoxDecoration(
                                color: PdfColors.white,
                                borderRadius: pw.BorderRadius.circular(12),
                                border: pw.Border.all(
                                  color: theme.primary.withAlpha(0.3),
                                ),
                              ),
                              child: pw.Text(
                                s.name,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 12,
                                  color: theme.primary,
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      else
                        pw.Text(
                          '暂无技能',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 9,
                            color: PdfColors.grey,
                          ),
                        ),
                      pw.SizedBox(height: 16),

                      // 语言能力
                      _buildPdfSectionTitle('语言能力', font),
                      pw.SizedBox(height: 20),
                      if (resume.skills.isNotEmpty)
                        pw.Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: resume.skills.take(3).map((s) {
                            return pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: pw.BoxDecoration(
                                color: PdfColors.white,
                                borderRadius: pw.BorderRadius.circular(12),
                                border: pw.Border.all(
                                  color: theme.primary.withAlpha(0.3),
                                ),
                              ),
                              child: pw.Text(
                                s.name,
                                style: pw.TextStyle(font: font, fontSize: 12),
                              ),
                            );
                          }).toList(),
                        )
                      else
                        pw.Text(
                          '暂无语言能力',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 12,
                            color: PdfColors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            pw.SizedBox(width: 20),

            // ---- 右侧栏（65%） ----
            pw.Expanded(
              flex: 65,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    resume.personal.fullName.isNotEmpty
                        ? resume.personal.fullName
                        : '你的名字',
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 26,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 2,
                      color: theme.text,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    resume.personal.jobTitle.isNotEmpty
                        ? resume.personal.jobTitle
                        : '一句话介绍自己',
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 13,
                      color: theme.text.withAlpha(0.6),
                      letterSpacing: 1,
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _buildPdfChip(
                        '意向岗位',
                        resume.personal.jobTitle.isNotEmpty
                            ? resume.personal.jobTitle
                            : '未填写',
                        font,
                      ),
                      _buildPdfChip('意向城市', '北京/上海/深圳', font),
                      _buildPdfChip('薪资要求', '面议', font),
                      _buildPdfChip('入职时间', '随时', font),
                    ],
                  ),
                  pw.SizedBox(height: 16),

                  // 教育背景
                  _buildPdfSectionTitle(
                    '教育背景',
                    font,
                    icon: '●',
                    color: theme.primary,
                  ),
                  pw.SizedBox(height: 4),
                  if (resume.educations.isNotEmpty)
                    ...resume.educations.map(
                      (edu) => pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            '${edu.school} · ${edu.degree}',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            '${edu.startDate.year} - ${edu.endDate?.year ?? '至今'}',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 9,
                              color: theme.text.withAlpha(0.6),
                            ),
                          ),
                          pw.SizedBox(height: 4),
                        ],
                      ),
                    )
                  else
                    pw.Text(
                      '暂无教育背景',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 11,
                        color: PdfColors.grey,
                      ),
                    ),
                  pw.SizedBox(height: 12),

                  // 工作经历
                  _buildPdfSectionTitle(
                    '工作经历',
                    font,
                    icon: '▶',
                    color: theme.primary,
                  ),
                  pw.SizedBox(height: 4),
                  if (resume.workExperiences.isNotEmpty)
                    ...resume.workExperiences.map(
                      (exp) => pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Text(
                                  exp.position,
                                  style: pw.TextStyle(
                                    font: font,
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                              pw.Text(
                                '${exp.startDate.year} - ${exp.endDate?.year ?? '至今'}',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 9,
                                  color: theme.text.withAlpha(0.5),
                                ),
                              ),
                            ],
                          ),
                          pw.Text(
                            exp.company,
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 10,
                              color: theme.text.withAlpha(0.7),
                            ),
                          ),
                          if (exp.description.isNotEmpty) ...[
                            pw.SizedBox(height: 2),
                            ...exp.description.split('\n').map((line) {
                              final trimmed = line.trim();
                              if (trimmed.isEmpty) return pw.SizedBox.shrink();
                              return pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                  left: 6,
                                  bottom: 1,
                                ),
                                child: pw.Text(
                                  '• $trimmed',
                                  style: pw.TextStyle(font: font, fontSize: 9),
                                ),
                              );
                            }),
                          ],
                          pw.SizedBox(height: 6),
                        ],
                      ),
                    )
                  else
                    pw.Text(
                      '暂无工作经历',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 11,
                        color: PdfColors.grey,
                      ),
                    ),
                  pw.SizedBox(height: 12),

                  // 项目经验
                  _buildPdfSectionTitle(
                    '项目经验',
                    font,
                    icon: '▸',
                    color: theme.primary,
                  ),
                  pw.SizedBox(height: 4),
                  if (resume.projects.isNotEmpty)
                    ...resume.projects.map(
                      (proj) => pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            proj.name,
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          if (proj.role.isNotEmpty)
                            pw.Text(
                              '角色: ${proj.role}',
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                                color: theme.text.withAlpha(0.7),
                              ),
                            ),
                          if (proj.description.isNotEmpty) ...[
                            pw.SizedBox(height: 2),
                            ...proj.description.split('\n').map((line) {
                              final trimmed = line.trim();
                              if (trimmed.isEmpty) return pw.SizedBox.shrink();
                              return pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                  left: 6,
                                  bottom: 1,
                                ),
                                child: pw.Text(
                                  '• $trimmed',
                                  style: pw.TextStyle(font: font, fontSize: 9),
                                ),
                              );
                            }),
                          ],
                          pw.SizedBox(height: 6),
                        ],
                      ),
                    )
                  else
                    pw.Text(
                      '暂无项目经验',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 11,
                        color: PdfColors.grey,
                      ),
                    ),
                  pw.SizedBox(height: 12),

                  // 荣誉奖励
                  _buildPdfSectionTitle(
                    '荣誉奖励',
                    font,
                    icon: '★',
                    color: theme.primary,
                  ),
                  pw.SizedBox(height: 4),
                  if (resume.skills.isNotEmpty)
                    pw.Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: resume.skills.map((s) {
                        return pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.grey200,
                            borderRadius: pw.BorderRadius.circular(12),
                          ),
                          child: pw.Text(
                            s.name,
                            style: pw.TextStyle(font: font, fontSize: 9),
                          ),
                        );
                      }).toList(),
                    )
                  else
                    pw.Text(
                      '暂无荣誉奖励',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 11,
                        color: PdfColors.grey,
                      ),
                    ),
                  pw.SizedBox(height: 12),

                  // 自我评价
                  _buildPdfSectionTitle(
                    '自我评价',
                    font,
                    icon: '▪',
                    color: theme.primary,
                  ),
                  pw.SizedBox(height: 4),
                  if (resume.summary.isNotEmpty)
                    pw.Text(
                      resume.summary,
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 10,
                        height: 1.6,
                      ),
                    )
                  else
                    pw.Text(
                      '暂无自我评价',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 11,
                        color: PdfColors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return content;
  }

  // ---- 辅助方法 ----
  static pw.Widget _buildPdfSectionTitle(
    String title,
    pw.Font font, {
    PdfColor? color,
    double fontSize = 18,
    String? icon, // Unicode 符号
  }) {
    final children = <pw.Widget>[];

    if (icon != null) {
      children.add(
        pw.Text(
          icon,
          style: pw.TextStyle(
            font: font,
            fontSize: fontSize,
            color: color ?? PdfColors.black,
          ),
        ),
      );
      children.add(pw.SizedBox(width: 6));
    }

    children.add(
      pw.Text(
        title,
        style: pw.TextStyle(
          font: font,
          fontSize: fontSize,
          fontWeight: pw.FontWeight.bold,
          color: color ?? PdfColors.black,
        ),
      ),
    );

    return pw.Row(children: children);
  }

  static pw.Widget _buildPdfChip(String label, String value, pw.Font font) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey200,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            '$label: ',
            style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              font: font,
              fontSize: 8,
              fontWeight: pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// 配色辅助类
class _ThemeColors {
  final PdfColor primary;
  final PdfColor secondary;
  final PdfColor background;
  final PdfColor text;

  _ThemeColors({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.text,
  });
}
