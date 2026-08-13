// lib/templates/classic_resume_template.dart
import 'package:flutter/material.dart';
import '../../models/resume.dart';
import '../../models/work_experience.dart';
import '../../models/education.dart';
import '../../models/skill.dart';
import '../../models/project.dart';

class ClassicTemplate extends StatelessWidget {
  final Resume resume;
  const ClassicTemplate({super.key, required this.resume});

  // ================================================================
  // 样式配置（可修改参数）
  // ================================================================

  // ---- 颜色配置 ----
  static const Color _primaryColor = Color.fromARGB(
    255,
    31,
    65,
    116,
  ); // 主色（深蓝黑，用于标题背景和头部）
  static const Color _headerBgColor = Color.fromARGB(255, 31, 65, 116); // 头部背景色
  static const Color _headerTextColor = Colors.white; // 头部文字颜色
  static const Color _textColor = Colors.black; // 正文文字颜色（纯黑）
  static const Color _sectionTitleBgColor = Color.fromARGB(
    255,
    31,
    65,
    116,
  ); // 章节标题背景色
  static const Color _sectionTitleTextColor = Colors.white; // 章节标题文字颜色
  static const Color _sectionRightBarColor = Color.fromARGB(
    255,
    207,
    209,
    219,
  ); // 右侧延伸矩形颜色（浅色）

  // ---- 全局间距 ----
  static const double _sectionSpacing = 8.0; // 模块之间的间距
  static const double _itemSpacing = 6.0; // 条目之间的间距
  static const double _headerPaddingVertical = 20.0; // 头部上下内边距
  static const double _headerPaddingLeft = 30.0; // 头部左侧内边距
  static const double _contentPaddingHorizontal = 24.0; // 内容区域左右内边距

  // ---- 章节标题配置 ----
  static const double _sectionTitleHeight = 25.0; // 标题栏高度
  static const double _sectionTitleIconSize = 18.0; // 标题图标大小
  static const double _sectionTitleFontSize = 16.0; // 标题字号
  static const double _sectionTitlePaddingHorizontal = 16.0; // 标题左右内边距
  static const double _sectionTitleRadius = 0.0; // 标题圆角

  // 浅色背景框颜色（淡紫色）
  static const double _sectionLeftBarWidth = 6.0; // 标题左侧小长方形宽度
  static const double _sectionLeftBarHeight = 24.0; // 标题左侧小长方形高度
  static const double _sectionLeftBarSpacing = 8.0; // 小长方形与标题背景之间的水平间距
  static const double _sectionRightBarHeight = 25.0; // 右侧延伸矩形高度（与标题背景一致）

  // ---- ★ 装饰条配置（平行四边形条，已修改） ----
  static const double _decoBarContainerHeight = 40.0; // 装饰条容器高度（调小）
  static const double _decoBarLeftHeight = 10.0; // 左侧条高度（窄条）
  static const double _decoBarRightHeight = 10.0; // 右侧条高度（窄条）
  static const double _decoBarLeftWidth = 460.0; // 左侧条宽度（较短）
  static const double _decoBarRightWidth = 200.0; // 右侧条宽度（较长）
  static const double _decoBarLeftTopOffset = 15.0; // 左侧条顶部偏移
  static const double _decoBarRightTopOffset = 25.0; // 右侧条顶部偏移（上下错开）
  static const double _decoBarSkew = 0.4; // 倾斜系数（左右一致，均向右倾斜）
  static const Color _decoBarLeftColor = Color.fromARGB(255, 212, 160, 23); // 左侧颜色与头部背景一致
  static const Color _decoBarRightColor = Color.fromARGB(
    255,
    31,
    65,
    116,
  ); // 右侧深黄色

  // ---- 头部配置 ----
  static const double _headerColumn1Width = 180.0; // 第一列固定宽度
  static const double _headerColumn2Width = 280.0; // 第二列固定宽度（更宽以容纳长内容）
  static const double _headerColumn3Width = 60.0; // 第三列固定宽度
  static const double _headerColumnSpacing = 4.0; // 头部列之间的固定间距
  static const double _headerLabelFontSize = 15.0; // 头部标签字号
  static const double _headerValueFontSize = 15.0; // 头部值字号
  static const double _headerItemSpacing = 9.0; // 头部条目之间的垂直间距
  static const double _avatarSize = 135.0; // 头像尺寸
  static const double _avatarTopOffset = 15.0; // 头像向上偏移量（负值向上）
  static const double _avatarRightOffset = -10.0; // 头像向右偏移量（负值向右）

  // ---- 教育经历配置 ----
  static const double _eduTimeWidth = 100.0; // 教育时间固定宽度
  static const double _eduFontSize = 13.0; // 教育字段字号
  static const double _eduDescriptionFontSize = 12.0; // 教育描述字号
  static const double _eduDescriptionHeight = 1.4; // 教育描述行高
  static const double _eduItemSpacing = 6.0; // 教育条目底部间距

  // ---- 工作经历配置 ----
  static const double _workTimeCompanySpacing = 60.0; // 工作时间与公司之间的间距
  static const double _workTimeFontSize = 13.0; // 工作时间的字号
  static const double _workCompanyFontSize = 13.0; // 公司名称字号
  static const double _workPositionFontSize = 12.0; // 岗位字号
  static const double _workDescriptionFontSize = 12.0; // 工作描述字号
  static const double _workDescriptionHeight = 1.4; // 工作描述行高
  static const double _workItemSpacing = 6.0; // 工作条目底部间距

  // ---- 项目经验配置 ----
  static const double _projectNameFontSize = 14.0; // 项目名称字号
  static const double _projectRoleFontSize = 12.0; // 角色字号
  static const double _projectDescriptionFontSize = 12.0; // 项目描述字号
  static const double _projectDescriptionHeight = 1.4; // 项目描述行高
  static const double _projectItemSpacing = 6.0; // 项目条目底部间距

  // ---- 个人技能配置 ----
  static const double _skillLabelWidth = 72.0; // 技能标签固定宽度
  static const double _skillLabelFontSize = 13.0; // 技能标签字号
  static const double _skillValueFontSize = 13.0; // 技能值字号
  static const double _skillItemSpacing = 4.0; // 技能行之间的垂直间距

  // ---- 个人评价配置 ----
  static const double _summaryFontSize = 13.0; // 评价字号
  static const double _summaryHeight = 1.5; // 评价行高
  static const String _summaryIndent = '\u3000\u3000'; // 首行缩进（两个全角空格）

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(resume),

            // ---- 平行四边形装饰条（已修改） ----
            Container(
              height: _decoBarContainerHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // 左侧条（左对齐，倾斜一致）
                  Positioned(
                    left: 0,
                    top: _decoBarLeftTopOffset,
                    child: Transform(
                      transform: Matrix4.skewX(_decoBarSkew),
                      child: Container(
                        width: _decoBarLeftWidth,
                        height: _decoBarLeftHeight,
                        color: _decoBarLeftColor,
                      ),
                    ),
                  ),
                  // 右侧条（右对齐，倾斜方向一致）
                  Positioned(
                    right: 0,
                    top: _decoBarRightTopOffset,
                    child: Transform(
                      transform: Matrix4.skewX(_decoBarSkew),
                      child: Container(
                        width: _decoBarRightWidth,
                        height: _decoBarRightHeight,
                        color: _decoBarRightColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: _sectionSpacing),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _contentPaddingHorizontal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (resume.educations.isNotEmpty) ...[
                    _buildSectionTitle('教育背景', Icons.school),
                    const SizedBox(height: _itemSpacing),
                    ...resume.educations.map((edu) => _buildEducationItem(edu)),
                    const SizedBox(height: _sectionSpacing),
                  ],

                  if (resume.workExperiences.isNotEmpty) ...[
                    _buildSectionTitle('工作经历', Icons.work),
                    const SizedBox(height: _itemSpacing),
                    ...resume.workExperiences.map((exp) => _buildWorkItem(exp)),
                    const SizedBox(height: _sectionSpacing),
                  ],

                  if (resume.projects.isNotEmpty) ...[
                    _buildSectionTitle('项目经验', Icons.folder_open),
                    const SizedBox(height: _itemSpacing),
                    ...resume.projects.map((proj) => _buildProjectItem(proj)),
                    const SizedBox(height: _sectionSpacing),
                  ],

                  if (resume.skills.isNotEmpty ||
                      resume.honors.isNotEmpty ||
                      resume.languages.isNotEmpty) ...[
                    _buildSectionTitle('个人技能', Icons.psychology),
                    const SizedBox(height: _itemSpacing),
                    _buildSkillSection(resume),
                    const SizedBox(height: _sectionSpacing),
                  ],

                  if (resume.summary.isNotEmpty) ...[
                    _buildSectionTitle('个人评价', Icons.person_outline),
                    const SizedBox(height: _itemSpacing),
                    _buildSummarySection(resume),
                    const SizedBox(height: _sectionSpacing),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 头部基础信息条目（标签右对齐，值不换行，超出截断） ----
  Widget _buildHeaderInfo(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: _headerItemSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 标签：宽度自适应，右对齐
          Text(
            label,
            style: TextStyle(
              fontSize: _headerLabelFontSize,
              color: _headerTextColor,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(width: 8),
          // 值：占满剩余空间，不换行，超出用省略号
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: _headerValueFontSize,
                color: _headerTextColor,
              ),
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ---- 头部（固定宽度列 + 固定间距，头像浮动） ----
  Widget _buildHeader(Resume resume) {
    final List<Widget> column1 = [];
    final List<Widget> column2 = [];
    final List<Widget> column3 = [];

    // 第一列（3个）
    column1.add(
      _buildHeaderInfo(
        '姓名:',
        resume.personal.fullName.isNotEmpty ? resume.personal.fullName : '未填写',
      ),
    );
    column1.add(_buildHeaderInfo('出生:', resume.personal.birthDate ?? '未填写'));
    column1.add(_buildHeaderInfo('籍贯:', resume.personal.birthPlace ?? '未填写'));

    // 第二列（3个）- 内容可能较长（电子邮箱、求职意向、联系电话）
    column2.add(
      _buildHeaderInfo(
        '求职意向:',
        resume.personal.jobTitle.isNotEmpty ? resume.personal.jobTitle : '未填写',
      ),
    );
    column2.add(
      _buildHeaderInfo(
        '电子邮箱:',
        resume.personal.email.isNotEmpty ? resume.personal.email : '未填写',
      ),
    );

    column2.add(
      _buildHeaderInfo(
        '联系电话:',
        resume.personal.phone.isNotEmpty ? resume.personal.phone : '未填写',
      ),
    );

    // 固定宽度列 + 固定间距
    Widget headerContent = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: _headerColumn1Width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: column1,
          ),
        ),
        SizedBox(width: _headerColumnSpacing),
        Container(
          width: _headerColumn2Width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: column2,
          ),
        ),
        SizedBox(width: _headerColumnSpacing),
        Container(
          width: _headerColumn3Width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: column3,
          ),
        ),
      ],
    );

    // 背景框：占满宽度，左侧内边距
    Widget headerBackground = Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: _headerPaddingVertical,
        horizontal: _headerPaddingLeft,
      ),
      color: _headerBgColor,
      child: headerContent,
    );

    // 头像（独立浮动）
    Widget avatar = Container(
      width: _avatarSize,
      height: _avatarSize,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: resume.personal.avatarImage != null
          ? Image.memory(resume.personal.avatarImage!, fit: BoxFit.cover)
          : const Center(
              child: Icon(Icons.person, size: 50, color: Colors.grey),
            ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        headerBackground,
        Positioned(
          top: _avatarTopOffset,
          right: _avatarRightOffset + _headerPaddingLeft,
          child: avatar,
        ),
      ],
    );
  }

  // ---- 获取最高学历 ----
  String _getHighestDegree(Resume resume) {
    if (resume.educations.isEmpty) return '未填写';
    final sorted = List<Education>.from(resume.educations)
      ..sort(
        (a, b) => (b.endDate ?? DateTime.now()).compareTo(
          a.endDate ?? DateTime.now(),
        ),
      );
    return sorted.first.degree;
  }

  // ---- 章节标题（带装饰） ----
  Widget _buildSectionTitle(String title, IconData icon) {
    // 标题主体（深色背景 + 图标 + 文字）
    Widget titleMain = Container(
      height: _sectionTitleHeight,
      padding: EdgeInsets.symmetric(horizontal: _sectionTitlePaddingHorizontal),
      decoration: BoxDecoration(
        color: _sectionTitleBgColor,
        borderRadius: BorderRadius.circular(_sectionTitleRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: _sectionTitleIconSize,
            color: _sectionTitleTextColor,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: _sectionTitleFontSize,
              fontWeight: FontWeight.bold,
              color: _sectionTitleTextColor,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );

    // 右侧延伸矩形（浅色背景，高度与标题背景框一致）
    Widget rightBar = Container(
      height: _sectionRightBarHeight,
      color: _sectionRightBarColor,
    );

    // 标题行：左侧小长方形 + 标题背景 + 右侧延伸矩形（Expanded 填满剩余空间）
    Widget titleRow = Row(
      children: [
        Container(
          width: _sectionLeftBarWidth,
          height: _sectionLeftBarHeight,
          color: _sectionTitleBgColor,
        ),
        SizedBox(width: _sectionLeftBarSpacing),
        titleMain,
        const SizedBox(width: 8), // 标题与右侧矩形之间的间距
        Expanded(child: rightBar),
      ],
    );

    return titleRow;
  }

  // ---- 教育经历 ----
  Widget _buildEducationItem(Education edu) {
    return Padding(
      padding: EdgeInsets.only(bottom: _eduItemSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: _eduTimeWidth,
                child: Text(
                  '${edu.startDate.year}.${edu.startDate.month.toString().padLeft(2, '0')} - ${edu.endDate?.year ?? '至今'}',
                  style: TextStyle(fontSize: _eduFontSize, color: _textColor),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Text(
                  edu.school,
                  style: TextStyle(fontSize: _eduFontSize, color: _textColor),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Text(
                  edu.degree,
                  style: TextStyle(fontSize: _eduFontSize, color: _textColor),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Text(
                  edu.major,
                  style: TextStyle(fontSize: _eduFontSize, color: _textColor),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          if (edu.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              edu.description,
              style: TextStyle(
                fontSize: _eduDescriptionFontSize,
                height: _eduDescriptionHeight,
                color: _textColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---- 工作经历 ----
  Widget _buildWorkItem(WorkExperience exp) {
    return Padding(
      padding: EdgeInsets.only(bottom: _workItemSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${exp.startDate.year}.${exp.startDate.month.toString().padLeft(2, '0')} - ${exp.endDate?.year ?? '至今'}',
                style: TextStyle(
                  fontSize: _workTimeFontSize,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
              SizedBox(width: _workTimeCompanySpacing),
              Text(
                exp.company,
                style: TextStyle(
                  fontSize: _workCompanyFontSize,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ],
          ),
          Text(
            '岗位：${exp.position}',
            style: TextStyle(
              fontSize: _workPositionFontSize,
              color: _textColor,
            ),
          ),
          if (exp.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            ...exp.description
                .split('\n')
                .where((l) => l.trim().isNotEmpty)
                .map((line) {
                  String cleaned = line.trim();
                  if (cleaned.startsWith('-') ||
                      cleaned.startsWith('•') ||
                      cleaned.startsWith('*')) {
                    cleaned = cleaned.substring(1).trim();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            fontSize: _workDescriptionFontSize,
                            color: _textColor,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            cleaned,
                            style: TextStyle(
                              fontSize: _workDescriptionFontSize,
                              height: _workDescriptionHeight,
                              color: _textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })
                .toList(),
          ],
        ],
      ),
    );
  }

  // ---- 项目经验 ----
  Widget _buildProjectItem(Project proj) {
    return Padding(
      padding: EdgeInsets.only(bottom: _projectItemSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            proj.name,
            style: TextStyle(
              fontSize: _projectNameFontSize,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          if (proj.role.isNotEmpty)
            Text(
              '角色：${proj.role}',
              style: TextStyle(
                fontSize: _projectRoleFontSize,
                color: _textColor,
              ),
            ),
          if (proj.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            ...proj.description
                .split('\n')
                .where((l) => l.trim().isNotEmpty)
                .map((line) {
                  String cleaned = line.trim();
                  if (cleaned.startsWith('-') ||
                      cleaned.startsWith('•') ||
                      cleaned.startsWith('*')) {
                    cleaned = cleaned.substring(1).trim();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            fontSize: _projectDescriptionFontSize,
                            color: _textColor,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            cleaned,
                            style: TextStyle(
                              fontSize: _projectDescriptionFontSize,
                              height: _projectDescriptionHeight,
                              color: _textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })
                .toList(),
          ],
        ],
      ),
    );
  }

  // ---- 个人技能 ----
  Widget _buildSkillSection(Resume resume) {
    final List<Widget> sections = [];

    if (resume.skills.isNotEmpty) {
      sections.add(
        _buildSkillRow('技　　能:', resume.skills.map((s) => s.name).toList()),
      );
    }

    if (resume.honors.isNotEmpty) {
      sections.add(_buildSkillRow('荣誉奖励:', resume.honors));
    }

    if (resume.languages.isNotEmpty) {
      sections.add(_buildSkillRow('语言能力:', resume.languages));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections,
    );
  }

  // ---- 技能行 ----
  Widget _buildSkillRow(String label, List<String> items) {
    return Padding(
      padding: EdgeInsets.only(bottom: _skillItemSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _skillLabelWidth,
            child: Text(
              label,
              style: TextStyle(
                fontSize: _skillLabelFontSize,
                fontWeight: FontWeight.w500,
                color: _textColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              items.join('、'),
              style: TextStyle(
                fontSize: _skillValueFontSize,
                color: _textColor,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  // ---- 个人评价（首行缩进2个字符） ----
  Widget _buildSummarySection(Resume resume) {
    return Text(
      '$_summaryIndent${resume.summary}', // 首行缩进两个全角空格
      style: TextStyle(
        fontSize: _summaryFontSize,
        height: _summaryHeight,
        color: _textColor,
      ),
    );
  }
}
