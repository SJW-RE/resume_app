import 'package:flutter/material.dart';
import '../../models/resume.dart';
import '../../models/work_experience.dart';
import '../../models/education.dart';
import '../../models/skill.dart';
import '../../models/project.dart';

class CreativeTemplate extends StatelessWidget {
  final Resume resume;
  const CreativeTemplate({required this.resume});

  // ============================================================
  // 标题装饰尺寸配置（原有，保留）
  // ============================================================

  static const double titleHeight = 24.0; // 标题栏高度
  static const double titlePaddingHorizontal = 10.0; // 标题文字左右内边距
  static const double titleLineLength = 600.0; // 标题下方横线长度
  static const double rightTriangleHorizontal = 24.0; // 右侧直角三角形宽度
  static const double rightTriangleVertical = 24.0; // 右侧直角三角形高度
  static const double leftTriangleHorizontal = 20.0; // 左侧左下角三角形宽度
  static const double leftTriangleVertical = 16.0; // 左侧左下角三角形高度

  /// 贯穿竖线宽度（可调）
  static const double verticalLineWidth = 1; // 竖线宽度

  /// ★ 竖线起始位置垂直偏移（正值向下，负值向上），默认0对齐直角点
  static const double verticalLineStartOffset = 0.0;

  /// ★ 竖线水平偏移（正值向右，负值向左），用于微调对齐
  static const double verticalLineLeftOffset = 30.0;

  static const double contentLeftPadding = 30.0; // 章节内容区域左侧缩进
  static const double contentVerticalPadding = 24.0; // 内容区域上下内边距
  static const Color titleBgColor = Color(0xFF42A5F5); // 标题背景色（未使用，但保留）
  static const double strokeWidth = 1.0; // 标题边框/三角形描边宽度

  // ============================================================
  // 头部配置（原有，保留）
  // ============================================================

  static const double headerInfoLeftPadding = 60.0; // 姓名/信息左内边距（右移距离）
  static const double avatarRadius = 65.0; // 头像半径
  static const double headerSpacing = 16.0; // 头像与文字间距
  static const Color headerBgColor = Color.fromARGB(255, 6, 40, 68); // 头部背景色
  static const double headerColumnsSpacing = 25.0; // 基础信息两列之间的间距

  // ============================================================
  // 工作经历 / 项目经验 布局细节（原有）
  // ============================================================

  static const double workPositionSpacing = 40.0; // 工作经历：公司与职位间距
  static const double projectRoleSpacing = 40.0; // 项目经验：项目名与角色间距

  // ============================================================
  // ★ 新增：所有可变参数（颜色、字号、间距、尺寸等）
  // ============================================================

  // ---- 颜色 ----
  static const Color _primaryColor = Color(0xFF1A237E); // 主色（深蓝）
  static const Color _accentColor = Color(0xFFFFD54F); // 强调色（金色）
  static const Color _textColor = Colors.black; // 通用文字颜色（黑色）
  static const Color _whiteColor = Colors.white; // 白色

  // ---- 透明度 ----
  static const double _primaryOpacityLight = 0.1; // 主色极浅透明度（头像背景）
  static const double _primaryOpacity = 0.2; // 主色半透明（标签背景）
  static const double _accentOpacity = 0.3; // 强调色半透明（标签边框）

  // ---- 容器装饰 ----
  static const double _containerRadius = 12.0; // 整体容器圆角
  static const double _shadowBlurRadius = 12.0; // 阴影模糊半径
  static const double _shadowOffsetY = 4.0; // 阴影垂直偏移

  // ---- 头部内边距与间距 ----
  static const double _headerPaddingVertical = 16.0; // 头部上下内边距
  static const double _headerPaddingHorizontal = 30.0; // 头部左右内边距
  static const double _headerNameInfoSpacing = 10.0; // 头部姓名与信息之间的间距
  static const double _headerInfoRowSpacing = 4.0; // 头部信息行之间的间距

  // ---- 头像相关 ----
  static const double _avatarInnerRadius = 62.0; // 内层头像半径（avatarRadius - 3）
  static const double _avatarImageSize = 124.0; // 头像图片尺寸（内层半径×2）
  static const double _avatarTextFontSize = 38.0; // 头像占位文字字号

  // ---- 通用字号 ----
  static const double _smallTextSize = 12.0; // 小字号（描述、标签值等）
  static const double _mediumTextSize = 13.0; // 中字号（工作/项目名称等）
  static const double _largeTextSize = 14.0; // 大字号（标签标签、头部信息）
  static const double _xlargeTextSize = 16.0; // 特大字号（章节标题）
  static const double _nameTextSize = 26.0; // 姓名字号
  static const double _avatarInitialSize = 38.0; // 头像占位字符字号（与上面相同）

  // ---- 字重 ----
  static const FontWeight _boldWeight = FontWeight.bold; // 加粗
  static const FontWeight _mediumWeight = FontWeight.w500; // 中等（用于意向标签值）
  static const FontWeight _normalWeight = FontWeight.normal; // 常规

  // ---- 间距与尺寸 ----
  static const double _spacingTiny = 2.0; // 极小间距
  static const double _spacingSmall = 4.0; // 小间距
  static const double _spacingMedium = 8.0; // 中间距
  static const double _spacingLarge = 12.0; // 大间距
  static const double _spacingXLarge = 16.0; // 加大间距
  static const double _spacingXXLarge = 40.0; // 特大间距（用于Wrap等）

  static const double _timeWidth = 100.0; // 教育/工作经历时间列宽度
  static const double _itemBottomSpacing = 8.0; // 教育条目底部间距（与工作共用）
  static const double _workItemBottomSpacing = 8.0; // 工作经历条目底部间距（覆盖）
  static const double _projectItemBottomSpacing = 8.0; // 项目经验条目底部间距
  static const double _descLeftPadding = 4.0; // 描述列表左侧内边距
  static const double _descBulletWidth = 14.0; // 描述列表项目符号宽度
  static const double _descBottomSpacing = 2.0; // 描述行之间的垂直间距

  // ---- 标签（荣誉/技能） ----
  static const double _tagHorizontalPadding = 12.0; // 标签水平内边距
  static const double _tagVerticalPadding = 4.0; // 标签垂直内边距
  static const double _tagSpacing = 8.0; // 标签之间的水平间距
  static const double _tagRunSpacing = 8.0; // 标签之间的垂直间距
  static const double _tagRadius = 16.0; // 标签圆角半径

  // ---- 意向标签（求职意向） ----
  static const double _intentWrapSpacing = 40.0; // 意向标签Wrap的水平间距（已弃用，保留）
  static const double _intentWrapRunSpacing = 6.0; // 意向标签Wrap的垂直间距（已弃用，保留）

  // ---- 标题装饰 ----
  static const double _titleBottomLineHeight = 1.0; // 标题底部横线高度
  static const double _titleLetterSpacing = 1.5; // 标题文字间距

  // ---- 章节内容 ----
  static const double _sectionTitleBottomSpacing = 12.0; // 标题与内容之间的间距

  // ---- 其他 ----
  static const double _headerInfoFontSize = _largeTextSize; // 头部信息字号（14）
  static const double _chipLabelFontSize = _largeTextSize; // 意向标签标签字号（已弃用，保留）
  static const double _chipValueFontSize = _smallTextSize; // 意向标签值字号（已弃用，保留）

  // ============================================================
  // 业务逻辑（以下代码保持不变，仅引用上述常量）
  // ============================================================

  @override
  Widget build(BuildContext context) {
    // ---- 计算最高学历 ----
    String highestDegree = '未填写';
    if (resume.educations.isNotEmpty) {
      final sorted = List<Education>.from(resume.educations)
        ..sort((a, b) => b.startDate.compareTo(a.startDate));
      highestDegree = sorted.first.degree;
    }

    // ---- 准备所有需要显示的信息条目（按固定顺序，仅非空） ----
    final List<MapEntry<String, String>> infoItems = [];

    // 1. 出生年月
    if ((resume.personal.birthDate ?? '').isNotEmpty) {
      infoItems.add(MapEntry('出生年月：', resume.personal.birthDate!));
    }

    // 2. 电话
    if (resume.personal.phone.isNotEmpty) {
      infoItems.add(MapEntry('电话：', resume.personal.phone));
    }

    // 3. 邮箱
    if (resume.personal.email.isNotEmpty) {
      infoItems.add(MapEntry('邮箱：', resume.personal.email));
    }

    // 4. 最高学历（始终显示，即使"未填写"）
    infoItems.add(MapEntry('最高学历：', highestDegree));

    // 5. 籍贯
    if ((resume.personal.birthPlace ?? '').isNotEmpty) {
      infoItems.add(MapEntry('籍贯：', resume.personal.birthPlace!));
    }

    // 6. 政治面貌
    if ((resume.personal.politicalStatus ?? '').isNotEmpty) {
      infoItems.add(MapEntry('政治面貌：', resume.personal.politicalStatus!));
    }

    // 7. 性别
    if ((resume.personal.gender ?? '').isNotEmpty) {
      infoItems.add(MapEntry('性别：', resume.personal.gender!));
    }

    // 8. 民族
    if ((resume.personal.nation ?? '').isNotEmpty) {
      infoItems.add(MapEntry('民族：', resume.personal.nation!));
    }

    // ---- 构建基础信息行（每行最多两个条目，左右排列） ----
    List<Widget> infoRows = [];
    for (int i = 0; i < infoItems.length; i += 2) {
      final leftItem = infoItems[i];
      final rightItem = (i + 1 < infoItems.length) ? infoItems[i + 1] : null;

      final rowChildren = <Widget>[
        Expanded(child: _buildInfoTextWhite(leftItem.key, leftItem.value)),
      ];

      if (rightItem != null) {
        rowChildren.addAll([
          SizedBox(width: headerColumnsSpacing),
          Expanded(child: _buildInfoTextWhite(rightItem.key, rightItem.value)),
        ]);
      }

      infoRows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rowChildren,
        ),
      );
      // 行间间距（除最后一行外）
      if (i + 2 < infoItems.length) {
        infoRows.add(SizedBox(height: _headerInfoRowSpacing));
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          color: _whiteColor,
          borderRadius: BorderRadius.circular(_containerRadius),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: _shadowBlurRadius,
              offset: Offset(0, _shadowOffsetY),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- 头部 ----
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: _headerPaddingVertical,
                horizontal: _headerPaddingHorizontal,
              ),
              decoration: const BoxDecoration(
                color: headerBgColor,
                borderRadius: BorderRadius.zero,
              ),
              child: Row(
                children: [
                  // ★★★ 头像（支持图片） ★★★
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: _primaryColor.withOpacity(
                      _primaryOpacityLight,
                    ),
                    child: CircleAvatar(
                      radius: _avatarInnerRadius,
                      backgroundColor: _accentColor,
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
                              style: TextStyle(
                                fontSize: _avatarTextFontSize,
                                fontWeight: _boldWeight,
                                color: _primaryColor,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: headerSpacing),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: headerInfoLeftPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ----- 姓名 -----
                          Text(
                            resume.personal.fullName.isNotEmpty
                                ? resume.personal.fullName
                                : '你的名字',
                            style: TextStyle(
                              fontSize: _nameTextSize,
                              fontWeight: _boldWeight,
                              color: _whiteColor,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: _headerNameInfoSpacing),

                          // ----- 基础信息（左右两列动态填充） -----
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: infoRows,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ============================================================
            // 内容区域 + 贯穿竖线
            // ============================================================
            Stack(
              children: [
                // ---- 内容（所有章节） ----
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _headerPaddingHorizontal, // 与头部左右内边距一致
                    vertical: contentVerticalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ----- 求职意向（始终显示） -----
                      _buildSectionTitleWithTag('求职意向'),
                      SizedBox(height: _sectionTitleBottomSpacing),
                      Padding(
                        padding: EdgeInsets.only(left: contentLeftPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 按顺序：意向岗位、意向城市、期望薪资、入职时间
                            if (resume.personal.jobTitle.isNotEmpty)
                              Text(
                                '意向岗位：${resume.personal.jobTitle}',
                                style: TextStyle(
                                  fontSize: _smallTextSize,
                                  color: _textColor,
                                ),
                              ),
                            if (resume.personal.expectedCity.isNotEmpty)
                              Text(
                                '意向城市：${resume.personal.expectedCity}',
                                style: TextStyle(
                                  fontSize: _smallTextSize,
                                  color: _textColor,
                                ),
                              ),
                            if (resume.personal.salaryExpectation.isNotEmpty)
                              Text(
                                '期望薪资：${resume.personal.salaryExpectation}',
                                style: TextStyle(
                                  fontSize: _smallTextSize,
                                  color: _textColor,
                                ),
                              ),
                            if (resume.personal.availableDate.isNotEmpty)
                              Text(
                                '入职时间：${resume.personal.availableDate}',
                                style: TextStyle(
                                  fontSize: _smallTextSize,
                                  color: _textColor,
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: _spacingLarge),

                      // ----- ★★★ 教育背景（无数据时整个模块隐藏） ★★★ -----
                      if (resume.educations.isNotEmpty) ...[
                        _buildSectionTitleWithTag('教育背景'),
                        SizedBox(height: _sectionTitleBottomSpacing),
                        Padding(
                          padding: EdgeInsets.only(left: contentLeftPadding),
                          child: Column(
                            children: resume.educations
                                .map(
                                  (edu) => Padding(
                                    padding: EdgeInsets.only(
                                      bottom: _itemBottomSpacing,
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: _timeWidth,
                                          child: Text(
                                            '${edu.startDate.year}.${edu.startDate.month.toString().padLeft(2, '0')} - ${edu.endDate?.year ?? '至今'}',
                                            style: TextStyle(
                                              fontSize: _smallTextSize,
                                              color: _textColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: _spacingMedium),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            edu.degree,
                                            style: TextStyle(
                                              fontSize: _smallTextSize,
                                              color: _textColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            edu.school,
                                            style: TextStyle(
                                              fontSize: _smallTextSize,
                                              color: _textColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            edu.major.isNotEmpty
                                                ? edu.major
                                                : '',
                                            style: TextStyle(
                                              fontSize: _smallTextSize,
                                              color: _textColor,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        SizedBox(height: _spacingLarge),
                      ],

                      // ----- ★★★ 工作经历（无数据时整个模块隐藏） ★★★ -----
                      if (resume.workExperiences.isNotEmpty) ...[
                        _buildSectionTitleWithTag('工作经历'),
                        SizedBox(height: _sectionTitleBottomSpacing),
                        Padding(
                          padding: EdgeInsets.only(left: contentLeftPadding),
                          child: Column(
                            children: resume.workExperiences
                                .map(
                                  (exp) => Padding(
                                    padding: EdgeInsets.only(
                                      bottom: _workItemBottomSpacing,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: _timeWidth,
                                              child: Text(
                                                '${exp.startDate.year}~${exp.endDate?.year ?? '至今'}',
                                                style: TextStyle(
                                                  fontSize: _mediumTextSize,
                                                  fontWeight: _boldWeight,
                                                  color: _textColor,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: _spacingMedium,
                                            ),
                                            Flexible(
                                              child: Text(
                                                exp.company,
                                                style: TextStyle(
                                                  fontSize: _mediumTextSize,
                                                  fontWeight: _boldWeight,
                                                  color: _textColor,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              width: workPositionSpacing,
                                            ),
                                            Text(
                                              exp.position,
                                              style: TextStyle(
                                                fontSize: _mediumTextSize,
                                                fontWeight: _boldWeight,
                                                color: _textColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (exp.description.isNotEmpty) ...[
                                          const SizedBox(height: _spacingSmall),
                                          ...exp.description.split('\n').map((
                                            line,
                                          ) {
                                            final trimmed = line.trim();
                                            if (trimmed.isEmpty)
                                              return const SizedBox.shrink();
                                            String content = trimmed;
                                            if (content.startsWith('-') ||
                                                content.startsWith('•') ||
                                                content.startsWith('*')) {
                                              content = content
                                                  .substring(1)
                                                  .trim();
                                            }
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                left: _descLeftPadding,
                                                bottom: _descBottomSpacing,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: _descBulletWidth,
                                                    child: Text(
                                                      '-',
                                                      style: TextStyle(
                                                        fontSize:
                                                            _smallTextSize,
                                                        color: _textColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      content,
                                                      style: TextStyle(
                                                        fontSize:
                                                            _smallTextSize,
                                                        height: 1.2,
                                                        color: _textColor,
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
                                )
                                .toList(),
                          ),
                        ),
                      ],

                      // ----- ★★★ 项目经验（无数据时整个模块隐藏） ★★★ -----
                      if (resume.projects.isNotEmpty) ...[
                        _buildSectionTitleWithTag('项目经验'),
                        SizedBox(height: _sectionTitleBottomSpacing),
                        Padding(
                          padding: EdgeInsets.only(left: contentLeftPadding),
                          child: Column(
                            children: resume.projects
                                .map(
                                  (proj) => Padding(
                                    padding: EdgeInsets.only(
                                      bottom: _projectItemBottomSpacing,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                proj.name,
                                                style: TextStyle(
                                                  fontSize: _mediumTextSize,
                                                  fontWeight: _boldWeight,
                                                  color: _textColor,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(width: projectRoleSpacing),
                                            Text(
                                              '角色: ${proj.role.isNotEmpty ? proj.role : '未填写'}',
                                              style: TextStyle(
                                                fontSize: _mediumTextSize,
                                                fontWeight: _boldWeight,
                                                color: _textColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (proj.description.isNotEmpty) ...[
                                          const SizedBox(height: _spacingSmall),
                                          ...proj.description.split('\n').map((
                                            line,
                                          ) {
                                            final trimmed = line.trim();
                                            if (trimmed.isEmpty)
                                              return const SizedBox.shrink();
                                            String content = trimmed;
                                            if (content.startsWith('-') ||
                                                content.startsWith('•') ||
                                                content.startsWith('*')) {
                                              content = content
                                                  .substring(1)
                                                  .trim();
                                            }
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                left: _descLeftPadding,
                                                bottom: _descBottomSpacing,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: _descBulletWidth,
                                                    child: Text(
                                                      '-',
                                                      style: TextStyle(
                                                        fontSize:
                                                            _smallTextSize,
                                                        color: _textColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      content,
                                                      style: TextStyle(
                                                        fontSize:
                                                            _smallTextSize,
                                                        height: 1.2,
                                                        color: _textColor,
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
                                )
                                .toList(),
                          ),
                        ),
                      ],

                      // ----- ★★★ 荣誉奖励（无数据时整个模块隐藏） ★★★ -----
                      if (resume.honors.isNotEmpty) ...[
                        _buildSectionTitleWithTag('荣誉奖励'),
                        SizedBox(height: _sectionTitleBottomSpacing),
                        Padding(
                          padding: EdgeInsets.only(left: contentLeftPadding),
                          child: Wrap(
                            spacing: _tagSpacing,
                            runSpacing: _tagRunSpacing,
                            children: resume.honors.map((h) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: _tagHorizontalPadding,
                                  vertical: _tagVerticalPadding,
                                ),
                                decoration: BoxDecoration(
                                  color: _primaryColor.withOpacity(
                                    _primaryOpacity,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    _tagRadius,
                                  ),
                                  border: Border.all(
                                    color: _accentColor.withOpacity(
                                      _accentOpacity,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  h,
                                  style: TextStyle(
                                    fontSize: _smallTextSize,
                                    color: _textColor,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: _spacingLarge),
                      ],

                      // ----- ★★★ 技能特长（无数据时整个模块隐藏） ★★★ -----
                      if (resume.skills.isNotEmpty) ...[
                        _buildSectionTitleWithTag('技能特长'),
                        SizedBox(height: _sectionTitleBottomSpacing),
                        Padding(
                          padding: EdgeInsets.only(left: contentLeftPadding),
                          child: Wrap(
                            spacing: _tagSpacing,
                            runSpacing: _tagRunSpacing,
                            children: resume.skills.map((s) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: _tagHorizontalPadding,
                                  vertical: _tagVerticalPadding,
                                ),
                                decoration: BoxDecoration(
                                  color: _primaryColor.withOpacity(
                                    _primaryOpacity,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    _tagRadius,
                                  ),
                                  border: Border.all(
                                    color: _accentColor.withOpacity(
                                      _accentOpacity,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  s.name,
                                  style: TextStyle(
                                    fontSize: _smallTextSize,
                                    color: _textColor,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: _spacingLarge),
                      ],

                      // ----- ★★★ 自我评价（无数据时整个模块隐藏） ★★★ -----
                      if (resume.summary.isNotEmpty) ...[
                        _buildSectionTitleWithTag('自我评价'),
                        SizedBox(height: _sectionTitleBottomSpacing),
                        Padding(
                          padding: EdgeInsets.only(left: contentLeftPadding),
                          child: Text(
                            '\u3000\u3000${resume.summary}',
                            style: TextStyle(
                              fontSize: _smallTextSize,
                              height: 1.2,
                              color: _textColor,
                            ),
                          ),
                        ),
                        // 最后一项不需要底部间距
                      ],
                    ],
                  ),
                ),

                // ---- 贯穿竖线 ----
                Positioned(
                  left: leftTriangleHorizontal + verticalLineLeftOffset,
                  top:
                      contentVerticalPadding +
                      titleHeight +
                      verticalLineStartOffset,
                  bottom: contentVerticalPadding,
                  child: Container(
                    width: verticalLineWidth,
                    color: headerBgColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---- 标题装饰（已移除内部竖线） ----
  Widget _buildSectionTitleWithTag(String title) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  clipBehavior: Clip.none,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // 标题背景矩形（无左边框）
                      Container(
                        height: titleHeight,
                        padding: EdgeInsets.only(
                          left: contentLeftPadding + titlePaddingHorizontal,
                          right: titlePaddingHorizontal,
                        ),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: headerBgColor,
                          border: Border(
                            top: BorderSide(
                              color: headerBgColor,
                              width: strokeWidth,
                            ),
                            right: BorderSide(
                              color: headerBgColor,
                              width: strokeWidth,
                            ),
                            bottom: BorderSide(
                              color: headerBgColor,
                              width: strokeWidth,
                            ),
                          ),
                        ),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: _xlargeTextSize,
                            fontWeight: _boldWeight,
                            color: _whiteColor,
                            letterSpacing: _titleLetterSpacing,
                          ),
                        ),
                      ),
                      // 左下角三角形（直角点即为标题背景左下角）
                      Positioned(
                        left: 0,
                        bottom: -leftTriangleVertical,
                        child: SizedBox(
                          width: leftTriangleHorizontal,
                          height: leftTriangleVertical,
                          child: CustomPaint(
                            painter: _LeftBottomTrianglePainter(
                              color: headerBgColor,
                              strokeWidth: strokeWidth,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 右侧直角三角形
                SizedBox(
                  width: rightTriangleHorizontal,
                  height: rightTriangleVertical,
                  child: CustomPaint(
                    painter: _RightTrianglePainter(
                      color: headerBgColor,
                      vertical: rightTriangleVertical,
                      horizontal: rightTriangleHorizontal,
                      strokeWidth: strokeWidth,
                    ),
                  ),
                ),
              ],
            ),
            // 底部横线
            Container(
              height: _titleBottomLineHeight,
              width: titleLineLength,
              color: headerBgColor,
            ),
          ],
        );
      },
    );
  }

  // ---- 辅助组件 ----
  // 注意：_buildIntentChip 已不再使用，但保留方法定义以保持代码结构不变
  Widget _buildIntentChip(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label：',
          style: TextStyle(fontSize: _chipLabelFontSize, color: _textColor),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: _chipValueFontSize,
            fontWeight: _mediumWeight,
            color: _textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTextWhite(String label, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: _headerInfoFontSize, color: _whiteColor),
        children: [
          TextSpan(text: label),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

// ---- 左下角三角形绘制器 ----
class _LeftBottomTrianglePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  const _LeftBottomTrianglePainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final paintStroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paintFill);
    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---- 右侧直角三角形绘制器 ----
class _RightTrianglePainter extends CustomPainter {
  final Color color;
  final double vertical;
  final double horizontal;
  final double strokeWidth;
  const _RightTrianglePainter({
    required this.color,
    required this.vertical,
    required this.horizontal,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final paintStroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paintFill);
    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
