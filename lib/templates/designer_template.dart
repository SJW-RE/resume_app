import 'package:flutter/material.dart';
import '../models/resume.dart';
import '../models/work_experience.dart';
import '../models/education.dart';
import '../models/project.dart';
import 'package:flutter/material.dart';
import '../models/resume.dart';

class DesignerTemplate extends StatelessWidget {
  final Resume resume;
  const DesignerTemplate({super.key, required this.resume});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final accentColor = theme.colorScheme.secondary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== 个人信息卡片 =====
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white,
                    child: Text(
                      resume.personal.fullName.isNotEmpty
                          ? resume.personal.fullName[0]
                          : '?',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          resume.personal.fullName,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          resume.personal.jobTitle,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 16,
                          children: [
                            if (resume.personal.phone.isNotEmpty)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.phone,
                                    size: 14,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    resume.personal.phone,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            if (resume.personal.email.isNotEmpty)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.email,
                                    size: 14,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    resume.personal.email,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ===== 内容区域 =====
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 工作经历
                  if (resume.workExperiences.isNotEmpty) ...[
                    _buildSectionTitle(
                      '工作经历',
                      Icons.work_outline,
                      primaryColor,
                    ),
                    const SizedBox(height: 8),
                    ...resume.workExperiences.map(
                      (exp) => _buildWorkCard(exp, primaryColor),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 教育经历
                  if (resume.educations.isNotEmpty) ...[
                    _buildSectionTitle(
                      '教育背景',
                      Icons.school_outlined,
                      primaryColor,
                    ),
                    const SizedBox(height: 8),
                    ...resume.educations.map(
                      (edu) => _buildEducationCard(edu, primaryColor),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 项目经验
                  if (resume.projects.isNotEmpty) ...[
                    _buildSectionTitle('项目经验', Icons.code, primaryColor),
                    const SizedBox(height: 8),
                    ...resume.projects.map(
                      (proj) => _buildProjectCard(proj, primaryColor),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 技能
                  if (resume.skills.isNotEmpty) ...[
                    _buildSectionTitle(
                      '专业技能',
                      Icons.star_outline,
                      primaryColor,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: resume.skills.map((s) {
                        return Chip(
                          label: Text(s.name),
                          backgroundColor: primaryColor.withValues(alpha: 0.1),
                          labelStyle: TextStyle(color: primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: primaryColor.withValues(alpha: 0.3),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 个人总结
                  if (resume.summary.isNotEmpty) ...[
                    _buildSectionTitle(
                      '个人总结',
                      Icons.description_outlined,
                      primaryColor,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: primaryColor.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Text(
                        resume.summary,
                        style: const TextStyle(height: 1.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const Expanded(child: Divider(indent: 12)),
      ],
    );
  }

  Widget _buildWorkCard(WorkExperience exp, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          exp.position,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exp.company,
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              '${exp.startDate.year} - ${exp.endDate?.year ?? '至今'}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (exp.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(exp.description),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEducationCard(Education edu, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          edu.degree,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(edu.school, style: TextStyle(color: color)),
            const SizedBox(height: 4),
            Text(
              '${edu.startDate.year} - ${edu.endDate?.year ?? '至今'}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (edu.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(edu.description),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(Project proj, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          proj.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (proj.role.isNotEmpty) Text(proj.role),
            if (proj.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(proj.description),
            ],
          ],
        ),
      ),
    );
  }
}

/*class DesignerTemplate extends StatelessWidget {
  final Resume resume;
  const DesignerTemplate({required this.resume});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue.shade50, Colors.white]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头部卡片
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 50, color: Colors.blue),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              resume.personal.fullName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (resume.personal.jobTitle.isNotEmpty)
                              Text(resume.personal.jobTitle),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 12,
                              children: [
                                if (resume.personal.phone.isNotEmpty)
                                  Text(resume.personal.phone),
                                if (resume.personal.email.isNotEmpty)
                                  Text(resume.personal.email),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 工作经历
              _buildSection(
                '工作经历',
                resume.workExperiences
                    .map((exp) => _buildWorkCard(exp))
                    .toList(),
              ),
              // 教育经历
              _buildSection(
                '教育经历',
                resume.educations
                    .map((edu) => _buildEducationCard(edu))
                    .toList(),
              ),
              // 技能
              if (resume.skills.isNotEmpty) ...[
                const Text(
                  '技能',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: resume.skills
                      .map((s) => Chip(label: Text(s.name)))
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],
              // 项目经验
              _buildSection(
                '项目经验',
                resume.projects.map((proj) => _buildProjectCard(proj)).toList(),
              ),
              // 个人总结
              if (resume.summary.isNotEmpty) ...[
                const Text(
                  '个人总结',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(resume.summary),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildWorkCard(WorkExperience exp) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          '${exp.position} @ ${exp.company}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${exp.startDate.year} - ${exp.endDate?.year ?? '至今'}'),
        isThreeLine: true,
        subtitleTextStyle: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildEducationCard(Education edu) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text('${edu.degree} @ ${edu.school}'),
        subtitle: Text('${edu.startDate.year} - ${edu.endDate?.year ?? '至今'}'),
      ),
    );
  }

  Widget _buildProjectCard(Project proj) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(proj.name),
        subtitle: proj.description.isNotEmpty ? Text(proj.description) : null,
      ),
    );
  }
}*/
