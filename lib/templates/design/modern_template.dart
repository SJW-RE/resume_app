// lib/templates/design/modern_template.dart
import 'package:flutter/material.dart';
import '../../models/resume.dart';
import '../../models/work_experience.dart';
import '../../models/education.dart';
import '../../models/skill.dart';
import '../../models/project.dart';

class ModernTemplate extends StatelessWidget {
  final Resume resume;
  const ModernTemplate({super.key, required this.resume});

  // ================================================================
  // 样式变量（全部可调参数集中于此，方便统一修改）
  // ================================================================

  // ---- 背景色 ----
  static const Color _leftBgColor = Color(0xFFCCE5FF); // 左侧栏背景色（浅蓝）
  static const Color _rightBgColor = Colors.white; // 右侧栏背景色

  // ---- 文字颜色 ----
  static const Color _leftTextColor = Colors.black; // 左侧栏文字颜色
  static const Color _rightTextColor = Colors.black; // 右侧栏文字颜色

  // ---- 左侧栏标签（Chip）背景色 ----
  static const Color _leftChipBgColor = Color(
    0x80BBDEFB,
  ); // 蓝色半透明（原 Colors.blue.shade200.withOpacity(0.5)）

  // ---- 左侧栏字号 ----
  static const double _leftTitleSize = 16.0; // 左侧模块标题字号
  static const double _leftInfoSize = 12.0; // 左侧基础信息字号
  static const double _leftChipSize = 10.0; // 左侧标签（技能/语言/荣誉）字号
  static const double _leftEmptySize = 10.0; // 占位字号（实际未使用）

  // ---- 右侧栏字号 ----
  static const double _rightTitleSize = 16.0; // 右侧模块标题字号
  static const double _rightNameSize = 26.0; // 姓名字号
  static const double _rightJobTitleSize = 13.0; // 求职意向字号（实际未使用，但保留）
  static const double _rightChipSize = 10.0; // 右侧标签（意向职位/城市）字号
  static const double _rightEduSize = 11.0; // 教育经历字段字号
  static const double _rightWorkSize = 11.0; // 工作经历字段字号
  static const double _rightProjectSize = 11.0; // 项目经验字段字号
  static const double _rightSummarySize = 11.0; // 自我评价字号
  static const double _rightDescSize = 10.0; // 描述列表字号（项目符号及内容）

  // ---- 字重 ----
  static const FontWeight _leftTitleWeight = FontWeight.bold; // 左侧标题字重
  static const FontWeight _leftInfoWeight = FontWeight.normal; // 左侧信息字重
  static const FontWeight _leftChipWeight = FontWeight.normal; // 左侧标签字重

  static const FontWeight _rightTitleWeight = FontWeight.bold; // 右侧标题字重
  static const FontWeight _rightNameWeight = FontWeight.bold; // 姓名字重
  static const FontWeight _rightJobTitleWeight =
      FontWeight.normal; // 求职意向字重（未使用）
  static const FontWeight _rightChipWeight = FontWeight.normal; // 右侧标签字重
  static const FontWeight _rightEduBoldWeight =
      FontWeight.normal; // 教育经历加粗部分（学位/学校）
  static const FontWeight _rightEduNormalWeight =
      FontWeight.normal; // 教育经历普通部分（专业）
  static const FontWeight _rightWorkBoldWeight =
      FontWeight.bold; // 工作经历加粗部分（时间/公司）
  static const FontWeight _rightWorkNormalWeight =
      FontWeight.normal; // 工作经历普通部分（岗位/描述）
  static const FontWeight _rightProjectBoldWeight =
      FontWeight.bold; // 项目经验加粗部分（名称）
  static const FontWeight _rightProjectNormalWeight =
      FontWeight.normal; // 项目经验普通部分（角色/描述）
  static const FontWeight _rightSummaryWeight = FontWeight.normal; // 自我评价字重

  // ---- 间距与内边距 ----
  static const double _sectionSpacing = 10.0; // 模块之间的间距
  static const double _itemSpacing = 8.0; // 条目之间的间距（标题与内容之间）
  static const double _leftPaddingAll = 14.0; // 左侧栏整体内边距
  static const double _rightContentLeftPadding = 16.0; // 右侧栏内容左内边距（与左侧栏间隔）
  static const double _rightPaddingRight = 30.0; // 右侧栏右内边距
  static const double _rightPaddingVertical = 14.0; // 右侧栏上下内边距
  static const double _leftInfoVerticalSpacing = 14.0; // 左侧基础信息行之间的垂直间距
  static const double _leftSectionTitleBottomSpacing = 16.0; // 左侧标题与下方内容间距
  static const double _leftChipWrapSpacing = 6.0; // 左侧标签（Wrap）之间的水平间距
  static const double _leftChipWrapRunSpacing = 6.0; // 左侧标签（Wrap）之间的垂直间距
  static const double _leftChipHorizontalPadding = 10.0; // 左侧标签水平内边距
  static const double _leftChipVerticalPadding = 3.0; // 左侧标签垂直内边距（技能/语言）
  static const double _leftHonorVerticalPadding = 4.0; // 左侧荣誉标签垂直内边距
  static const double _rightChipSpacing = 8.0; // 右侧标签之间的水平间距
  static const double _rightChipRunSpacing = 6.0; // 右侧标签之间的垂直间距
  static const double _rightChipHorizontalPadding = 8.0; // 右侧标签水平内边距
  static const double _rightChipVerticalPadding = 3.0; // 右侧标签垂直内边距
  static const double _rightEduTimeWidth = 90.0; // 教育经历时间列宽度
  static const double _rightEduItemBottomSpacing = 6.0; // 教育经历条目底部间距
  static const double _rightWorkTimeWidth = 90.0; // 工作经历时间列宽度
  static const double _rightWorkItemBottomSpacing = 8.0; // 工作经历条目底部间距
  static const double _rightProjectItemBottomSpacing = 8.0; // 项目经验条目底部间距
  static const double _rightDescLeftPadding = 4.0; // 描述列表左侧内边距
  static const double _rightDescBottomSpacing = 1.0; // 描述行之间的垂直间距
  static const double _rightDescBulletWidth = 12.0; // 描述项目符号宽度
  static const double _sectionDividerWidth = 380.0; // 标题下方分割线宽度
  static const double _sectionDividerHeight = 0.5; // 标题下方分割线高度
  static const double _sectionDividerOpacity = 0.2; // 分割线透明度

  // ---- 其他尺寸 ----
  static const double _avatarRadius = 65.0; // 头像圆半径
  static const double _avatarImageSize = 130.0; // 头像图片尺寸（宽高）
  static const double _avatarFontSize = 28.0; // 头像占位文字字号
  static const double _rightNameLetterSpacing = 2.0; // 姓名间距
  static const double _rightSummaryHeight = 1.6; // 自我评价行高

  // ---- 左侧栏布局 ----
  static const double _leftColumnTopSpacing = 24.0; // 左侧栏顶部空白（头像上方）
  static const double _avatarBottomSpacing = 24.0; // 头像与基础信息之间的间距
  static const double _leftInfoContainerVerticalPadding = 8.0; // 基础信息容器上下内边距
  static const double _leftInfoContainerHorizontalPadding = 8.0; // 基础信息容器左右内边距
  static const double _rightTopPadding = 14.0; // 右侧栏顶部内边距（与左侧栏顶部对齐）

  // ---- 组件内置默认值（用于辅助方法） ----
  static const double _defaultIconSize = 16.0; // 标题图标大小
  static const double _defaultTitleFontSize = 16.0; // 默认标题字号
  static const FontWeight _defaultTitleWeight = FontWeight.bold; // 默认标题字重

  // ================================================================
  // 业务逻辑（以下代码保持不变，仅引用上述常量）
  // ================================================================

  @override
  Widget build(BuildContext context) {
    // ---- 准备左侧基础信息列表（按顺序，空值跳过） ----
    final List<MapEntry<String, String>> leftInfoItems = [];

    // 1. 意向岗位（已注释，保持原样）

    // 2. 出生年月
    if ((resume.personal.birthDate ?? '').isNotEmpty) {
      leftInfoItems.add(MapEntry('出生年月：', resume.personal.birthDate!));
    }

    // 3. 电话
    if (resume.personal.phone.isNotEmpty) {
      leftInfoItems.add(MapEntry('电话：', resume.personal.phone));
    }

    // 4. 邮箱
    if (resume.personal.email.isNotEmpty) {
      leftInfoItems.add(MapEntry('邮箱：', resume.personal.email));
    }

    // 5. 籍贯
    if ((resume.personal.birthPlace ?? '').isNotEmpty) {
      leftInfoItems.add(MapEntry('籍贯：', resume.personal.birthPlace!));
    }

    // 6. 政治面貌
    if ((resume.personal.politicalStatus ?? '').isNotEmpty) {
      leftInfoItems.add(MapEntry('政治面貌：', resume.personal.politicalStatus!));
    }

    // 7. 性别
    if ((resume.personal.gender ?? '').isNotEmpty) {
      leftInfoItems.add(MapEntry('性别：', resume.personal.gender!));
    }

    // 8. 民族
    if ((resume.personal.nation ?? '').isNotEmpty) {
      leftInfoItems.add(MapEntry('民族：', resume.personal.nation!));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Container(
        color: _rightBgColor,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================================================
              // 左侧栏（35%）
              // ============================================================
              Expanded(
                flex: 35,
                child: Container(
                  color: _leftBgColor,
                  padding: const EdgeInsets.all(_leftPaddingAll),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: _leftColumnTopSpacing),
                      // ----- 头像（支持图片） -----
                      CircleAvatar(
                        radius: _avatarRadius,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: resume.personal.avatarImage != null
                            ? ClipOval(
                                child: Image.memory(
                                  resume.personal.avatarImage!,
                                  fit: BoxFit.cover,
                                  width: _avatarImageSize,
                                  height: _avatarImageSize,
                                ),
                              )
                            : Text(
                                resume.personal.fullName.isNotEmpty
                                    ? resume.personal.fullName[0]
                                    : '?',
                                style: const TextStyle(
                                  fontSize: _avatarFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      const SizedBox(height: _avatarBottomSpacing),

                      // ----- 基础信息（动态列表） -----
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: _leftInfoContainerVerticalPadding,
                          horizontal: _leftInfoContainerHorizontalPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: leftInfoItems.asMap().entries.map((entry) {
                            final index = entry.key;
                            final label = entry.value.key;
                            final value = entry.value.value;
                            final isLast = index == leftInfoItems.length - 1;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$label$value',
                                  style: TextStyle(
                                    fontSize: _leftInfoSize,
                                    fontWeight: _leftInfoWeight,
                                    color: _leftTextColor,
                                  ),
                                ),
                                if (!isLast)
                                  const SizedBox(
                                    height: _leftInfoVerticalSpacing,
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: _sectionSpacing),

                      // ----- ★★★ 技能特长（无数据时整个模块隐藏） ★★★ -----
                      if (resume.skills.isNotEmpty) ...[
                        _buildPdfSectionTitle(
                          '技能特长',
                          icon: Icons.build,
                          showDivider: false,
                          textColor: _leftTextColor,
                          iconColor: _leftTextColor,
                          fontSize: _leftTitleSize,
                          fontWeight: _leftTitleWeight,
                        ),
                        const SizedBox(height: _leftSectionTitleBottomSpacing),
                        Wrap(
                          spacing: _leftChipWrapSpacing,
                          runSpacing: _leftChipWrapRunSpacing,
                          children: resume.skills.map((s) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: _leftChipHorizontalPadding,
                                vertical: _leftChipVerticalPadding,
                              ),
                              decoration: BoxDecoration(
                                color: _leftChipBgColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              child: Text(
                                s.name,
                                style: TextStyle(
                                  fontSize: _leftChipSize,
                                  color: _leftTextColor,
                                  fontWeight: _leftChipWeight,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: _sectionSpacing),
                      ],

                      // ----- ★★★ 语言能力（无数据时整个模块隐藏） ★★★ -----
                      if (resume.languages.isNotEmpty) ...[
                        _buildPdfSectionTitle(
                          '语言能力',
                          icon: Icons.language,
                          showDivider: false,
                          textColor: _leftTextColor,
                          iconColor: _leftTextColor,
                          fontSize: _leftTitleSize,
                          fontWeight: _leftTitleWeight,
                        ),
                        const SizedBox(height: _leftSectionTitleBottomSpacing),
                        Wrap(
                          spacing: _leftChipWrapSpacing,
                          runSpacing: _leftChipWrapRunSpacing,
                          children: resume.languages.map((lang) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: _leftChipHorizontalPadding,
                                vertical: _leftChipVerticalPadding,
                              ),
                              decoration: BoxDecoration(
                                color: _leftChipBgColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              child: Text(
                                lang,
                                style: TextStyle(
                                  fontSize: _leftChipSize,
                                  color: _leftTextColor,
                                  fontWeight: _leftChipWeight,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: _sectionSpacing),
                      ],

                      // ----- ★★★ 荣誉奖励（无数据时整个模块隐藏） ★★★ -----
                      if (resume.honors.isNotEmpty) ...[
                        _buildPdfSectionTitle(
                          '荣誉奖励',
                          icon: Icons.emoji_events,
                          showDivider: false,
                          textColor: _leftTextColor,
                          iconColor: _leftTextColor,
                          fontSize: _leftTitleSize,
                          fontWeight: _leftTitleWeight,
                        ),
                        const SizedBox(height: _leftSectionTitleBottomSpacing),
                        Wrap(
                          spacing: _leftChipWrapSpacing,
                          runSpacing: _leftChipWrapRunSpacing,
                          children: resume.honors.map((s) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: _leftChipHorizontalPadding,
                                vertical: _leftHonorVerticalPadding,
                              ),
                              decoration: BoxDecoration(
                                color: _leftChipBgColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              child: Text(
                                s,
                                style: TextStyle(
                                  fontSize: _leftChipSize,
                                  color: _leftTextColor,
                                  fontWeight: _leftChipWeight,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: _sectionSpacing),
                      ],
                    ],
                  ),
                ),
              ),

              // ============================================================
              // 右侧栏（65%）
              // ============================================================
              Expanded(
                flex: 65,
                child: Container(
                  color: _rightBgColor,
                  padding: EdgeInsets.only(
                    left: _rightContentLeftPadding,
                    right: _rightPaddingRight,
                    top: _rightPaddingVertical,
                    bottom: _rightPaddingVertical,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ----- 名字 -----
                      Text(
                        resume.personal.fullName.isNotEmpty
                            ? resume.personal.fullName
                            : '你的名字',
                        style: TextStyle(
                          fontSize: _rightNameSize,
                          fontWeight: _rightNameWeight,
                          color: _rightTextColor,
                          letterSpacing: _rightNameLetterSpacing,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ----- 标签行（始终显示） -----
                      Wrap(
                        spacing: _rightChipSpacing,
                        runSpacing: _rightChipRunSpacing,
                        children: [
                          _buildPdfChip(
                            '意向职位',
                            resume.personal.jobTitle.isNotEmpty
                                ? resume.personal.jobTitle
                                : '未填写',
                            textColor: _rightTextColor,
                            bgColor: Colors.grey.shade200,
                            fontSize: _rightChipSize,
                          ),
                          _buildPdfChip(
                            '意向城市',
                            resume.personal.expectedCity.isNotEmpty
                                ? resume.personal.expectedCity
                                : '未填写',
                            textColor: _rightTextColor,
                            bgColor: Colors.grey.shade200,
                            fontSize: _rightChipSize,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // ----- ★★★ 教育背景（无数据时整个模块隐藏） ★★★ -----
                      if (resume.educations.isNotEmpty) ...[
                        _buildPdfSectionTitle(
                          '教育背景',
                          icon: Icons.school,
                          textColor: _rightTextColor,
                          iconColor: _rightTextColor,
                          fontSize: _rightTitleSize,
                          fontWeight: _rightTitleWeight,
                        ),
                        const SizedBox(height: _itemSpacing),
                        ...resume.educations.map(
                          (edu) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: _rightEduItemBottomSpacing,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: _rightEduTimeWidth,
                                  child: Text(
                                    '${edu.startDate.year}.${edu.startDate.month.toString().padLeft(2, '0')} - ${edu.endDate?.year ?? '至今'}',
                                    style: TextStyle(
                                      fontSize: _rightEduSize,
                                      color: _rightTextColor.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    edu.degree,
                                    style: TextStyle(
                                      fontSize: _rightEduSize,
                                      fontWeight: _rightEduBoldWeight,
                                      color: _rightTextColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    edu.school,
                                    style: TextStyle(
                                      fontSize: _rightEduSize,
                                      fontWeight: _rightEduBoldWeight,
                                      color: _rightTextColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    edu.major,
                                    style: TextStyle(
                                      fontSize: _rightEduSize,
                                      color: _rightTextColor,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: _sectionSpacing),
                      ],

                      // ----- ★★★ 工作经历（无数据时整个模块隐藏） ★★★ -----
                      if (resume.workExperiences.isNotEmpty) ...[
                        _buildPdfSectionTitle(
                          '工作经历',
                          icon: Icons.work,
                          textColor: _rightTextColor,
                          iconColor: _rightTextColor,
                          fontSize: _rightTitleSize,
                          fontWeight: _rightTitleWeight,
                        ),
                        const SizedBox(height: _itemSpacing),
                        ...resume.workExperiences.map(
                          (exp) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: _rightWorkItemBottomSpacing,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: _rightWorkTimeWidth,
                                      child: Text(
                                        '${exp.startDate.year} - ${exp.endDate?.year ?? '至今'}',
                                        style: TextStyle(
                                          fontSize: _rightWorkSize,
                                          fontWeight: _rightWorkBoldWeight,
                                          color: _rightTextColor,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        exp.company,
                                        style: TextStyle(
                                          fontSize: _rightWorkSize,
                                          fontWeight: _rightWorkBoldWeight,
                                          color: _rightTextColor.withOpacity(
                                            0.7,
                                          ),
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '岗位: ${exp.position}',
                                  style: TextStyle(
                                    fontSize: _rightWorkSize,
                                    color: _rightTextColor,
                                  ),
                                ),
                                if (exp.description.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  ...exp.description
                                      .split('\n')
                                      .where((line) => line.trim().isNotEmpty)
                                      .map((line) {
                                        String cleaned = line.trim();
                                        if (cleaned.startsWith('-') ||
                                            cleaned.startsWith('•') ||
                                            cleaned.startsWith('*')) {
                                          cleaned = cleaned.substring(1).trim();
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            left: _rightDescLeftPadding,
                                            bottom: _rightDescBottomSpacing,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: _rightDescBulletWidth,
                                                child: Text(
                                                  '▪',
                                                  style: TextStyle(
                                                    fontSize: _rightDescSize,
                                                    color: _rightTextColor,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  cleaned,
                                                  style: TextStyle(
                                                    fontSize: _rightDescSize,
                                                    color: _rightTextColor,
                                                  ),
                                                  softWrap: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: _sectionSpacing),
                      ],

                      // ----- ★★★ 项目经验（无数据时整个模块隐藏） ★★★ -----
                      if (resume.projects.isNotEmpty) ...[
                        _buildPdfSectionTitle(
                          '项目经验',
                          icon: Icons.folder_open,
                          textColor: _rightTextColor,
                          iconColor: _rightTextColor,
                          fontSize: _rightTitleSize,
                          fontWeight: _rightTitleWeight,
                        ),
                        const SizedBox(height: _itemSpacing),
                        ...resume.projects.map(
                          (proj) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: _rightProjectItemBottomSpacing,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  proj.name,
                                  style: TextStyle(
                                    fontSize: _rightProjectSize,
                                    fontWeight: _rightProjectBoldWeight,
                                    color: _rightTextColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (proj.role.isNotEmpty)
                                  Text(
                                    '角色: ${proj.role}',
                                    style: TextStyle(
                                      fontSize: _rightProjectSize,
                                      color: _rightTextColor.withOpacity(0.7),
                                    ),
                                  ),
                                if (proj.description.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  ...proj.description
                                      .split('\n')
                                      .where((line) => line.trim().isNotEmpty)
                                      .map((line) {
                                        String cleaned = line.trim();
                                        if (cleaned.startsWith('-') ||
                                            cleaned.startsWith('•') ||
                                            cleaned.startsWith('*')) {
                                          cleaned = cleaned.substring(1).trim();
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            left: _rightDescLeftPadding,
                                            bottom: _rightDescBottomSpacing,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: _rightDescBulletWidth,
                                                child: Text(
                                                  '▪',
                                                  style: TextStyle(
                                                    fontSize: _rightDescSize,
                                                    color: _rightTextColor,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  cleaned,
                                                  style: TextStyle(
                                                    fontSize: _rightDescSize,
                                                    color: _rightTextColor,
                                                  ),
                                                  softWrap: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: _sectionSpacing),
                      ],

                      // ----- ★★★ 自我评价（无数据时整个模块隐藏） ★★★ -----
                      if (resume.summary.isNotEmpty) ...[
                        _buildPdfSectionTitle(
                          '自我评价',
                          icon: Icons.person,
                          textColor: _rightTextColor,
                          iconColor: _rightTextColor,
                          fontSize: _rightTitleSize,
                          fontWeight: _rightTitleWeight,
                        ),
                        const SizedBox(height: _itemSpacing),
                        // ★ 修改：添加首行缩进两个全角空格
                        Text(
                          '\u3000\u3000${resume.summary}',
                          style: TextStyle(
                            fontSize: _rightSummarySize,
                            height: _rightSummaryHeight,
                            color: _rightTextColor,
                          ),
                        ),
                        // 最后一项不需要底部间距
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- 标题组件（使用常量，参数保留以支持定制） ----
  Widget _buildPdfSectionTitle(
    String title, {
    IconData? icon,
    bool showDivider = true,
    Color? textColor,
    Color? iconColor,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    final defaultColor = textColor ?? Colors.black;
    final defaultIconColor = iconColor ?? defaultColor;
    final defaultSize = fontSize ?? _defaultTitleFontSize;
    final defaultWeight = fontWeight ?? _defaultTitleWeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: _defaultIconSize, color: defaultIconColor),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: defaultSize,
                fontWeight: defaultWeight,
                color: defaultColor,
              ),
            ),
          ],
        ),
        if (showDivider) ...[
          const SizedBox(height: 2),
          Container(
            width: _sectionDividerWidth,
            height: _sectionDividerHeight,
            color: defaultColor.withOpacity(_sectionDividerOpacity),
          ),
        ],
      ],
    );
  }

  // ---- 标签组件（使用常量） ----
  Widget _buildPdfChip(
    String label,
    String value, {
    Color? textColor,
    Color? bgColor,
    double? fontSize,
  }) {
    final foreground = textColor ?? Colors.black;
    final background = bgColor ?? Colors.grey.shade200;
    final size = fontSize ?? 9.0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _rightChipHorizontalPadding,
        vertical: _rightChipVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: size, color: foreground),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.normal,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
