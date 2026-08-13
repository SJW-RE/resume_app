import 'package:flutter/material.dart';
import '../models/resume.dart';
import '../models/work_experience.dart';
import '../models/education.dart';
import '../models/project.dart';

class AtsTemplate extends StatelessWidget {
  final Resume resume;
  const AtsTemplate({super.key, required this.resume});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final hasData =
        resume.personal.fullName.isNotEmpty ||
        resume.workExperiences.isNotEmpty ||
        resume.educations.isNotEmpty;

    return Container(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 空数据提示
            if (!hasData)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Text(
                    '暂无数据，请返回编辑页填写信息',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
            // 姓名 + 求职意向
            if (resume.personal.fullName.isNotEmpty)
              Text(
                resume.personal.fullName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (resume.personal.jobTitle.isNotEmpty)
              Text(
                resume.personal.jobTitle,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            const SizedBox(height: 12),
            // 联系方式
            Wrap(
              spacing: 16,
              children: [
                if (resume.personal.phone.isNotEmpty)
                  Text('电话：${resume.personal.phone}'),
                if (resume.personal.email.isNotEmpty)
                  Text('邮箱：${resume.personal.email}'),
              ],
            ),
            const Divider(),

            // 教育经历
            if (resume.educations.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                '教育经历',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...resume.educations
                  .map((edu) => _buildEducationItem(edu))
                  ,
            ],

            // 工作经历
            if (resume.workExperiences.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                '工作经历',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...resume.workExperiences
                  .map((exp) => _buildWorkItem(exp))
                  ,
            ],

            // 项目经验
            if (resume.projects.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                '项目经验',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...resume.projects
                  .map((proj) => _buildProjectItem(proj))
                  ,
            ],

            // 技能
            // 技能（顿号分隔）
            if (resume.skills.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                '技能',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                resume.skills.map((s) => s.name).join('、'),
                style: const TextStyle(fontSize: 14, height: 1.6),
              ),
            ],

            // ===== 新增：语言能力 =====
            if (resume.languages.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                '语言能力',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                resume.languages.join('、'),
                style: const TextStyle(fontSize: 14),
              ),
            ],
            // ===== 语言能力新增结束 =====

            // 荣誉奖励
            if (resume.honors.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                '荣誉奖励',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                resume.honors.join('、'),
                style: const TextStyle(fontSize: 14),
              ),
            ],

            // 个人总结
            if (resume.summary.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                '个人总结',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(resume.summary),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 修改点1: 工作经历描述符号处理
  // ============================================================
  Widget _buildWorkItem(WorkExperience exp) {
    final bottomPadding = exp.description.isNotEmpty ? 12.0 : 6.0;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${exp.position} @ ${exp.company}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('${exp.startDate.year} - ${exp.endDate?.year ?? '至今'}'),
          if (exp.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            ...exp.description.split('\n').map((line) {
              final trimmed = line.trim();
              if (trimmed.isEmpty) return const SizedBox.shrink();
              // 检测并删除已有的符号（-、•、*）
              String content = trimmed;
              if (content.startsWith('-') ||
                  content.startsWith('•') ||
                  content.startsWith('*')) {
                content = content.substring(1).trim();
              }
              // 统一添加 "-" 前缀
              return Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 2),
                child: Text('- $content'),
              );
            }),
          ],
        ],
      ),
    );
  }
  // ============================================================

  Widget _buildEducationItem(Education edu) {
    final hasDescription = edu.description.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${edu.degree} @ ${edu.school}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('${edu.startDate.year} - ${edu.endDate?.year ?? '至今'}'),
        if (hasDescription) ...[
          const SizedBox(height: 4),
          Text(edu.description.trim()),
          const SizedBox(height: 12),
        ],
        if (!hasDescription) const SizedBox(height: 12),
      ],
    );
  }

  // ============================================================
  // 修改点2: 项目经验描述符号处理
  // ============================================================
  Widget _buildProjectItem(Project proj) {
    final bottomPadding = proj.description.isNotEmpty ? 12.0 : 6.0;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(proj.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (proj.role.isNotEmpty) Text(proj.role),
          if (proj.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            ...proj.description.split('\n').map((line) {
              final trimmed = line.trim();
              if (trimmed.isEmpty) return const SizedBox.shrink();
              // 检测并删除已有的符号（-、•、*）
              String content = trimmed;
              if (content.startsWith('-') ||
                  content.startsWith('•') ||
                  content.startsWith('*')) {
                content = content.substring(1).trim();
              }
              // 统一添加 "-" 前缀
              return Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 2),
                child: Text('- $content'),
              );
            }),
          ],
        ],
      ),
    );
  }
}
