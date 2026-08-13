// lib/services/ats_pdf_exporter.dart
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import '../models/resume.dart';

// ================================================================
// ATS 模板配置类
// ================================================================
class AtsPdfConfig {
  // ---- 字号 ----
  final double nameFontSize; // 姓名
  final double titleFontSize; // 求职意向
  final double contactFontSize; // 联系方式
  final double sectionTitleFontSize; // 各章节标题
  final double entryTitleFontSize; // 条目标题（学校/公司/项目名）
  final double entrySubFontSize; // 条目副标题（时间/角色）
  final double normalFontSize; // 正文/描述
  final double listSymbolFontSize; // 列表符号
  final double tagFontSize; // 技能/荣誉标签
  final double summaryFontSize; // 自我评价

  // ---- 间距 ----
  final double spacingSmall;
  final double spacingMedium;
  final double spacingLarge;
  final double spacingSection;

  // ---- 内边距 ----
  final double paddingLeft;
  final double paddingBottom;

  const AtsPdfConfig({
    required this.nameFontSize,
    required this.titleFontSize,
    required this.contactFontSize,
    required this.sectionTitleFontSize,
    required this.entryTitleFontSize,
    required this.entrySubFontSize,
    required this.normalFontSize,
    required this.listSymbolFontSize,
    required this.tagFontSize,
    required this.summaryFontSize,
    required this.spacingSmall,
    required this.spacingMedium,
    required this.spacingLarge,
    required this.spacingSection,
    required this.paddingLeft,
    required this.paddingBottom,
  });

  // ---- 默认配置 ----
  factory AtsPdfConfig.defaultConfig() {
    return AtsPdfConfig(
      nameFontSize: 22,
      titleFontSize: 13,
      contactFontSize: 10,
      sectionTitleFontSize: 15,
      entryTitleFontSize: 12,
      entrySubFontSize: 10,
      normalFontSize: 10,
      listSymbolFontSize: 10.5,
      tagFontSize: 10,
      summaryFontSize: 10,
      spacingSmall: 2,
      spacingMedium: 4,
      spacingLarge: 6,
      spacingSection: 8,
      paddingLeft: 6,
      paddingBottom: 2,
    );
  }

  // ---- 缩放方法 ----
  AtsPdfConfig scaled(double factor) {
    return AtsPdfConfig(
      nameFontSize: nameFontSize * factor,
      titleFontSize: titleFontSize * factor,
      contactFontSize: contactFontSize * factor,
      sectionTitleFontSize: sectionTitleFontSize * factor,
      entryTitleFontSize: entryTitleFontSize * factor,
      entrySubFontSize: entrySubFontSize * factor,
      normalFontSize: normalFontSize * factor,
      listSymbolFontSize: listSymbolFontSize * factor,
      tagFontSize: tagFontSize * factor,
      summaryFontSize: summaryFontSize * factor,
      spacingSmall: spacingSmall * factor,
      spacingMedium: spacingMedium * factor,
      spacingLarge: spacingLarge * factor,
      spacingSection: spacingSection * factor,
      paddingLeft: paddingLeft * factor,
      paddingBottom: paddingBottom * factor,
    );
  }
}

// ================================================================
// ATS PDF 导出器
// ================================================================
class AtsPdfExporter {
  // ---- 自动计算缩放因子 ----
  static double _calculateScaleFactor(Resume resume) {
    int count = 0;
    if (resume.educations.isNotEmpty) count += resume.educations.length;
    if (resume.workExperiences.isNotEmpty)
      count += resume.workExperiences.length;
    if (resume.projects.isNotEmpty) count += resume.projects.length;
    if (resume.skills.isNotEmpty) count += 1;
    if (resume.honors.isNotEmpty) count += 1;
    if (resume.languages.isNotEmpty) count += 1;
    if (resume.summary.isNotEmpty) count += 1;

    if (count <= 3) return 1.5;
    if (count <= 6) return 1.2;
    if (count < 9) return 1.1;
    if (count <= 9) return 1.0;
    if (count <= 10) return 0.92;
    if (count <= 12) return 0.85;
    return 0.75;
  }

  // ---- 生成 PDF（支持缩放） ----
  static Future<Uint8List> generateatsPdf(
    Resume resume, {
    double? userScale,
  }) async {
    final pdf = pw.Document();

    // 加载中文字体
    final fontData = await rootBundle.load(
      'assets/fonts/SourceHanSansCN-Regular.ttf',
    );
    final font = pw.Font.ttf(fontData.buffer.asByteData());

    // 确定缩放因子
    double scaleFactor;
    if (userScale != null) {
      scaleFactor = userScale.clamp(0.5, 1.8);
    } else {
      scaleFactor = _calculateScaleFactor(resume);
    }
    print('🔄 ATS 模板使用缩放因子: $scaleFactor');

    // 创建缩放后的配置
    final config = AtsPdfConfig.defaultConfig().scaled(scaleFactor);

    // 构建内容
    final content = _buildContent(resume, font, config);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        build: (context) => content,
      ),
    );

    return await pdf.save();
  }

  // ---- 构建内容（使用配置） ----
  static List<pw.Widget> _buildContent(
    Resume resume,
    pw.Font font,
    AtsPdfConfig config,
  ) {
    final List<pw.Widget> content = [];

    // ---- 个人信息 ----
    content.add(
      pw.Text(
        resume.personal.fullName.isNotEmpty
            ? resume.personal.fullName
            : '未填写姓名',
        style: pw.TextStyle(
          font: font,
          fontSize: config.nameFontSize,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
    content.add(pw.SizedBox(height: config.spacingSmall));
    content.add(
      pw.Text(
        resume.personal.jobTitle.isNotEmpty
            ? resume.personal.jobTitle
            : '未填写求职意向',
        style: pw.TextStyle(
          font: font,
          fontSize: config.titleFontSize,
          color: PdfColors.grey,
        ),
      ),
    );
    content.add(pw.SizedBox(height: config.spacingMedium * 1.5));

    // 联系方式
    final contacts = <pw.Widget>[];
    if (resume.personal.phone.isNotEmpty) {
      contacts.add(
        pw.Text(
          '电话：${resume.personal.phone}',
          style: pw.TextStyle(font: font, fontSize: config.contactFontSize),
        ),
      );
    } else {
      contacts.add(
        pw.Text(
          '电话：未填写',
          style: pw.TextStyle(
            font: font,
            fontSize: config.contactFontSize,
            color: PdfColors.grey,
          ),
        ),
      );
    }
    if (resume.personal.email.isNotEmpty) {
      contacts.add(
        pw.Text(
          '邮箱：${resume.personal.email}',
          style: pw.TextStyle(font: font, fontSize: config.contactFontSize),
        ),
      );
    } else {
      contacts.add(
        pw.Text(
          '邮箱：未填写',
          style: pw.TextStyle(
            font: font,
            fontSize: config.contactFontSize,
            color: PdfColors.grey,
          ),
        ),
      );
    }
    content.add(pw.Wrap(spacing: 12, children: contacts));
    content.add(pw.Divider(thickness: 0.5));
    content.add(pw.SizedBox(height: config.spacingMedium));

    // ---- 教育经历 ----
    if (resume.educations.isNotEmpty) {
      content.add(
        pw.Text(
          '教育经历',
          style: pw.TextStyle(
            font: font,
            fontSize: config.sectionTitleFontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );
      content.add(pw.SizedBox(height: config.spacingMedium));

      for (final edu in resume.educations) {
        final eduChildren = <pw.Widget>[];
        eduChildren.add(
          pw.Row(
            children: [
              pw.Text(
                '${edu.startDate.year} - ${edu.endDate?.year ?? '至今'}',
                style: pw.TextStyle(
                  font: font,
                  fontSize: config.entrySubFontSize,
                  color: PdfColors.grey,
                ),
              ),
              pw.SizedBox(width: 4),
              pw.Text(
                '${edu.school}  ${edu.degree}',
                style: pw.TextStyle(
                  font: font,
                  fontSize: config.entryTitleFontSize,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        );
        if (edu.description.isNotEmpty) {
          eduChildren.add(pw.SizedBox(height: config.spacingSmall));
          final lines = edu.description.split('\n');
          for (final line in lines) {
            final trimmed = line.trim();
            if (trimmed.isNotEmpty) {
              eduChildren.add(
                pw.Padding(
                  padding: pw.EdgeInsets.only(
                    left: config.paddingLeft,
                    bottom: config.spacingSmall,
                  ),
                  child: pw.Text(
                    '- $trimmed',
                    style: pw.TextStyle(
                      font: font,
                      fontSize: config.normalFontSize,
                    ),
                  ),
                ),
              );
            }
          }
        }
        eduChildren.add(pw.SizedBox(height: config.spacingLarge));
        content.add(
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: eduChildren,
          ),
        );
      }
      content.add(pw.SizedBox(height: config.spacingSmall));
    }

    // ---- 工作经历 ----
    if (resume.workExperiences.isNotEmpty) {
      content.add(
        pw.Text(
          '工作经历',
          style: pw.TextStyle(
            font: font,
            fontSize: config.sectionTitleFontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );
      content.add(pw.SizedBox(height: config.spacingMedium));

      for (final exp in resume.workExperiences) {
        final expChildren = <pw.Widget>[];
        expChildren.add(
          pw.Text(
            '${exp.position} @ ${exp.company}',
            style: pw.TextStyle(
              font: font,
              fontSize: config.entryTitleFontSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        );
        expChildren.add(
          pw.Text(
            '${exp.startDate.year} - ${exp.endDate?.year ?? '至今'}',
            style: pw.TextStyle(
              font: font,
              fontSize: config.entrySubFontSize,
              color: PdfColors.grey,
            ),
          ),
        );
        if (exp.description.isNotEmpty) {
          final lines = exp.description.split('\n');
          bool hasContent = false;
          for (final line in lines) {
            final trimmed = line.trim();
            if (trimmed.isEmpty) continue;
            String contentText = trimmed;
            if (contentText.startsWith('-') ||
                contentText.startsWith('•') ||
                contentText.startsWith('*')) {
              contentText = contentText.substring(1).trim();
            }
            expChildren.add(
              pw.Padding(
                padding: pw.EdgeInsets.only(
                  left: config.paddingLeft,
                  bottom: config.spacingSmall,
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      width: 12,
                      child: pw.Text(
                        '-',
                        style: pw.TextStyle(
                          font: font,
                          fontSize: config.listSymbolFontSize,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        contentText,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: config.normalFontSize,
                          height: 1.2,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
            );
            hasContent = true;
          }
          if (hasContent) {
            expChildren.add(pw.SizedBox(height: config.spacingSmall));
          }
        }
        expChildren.add(pw.SizedBox(height: config.spacingMedium));
        content.add(
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: expChildren,
          ),
        );
      }
      content.add(pw.SizedBox(height: config.spacingMedium));
    }

    // ---- 项目经验 ----
    if (resume.projects.isNotEmpty) {
      content.add(
        pw.Text(
          '项目经验',
          style: pw.TextStyle(
            font: font,
            fontSize: config.sectionTitleFontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );
      content.add(pw.SizedBox(height: config.spacingMedium));

      for (final proj in resume.projects) {
        final projChildren = <pw.Widget>[];
        projChildren.add(
          pw.Text(
            proj.name,
            style: pw.TextStyle(
              font: font,
              fontSize: config.entryTitleFontSize,
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
                fontSize: config.entrySubFontSize,
                color: PdfColors.grey,
              ),
            ),
          );
        }
        if (proj.description.isNotEmpty) {
          final lines = proj.description.split('\n');
          bool hasContent = false;
          for (final line in lines) {
            final trimmed = line.trim();
            if (trimmed.isEmpty) continue;
            String contentText = trimmed;
            if (contentText.startsWith('-') ||
                contentText.startsWith('•') ||
                contentText.startsWith('*')) {
              contentText = contentText.substring(1).trim();
            }
            projChildren.add(
              pw.Padding(
                padding: pw.EdgeInsets.only(
                  left: config.paddingLeft,
                  bottom: config.spacingSmall,
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      width: 12,
                      child: pw.Text(
                        '-',
                        style: pw.TextStyle(
                          font: font,
                          fontSize: config.listSymbolFontSize,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        contentText,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: config.normalFontSize,
                          height: 1.2,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
            );
            hasContent = true;
          }
          if (hasContent) {
            projChildren.add(pw.SizedBox(height: config.spacingSmall));
          }
        }
        projChildren.add(pw.SizedBox(height: config.spacingMedium));
        content.add(
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: projChildren,
          ),
        );
      }
      content.add(pw.SizedBox(height: config.spacingMedium));
    }

    // ---- 技能 ----
    if (resume.skills.isNotEmpty) {
      content.add(
        pw.Text(
          '技能',
          style: pw.TextStyle(
            font: font,
            fontSize: config.sectionTitleFontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );
      content.add(pw.SizedBox(height: config.spacingMedium));
      content.add(
        pw.Wrap(
          spacing: 4,
          runSpacing: 4,
          children: resume.skills
              .map(
                (s) => pw.Text(
                  s.name,
                  style: pw.TextStyle(font: font, fontSize: config.tagFontSize),
                ),
              )
              .toList(),
        ),
      );
      content.add(pw.SizedBox(height: config.spacingMedium));
    }

    // ---- 语言能力 ----
    if (resume.languages.isNotEmpty) {
      content.add(
        pw.Text(
          '语言能力',
          style: pw.TextStyle(
            font: font,
            fontSize: config.sectionTitleFontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );
      content.add(pw.SizedBox(height: config.spacingMedium));
      content.add(
        pw.Text(
          resume.languages.join('、'),
          style: pw.TextStyle(font: font, fontSize: config.entryTitleFontSize),
        ),
      );
      content.add(pw.SizedBox(height: config.spacingMedium));
    }

    // ---- 荣誉奖励 ----
    if (resume.honors.isNotEmpty) {
      content.add(
        pw.Text(
          '荣誉奖励',
          style: pw.TextStyle(
            font: font,
            fontSize: config.sectionTitleFontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );
      content.add(pw.SizedBox(height: config.spacingMedium));
      content.add(
        pw.Wrap(
          spacing: 4,
          runSpacing: 4,
          children: resume.honors
              .map(
                (h) => pw.Text(
                  h,
                  style: pw.TextStyle(font: font, fontSize: config.tagFontSize),
                ),
              )
              .toList(),
        ),
      );
      content.add(pw.SizedBox(height: config.spacingMedium));
    }

    // ---- 个人总结 ----
    if (resume.summary.isNotEmpty) {
      content.add(
        pw.Text(
          '个人总结',
          style: pw.TextStyle(
            font: font,
            fontSize: config.sectionTitleFontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );
      content.add(pw.SizedBox(height: config.spacingMedium));
      content.add(
        pw.Text(
          resume.summary,
          style: pw.TextStyle(
            font: font,
            fontSize: config.summaryFontSize,
            height: 1.5,
          ),
        ),
      );
    }

    return content;
  }
}
