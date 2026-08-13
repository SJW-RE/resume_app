import 'package:flutter/material.dart';
import '../../models/resume.dart';
import '../../models/work_experience.dart';
import '../../models/education.dart';
import '../../models/skill.dart';
import '../../models/project.dart';

class DarkTemplate extends StatelessWidget {
  final Resume resume;
  const DarkTemplate({super.key, required this.resume});

  // ================================================================
  // 样式配置（所有参数均在此定义，方便统一修改）
  // ================================================================

  // ---- 颜色配置 ----
  static const Color _headerBgColor = Color(0xFF1A1A30); // 头部背景色
  static const Color _leftBgColor = Color(0xFFE0E0EA); // 左侧区域背景色
  static const Color _rightBgColor = Colors.white; // 右侧区域背景色
  static const Color _sectionTitleBgColor = Color(0xFF1A1A3A); // 章节标题背景色
  static const Color _sectionTitleTextColor = Colors.white; // 章节标题文字颜色
  static const Color _dividerColor = Color.fromARGB(255, 24, 43, 49); // 分割条颜色
  static const Color _lightTextColor = Colors.black; // 浅色背景正文（纯黑）
  static const Color _lightSubTextColor = Colors.black; // 浅色背景次要（纯黑）
  static const Color _darkTextColor = Colors.white; // 深色背景文字（白色）

  // ---- 尺寸与间距 ----
  static const double _dividerHeight = 8.0; // 分割条高度
  static const double _sectionSpacing = 12.0; // 模块间距
  static const double _itemSpacing = 4.0; // 条目间距
  static const double _headerPaddingVertical = 16.0; // 头部上下内边距
  static const double _headerPaddingHorizontal = 24.0; // 头部左右内边距
  static const double _contentPadding = 16.0; // 内容区域内边距
  static const double _leftWidthFactor = 0.3; // 左侧宽度占比
  static const double _rightWidthFactor = 0.7; // 右侧宽度占比

  // ---- 头部配置 ----
  static const double _headerHeight = 150.0; // 头部总高度
  static const double _headerNameFontSize = 26.0; // 姓名字号
  static const double _headerJobFontSize = 16.0; // 求职意向字号
  static const double _avatarSize = 120.0; // 头像尺寸（矩形）
  static const double _avatarLeftOffset = 24.0; // 头像距离左侧偏移
  static const double _avatarTopOffset = 10.0; // 头像向上偏移（已调整）
  static const double _avatarCornerRadius = 6.0; // 头像圆角半径

  // ---- 基础信息配置 ----
  static const double _infoFontSize = 13.0;
  static const double _infoItemSpacing = 6.0;

  // ---- 章节标题配置 ----
  static const double _sectionTitleHeight = 32.0;
  static const double _sectionTitleIconSize = 18.0;
  static const double _sectionTitleFontSize = 15.0;
  static const double _sectionTitlePaddingHorizontal = 16.0;

  // ---- 工作经历配置 ----
  static const double _workTimeWidth = 90.0;
  static const double _workTimeFontSize = 13.0;
  static const double _workCompanyFontSize = 14.0;
  static const double _workPositionFontSize = 13.0;
  static const double _workDescriptionFontSize = 12.0;
  static const double _workDescriptionHeight = 1.4;
  static const double _workItemSpacing = 8.0;

  // ---- 教育经历配置 ----
  static const double _eduTimeWidth = 90.0;
  static const double _eduFontSize = 13.0;
  static const double _eduDescriptionFontSize = 12.0;
  static const double _eduDescriptionHeight = 1.4;
  static const double _eduItemSpacing = 8.0;

  // ---- 项目经验配置 ----
  static const double _projectNameFontSize = 14.0;
  static const double _projectRoleFontSize = 13.0;
  static const double _projectDescriptionFontSize = 12.0;
  static const double _projectDescriptionHeight = 1.4;
  static const double _projectItemSpacing = 8.0;

  // ---- 个人评价配置 ----
  static const double _summaryFontSize = 13.0;
  static const double _summaryHeight = 1.6;
  static const String _summaryIndent = '\u3000\u3000';

  // ---- 技能荣誉配置 ----
  static const double _skillItemSpacing = 4.0;
  static const double _skillFontSize = 13.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Container(
        color: Colors.grey[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头部 + 分割条 + 浮动头像（Stack 使头像独立悬浮）
            Stack(
              clipBehavior: Clip.none,
              children: [
                // 头部与分割条作为背景层
                Column(
                  children: [
                    _buildHeader(resume),
                    Container(height: _dividerHeight, color: _dividerColor),
                  ],
                ),
                // 头像浮动层（独立于头部，可覆盖分割条）
                Positioned(
                  left: _avatarLeftOffset,
                  top: _headerHeight - _avatarSize - 15, // 使头像底部覆盖分割条
                  child: _buildAvatar(resume),
                ),
              ],
            ),
            const SizedBox(height: _sectionSpacing),

            // 左右两栏
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 左侧区域
                  Expanded(
                    flex: (_leftWidthFactor * 10).toInt(),
                    child: Container(
                      color: _leftBgColor,
                      padding: const EdgeInsets.all(_contentPadding),
                      child: _buildLeftContent(resume),
                    ),
                  ),
                  // 右侧区域
                  Expanded(
                    flex: (_rightWidthFactor * 10).toInt(),
                    child: Container(
                      color: _rightBgColor,
                      padding: const EdgeInsets.all(_contentPadding),
                      child: _buildRightContent(resume),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 头像（矩形） ----
  Widget _buildAvatar(Resume resume) {
    return Container(
      width: _avatarSize,
      height: _avatarSize,
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(_avatarCornerRadius),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_avatarCornerRadius),
        child: resume.personal.avatarImage != null
            ? Image.memory(resume.personal.avatarImage!, fit: BoxFit.cover)
            : const Icon(Icons.person, size: 60, color: Colors.grey),
      ),
    );
  }

  // ---- 头部（姓名、求职意向、“个人简历”右上角） ----
  Widget _buildHeader(Resume resume) {
    final name = resume.personal.fullName.isNotEmpty
        ? resume.personal.fullName
        : '未填写';
    final job = resume.personal.jobTitle.isNotEmpty
        ? resume.personal.jobTitle
        : '未填写';

    return Container(
      height: _headerHeight,
      width: double.infinity,
      color: _headerBgColor,
      padding: EdgeInsets.symmetric(
        horizontal: _headerPaddingHorizontal,
        vertical: _headerPaddingVertical,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧留白（给头像，并让姓名右移）
          SizedBox(width: _avatarSize + 45),
          // 中间姓名与求职意向（垂直居中）
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: _headerNameFontSize,
                    fontWeight: FontWeight.bold,
                    color: _darkTextColor,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '求职意向：$job',
                  style: TextStyle(
                    fontSize: _headerJobFontSize,
                    color: _darkTextColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          // 右侧“个人简历 / RESUME” 置于右上角
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '个人简历',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _darkTextColor,
                  letterSpacing: 4,
                ),
              ),
              Text(
                'RESUME',
                style: TextStyle(
                  fontSize: 12,
                  color: _darkTextColor,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- 左侧内容（含基础信息、个人技能、荣誉奖励、语言能力） ----
  Widget _buildLeftContent(Resume resume) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('基础信息', Icons.person_outline),
        const SizedBox(height: _itemSpacing),
        _buildInfoSection(resume),
        const SizedBox(height: _sectionSpacing),

        if (resume.skills.isNotEmpty) ...[
          _buildSectionTitle('个人技能', Icons.psychology),
          const SizedBox(height: _itemSpacing),
          _buildSkillList(resume.skills.map((s) => s.name).toList()),
          const SizedBox(height: _sectionSpacing),
        ],

        if (resume.honors.isNotEmpty) ...[
          _buildSectionTitle('荣誉奖励', Icons.emoji_events),
          const SizedBox(height: _itemSpacing),
          _buildSkillList(resume.honors),
          const SizedBox(height: _sectionSpacing),
        ],

        // 新增语言能力模块（自动隐藏为空）
        if (resume.languages.isNotEmpty) ...[
          _buildSectionTitle('语言能力', Icons.language),
          const SizedBox(height: _itemSpacing),
          _buildSkillList(resume.languages),
          const SizedBox(height: _sectionSpacing),
        ],
      ],
    );
  }

  // ---- 右侧内容 ----
  Widget _buildRightContent(Resume resume) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (resume.educations.isNotEmpty) ...[
          _buildSectionTitle('教育经历', Icons.school),
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

        if (resume.summary.isNotEmpty) ...[
          _buildSectionTitle('自我评价', Icons.person_outline),
          const SizedBox(height: _itemSpacing),
          _buildSummarySection(resume),
          const SizedBox(height: _sectionSpacing),
        ],
      ],
    );
  }

  // ---- 基础信息（标签无空格，左对齐，所有文字纯黑） ----
  Widget _buildInfoSection(Resume resume) {
    final personal = resume.personal;
    final items = <String, String>{
      '姓名': personal.fullName.isNotEmpty ? personal.fullName : '未填写',
      '出生日期': personal.birthDate ?? '未填写',
      '学历': _getHighestDegree(resume),
      '电话': personal.phone.isNotEmpty ? personal.phone : '未填写',
      '邮箱': personal.email.isNotEmpty ? personal.email : '未填写',
      '民族': personal.nation ?? '未填写',
      '籍贯': personal.birthPlace ?? '未填写',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.entries.map((entry) {
        return Padding(
          padding: EdgeInsets.only(bottom: _infoItemSpacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key + '：',
                style: TextStyle(
                  fontSize: _infoFontSize,
                  fontWeight: FontWeight.w500,
                  color: _lightSubTextColor, // 纯黑
                ),
              ),
              Expanded(
                child: Text(
                  entry.value,
                  style: TextStyle(
                    fontSize: _infoFontSize,
                    color: _lightTextColor, // 纯黑
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

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

  // ---- 章节标题（全宽深色背景，文字白色） ----
  Widget _buildSectionTitle(String title, IconData icon) {
    return Container(
      width: double.infinity,
      height: _sectionTitleHeight,
      padding: EdgeInsets.symmetric(horizontal: _sectionTitlePaddingHorizontal),
      color: _sectionTitleBgColor,
      child: Row(
        children: [
          Icon(
            icon,
            size: _sectionTitleIconSize,
            color: _sectionTitleTextColor,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: _sectionTitleFontSize,
              fontWeight: FontWeight.bold,
              color: _sectionTitleTextColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ---- 技能/荣誉/语言列表（逐条罗列，纯黑文字） ----
  Widget _buildSkillList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: _skillItemSpacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• ',
                style: TextStyle(
                  fontSize: _skillFontSize,
                  color: _lightSubTextColor, // 纯黑
                ),
              ),
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: _skillFontSize,
                    color: _lightTextColor, // 纯黑
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ---- 工作经历（工作时间加粗，公司右对齐） ----
  Widget _buildWorkItem(WorkExperience exp) {
    return Padding(
      padding: EdgeInsets.only(bottom: _workItemSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: _workTimeWidth,
                child: Text(
                  '${exp.startDate.year}.${exp.startDate.month.toString().padLeft(2, '0')} - ${exp.endDate?.year ?? '至今'}',
                  style: TextStyle(
                    fontSize: _workTimeFontSize,
                    fontWeight: FontWeight.bold, // 加粗
                    color: _lightSubTextColor,
                  ),
                  textAlign: TextAlign.left, // 时间左对齐
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  exp.company,
                  style: TextStyle(
                    fontSize: _workCompanyFontSize,
                    fontWeight: FontWeight.bold,
                    color: _lightTextColor,
                  ),
                  textAlign: TextAlign.right, // ★ 公司右对齐
                ),
              ),
            ],
          ),
          Text(
            '岗位：${exp.position}',
            style: TextStyle(
              fontSize: _workPositionFontSize,
              color: _lightTextColor,
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
                            color: _lightSubTextColor,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            cleaned,
                            style: TextStyle(
                              fontSize: _workDescriptionFontSize,
                              height: _workDescriptionHeight,
                              color: _lightTextColor,
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

  // ---- 教育经历（时间、学校、学位、专业同行，权重调整：学校3，专业2，学位1） ----
  Widget _buildEducationItem(Education edu) {
    return Padding(
      padding: EdgeInsets.only(bottom: _eduItemSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 时间固定宽度
              SizedBox(
                width: _eduTimeWidth,
                child: Text(
                  '${edu.startDate.year}.${edu.startDate.month.toString().padLeft(2, '0')} - ${edu.endDate?.year ?? '至今'}',
                  style: TextStyle(
                    fontSize: _eduFontSize,
                    color: _lightSubTextColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(width: 22),
              // 学校（flex: 3，占较大空间）
              Expanded(
                flex: 3,
                child: Text(
                  edu.school,
                  style: TextStyle(
                    fontSize: _eduFontSize,
                    color: _lightTextColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(width: 12),
              // 学位（flex: 1）
              Expanded(
                flex: 1,
                child: Text(
                  edu.degree,
                  style: TextStyle(
                    fontSize: _eduFontSize,
                    color: _lightTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 12),
              // 专业（flex: 2）
              Expanded(
                flex: 2,
                child: Text(
                  edu.major,
                  style: TextStyle(
                    fontSize: _eduFontSize,
                    color: _lightTextColor,
                  ),
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
                color: _lightTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---- 项目经验（项目名左对齐，角色右对齐） ----
  Widget _buildProjectItem(Project proj) {
    return Padding(
      padding: EdgeInsets.only(bottom: _projectItemSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  proj.name,
                  style: TextStyle(
                    fontSize: _projectNameFontSize,
                    fontWeight: FontWeight.bold,
                    color: _lightTextColor,
                  ),
                  textAlign: TextAlign.left, // ★ 项目名左对齐
                ),
              ),
              const SizedBox(width: 40), // 保留间距（可调）
              Expanded(
                child: Text(
                  '角色：${proj.role.isNotEmpty ? proj.role : '未填写'}',
                  style: TextStyle(
                    fontSize: _projectRoleFontSize,
                    fontWeight: FontWeight.bold,
                    color: _lightTextColor,
                  ),
                  textAlign: TextAlign.right, // ★ 角色右对齐
                ),
              ),
            ],
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
                            color: _lightSubTextColor,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            cleaned,
                            style: TextStyle(
                              fontSize: _projectDescriptionFontSize,
                              height: _projectDescriptionHeight,
                              color: _lightTextColor,
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

  // ---- 自我评价 ----
  Widget _buildSummarySection(Resume resume) {
    return Text(
      '$_summaryIndent${resume.summary}',
      style: TextStyle(
        fontSize: _summaryFontSize,
        height: _summaryHeight,
        color: _lightTextColor,
      ),
    );
  }
}
