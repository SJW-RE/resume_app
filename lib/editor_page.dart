import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/resume.dart';
import '../models/personal_info.dart';
import '../models/work_experience.dart';
import '../services/resume_storage.dart';
import 'package:flutter/cupertino.dart';
import '../templates/ats_template.dart';
import '../models/education.dart';
import '../models/project.dart';
import '../models/skill.dart';
import 'dart:html' if (dart.library.html) 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:printing/printing.dart';
import '../services/ai_polish_service.dart';
import '../templates/design/modern_template.dart';
import '../templates/design/classic_template.dart';
import '../templates/design/creative_template.dart';
import '../templates/design/dark_template.dart';
import 'dart:typed_data';
import '../services/ats_pdf_exporter.dart';
import '../services/design_pdf_exporter.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show compute;
import '../services/pdf_export_isolate.dart';
import 'dart:convert';
import '../ads/rewarded_ad_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/member_service.dart';

class EditorPage extends StatefulWidget {
  final Resume? resume;
  const EditorPage({super.key, this.resume});

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  // ================================================================
  // 全局样式常量（可随时修改）
  // ================================================================

  // ---- 大标题样式 ----
  static const double _titleFontSize = 20.0;
  static const FontWeight _titleFontWeight = FontWeight.bold;
  static const Color _titleColor = Color.fromARGB(255, 254, 254, 255);

  // ---- 内容文字样式 ----
  static const double _contentFontSize = 14.0;
  static const Color _contentColor = Color.fromARGB(255, 252, 252, 252);
  static const double _contentLineHeight = 1.5;

  // ---- 标题与内容间距 ----
  static const double _sectionContentPadding = 4.0;

  // ---- 输入框样式 ----
  static const double _inputVerticalPadding = 10.0;
  static const double _inputHorizontalPadding = 8.0;
  static const Color _inputBorderColor = Color.fromARGB(255, 209, 205, 205);

  // ---- 标题背景色状态 ----
  static const Color _bgEdited = Color.fromARGB(255, 68, 91, 72);
  static const Color _bgEmpty = Color.fromARGB(255, 97, 101, 69);

  // ================================================================

  late Resume _currentResume;
  final _formKey = GlobalKey<FormState>();

  String _templateCategory = 'ats';
  String _designStyle = 'modern';
  bool _isGeneratingPdf = false; // 是否正在生成 PDF

  String? _pdfErrorMessage; // PDF 生成错误信息

  bool _isMember = false; // 是否为会员
  int _dailyExports = 0; // 今日已导出次数
  bool _showRewardedAd = false; // 是否显示激励视频按钮
  String _selectedStyle = 'modern'; // 当前选中的风格

  // ---- 模块展开状态 ----
  final Map<String, bool> _expandedMap = {
    'resumeName': true,
    'basicInfo': false,
    'workExp': false,
    'education': false,
    'project': false,
    'skills': false,
    'languages': false,
    'honors': false,
    'summary': false,
  };

  bool _isTemplateAvailable(String styleId) {
    return _isMember || styleId == 'modern';
  }

  @override
  void initState() {
    super.initState();
    print('🔵 EditorPage initState');

    if (widget.resume != null) {
      _currentResume = widget.resume!;
    } else {
      _currentResume = Resume(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: '',
        updatedAt: DateTime.now(),
        personal: PersonalInfo(
          fullName: '',
          jobTitle: '',
          phone: '',
          email: '',
        ),
        workExperiences: [],
        educations: [],
        skills: [],
        projects: [],
        summary: '',
      );
    }
  }

  // ============================================================
  // Web端头像选择
  // ============================================================
  void _pickAvatar() {
    final input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.multiple = false;
    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((e) {
          final bytes = reader.result as Uint8List?;
          if (bytes != null) {
            setState(() {
              _currentResume.personal.avatarImage = bytes;
            });
          }
        });
      }
      input.value = null;
    });
    input.click();
  }

  void _saveAndClose() async {
    if (_formKey.currentState!.validate()) {
      _currentResume.updatedAt = DateTime.now();
      await ResumeStorage.saveResume(_currentResume);
      print('✅ 数据已保存，返回列表页');
      context.pop();
    }
  }

  Future<void> _loadUserStatus() async {
    // TODO: 从 CloudBase 获取会员状态
    // 临时模拟
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toLocal().toString().substring(0, 10);
    final lastDate = prefs.getString('lastExportDate') ?? '';
    final count = prefs.getInt('dailyExports') ?? 0;

    setState(() {
      _isMember = false; // 默认免费
      _dailyExports = lastDate == today ? count : 0;
      _showRewardedAd = !_isMember && _dailyExports >= 3;
    });
  }

  Future<void> _handleRewardedExport() async {
    // 增加导出次数
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toLocal().toString().substring(0, 10);
    await prefs.setString('lastExportDate', today);
    await prefs.setInt('dailyExports', _dailyExports + 1);
    setState(() {
      _dailyExports++;
    });
    // 执行导出
    _exportPdf();
  }

  // 在 _loadMemberStatus 中
  /* Future<void> _loadMemberStatus() async {
    print('🔵 _loadMemberStatus 开始');
    try {
      final member = await MemberService.getMemberInfo();
      print('🔵 获取会员信息: $member');
      setState(() {
        _isMember = member?.isPremium ?? false;
      });
      print('🔵 _loadMemberStatus 完成，会员状态: $_isMember');
    } catch (e) {
      print('🔴 _loadMemberStatus 错误: $e');
      // 如果此处有 pop，会打印
      setState(() {
        _isMember = false;
      });
    }
  }*/

  // ================================================================
  // ★★★ 修改：PDF 导出（先预览，确认后再导出） ★★★
  // ================================================================
  void _exportPdf() async {
    // ---- 前置检查（内容过多提醒） ----
    final totalItems = _countResumeItems(_currentResume);
    const int maxItemsPerPage = 9;
    if (totalItems > maxItemsPerPage) {
      final shouldContinue = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('内容较多，建议精简'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '当前简历包含 $totalItems 个模块（教育经历、工作经历、项目经验等），',
                style: const TextStyle(fontSize: 14),
              ),
              const Text(
                '单页 PDF 可能无法完整显示所有内容。',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              const Text(
                '建议：精简内容或分多份简历导出。',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('继续导出'),
            ),
          ],
        ),
      );
      if (shouldContinue != true) {
        return;
      }
    }
    // 显示加载

    setState(() {
      _isGeneratingPdf = true;
      _pdfErrorMessage = null;
    });

    try {
      final autoScale = DesignPdfExporter.getAutoScaleFactor(_currentResume);
      double manualScale = autoScale.clamp(0.5, 1.8);
      final TextEditingController _controller = TextEditingController(
        text: manualScale.toStringAsFixed(2),
      );
      // 将 Resume 转为 JSON 字符串
      final resumeJsonStr = jsonEncode(_currentResume.toJson());

      final params = {
        'resumeJson': resumeJsonStr, // 传递字符串
        'style': 'modern',
        'scaleFactor': autoScale,
      };

      // 在 isolate 中生成 PDF
      final bytes = await compute(generatePdfInIsolate, params);

      // ✅ 关闭加载遮罩
      if (mounted) {
        setState(() {
          _isGeneratingPdf = false;
        });
      }

      // 弹出预览对话框（原有逻辑）

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // ★ 状态变量（持久化）
          Uint8List? previewBytes = bytes;
          bool isGenerating = false;
          bool _isInitialized = false;
          var previewKey = UniqueKey();
          String errorMessage = '';

          return StatefulBuilder(
            builder: (context, setState) {
              // ★ 生成预览（带缩放参数）
              Future<void> generatePreview({double? scale}) async {
                if (isGenerating) return;
                isGenerating = true;

                try {
                  final double effectiveScale = scale ?? autoScale;
                  debugPrint('🔄 生成预览，缩放: $effectiveScale');
                  // ★ 关键：将缩放值传递给 _generatePdfBytes
                  final bytes = await _generatePdfBytes(
                    scaleFactor: effectiveScale,
                  );
                  debugPrint('✅ 预览生成成功，字节数: ${bytes.length}');
                  if (context.mounted) {
                    setState(() {
                      previewBytes = bytes;
                      errorMessage = '';
                      previewKey = UniqueKey(); // 强制重建
                    });
                  }
                } catch (e) {
                  debugPrint('❌ 预览生成失败: $e');
                  if (context.mounted) {
                    setState(() {
                      errorMessage = '预览生成失败: $e';
                      previewBytes = null;
                    });
                  }
                } finally {
                  isGenerating = false;
                  _isInitialized = true;
                }
              }

              // 初始化预览（使用自动缩放）
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!_isInitialized && context.mounted) {
                  debugPrint('🚀 首次生成预览，自动缩放: $autoScale');
                  generatePreview();
                }
              });

              // ★ 缩放控件：变化时重新生成预览
              void _updateScale(String value) {
                final newScale = double.tryParse(value);
                if (newScale != null && newScale >= 0.5 && newScale <= 1.8) {
                  manualScale = newScale;
                  _controller.text = manualScale.toStringAsFixed(2);
                  // 重新生成预览，使用新的缩放值
                  generatePreview(scale: manualScale);
                } else {
                  _controller.text = manualScale.toStringAsFixed(2);
                }
              }

              // 步进按钮回调
              void _stepScale(double delta) {
                final newVal = (manualScale + delta).clamp(0.5, 1.8);
                manualScale = newVal;
                _controller.text = manualScale.toStringAsFixed(2);
                generatePreview(scale: manualScale);
              }

              final screenWidth = MediaQuery.of(context).size.width;
              final screenHeight = MediaQuery.of(context).size.height;
              final previewWidth = (screenWidth * 0.9).clamp(300.0, 800.0);
              final previewHeight = (screenHeight * 0.8 - 150).clamp(
                200.0,
                600.0,
              );

              Widget previewWidget;
              if (errorMessage.isNotEmpty) {
                previewWidget = Container(
                  width: previewWidth,
                  height: previewHeight,
                  color: Colors.red.shade50,
                  child: Center(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else if (previewBytes != null) {
                previewWidget = Container(
                  width: previewWidth,
                  height: previewHeight,
                  child: PdfPreview(
                    key: previewKey,
                    build: (format) {
                      debugPrint(
                        '🔥🔥🔥 PdfPreview build 被调用，字节数: ${previewBytes!.length}',
                      );
                      return previewBytes!;
                    },
                    allowSharing: true,
                    allowPrinting: true,
                    onError: (context, error) {
                      debugPrint('PdfPreview 渲染错误: $error');
                      return Container(
                        color: Colors.red.shade50,
                        child: Center(
                          child: Text(
                            'PDF 渲染错误: $error',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                previewWidget = SizedBox(
                  width: previewWidth,
                  height: previewHeight,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              return AlertDialog(
                title: const Text('📄 PDF 预览（可调节字号）'),
                content: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: screenHeight * 0.8,
                    maxWidth: screenWidth * 0.9,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ---- 缩放控件 ----
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('字号缩放：'),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 80,
                            child: TextField(
                              controller: _controller,
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              textAlign: TextAlign.center,
                              textInputAction:
                                  TextInputAction.done, // ✅ 键盘显示“完成”
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                              ),

                              onSubmitted: _updateScale,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('x'),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => _stepScale(-0.01),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _stepScale(0.01),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      previewWidget,
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // ✅ 关闭前释放内存
                      setState(() {
                        previewBytes = null;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('取消'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final bytes = await _generatePdfBytes(
                          scaleFactor: manualScale,
                        );
                        await _performExport(bytes);
                        // ✅ 导出后释放内存
                        setState(() {
                          previewBytes = null;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('PDF 导出成功')),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        // 错误处理...
                      }
                    },
                    child: const Text('导出'),
                  ),
                ],
              );
            },
          );
        },
      );
      if (!_isMember) {
        final prefs = await SharedPreferences.getInstance();
        final today = DateTime.now().toLocal().toString().substring(0, 10);
        await prefs.setString('lastExportDate', today);
        await prefs.setInt('dailyExports', _dailyExports + 1);
        setState(() {
          _dailyExports++;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGeneratingPdf = false;
          _pdfErrorMessage = 'PDF 生成失败：$e';
        });
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('PDF 生成失败：$e')));
      print('PDF导出错误: $e');
    }
  }

  /// 生成 PDF 字节
  Future<Uint8List> _generatePdfBytes({double? scaleFactor}) async {
    if (_templateCategory == 'ats') {
      return await AtsPdfExporter.generateatsPdf(
        _currentResume,
        userScale: scaleFactor,
      );
    } else {
      return await DesignPdfExporter.generateDesignPdf(
        _currentResume,
        _designStyle,
        userScale: scaleFactor, // 确保这一行存在
      );
    }
  }

  /// 执行实际导出（Web 下载或移动端分享）
  Future<void> _performExport(Uint8List bytes) async {
    if (kIsWeb) {
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', '${_currentResume.name}_简历.pdf')
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      await Printing.sharePdf(
        bytes: bytes,
        filename: '${_currentResume.name}_简历.pdf',
      );
    }
  }

  int _countResumeItems(Resume resume) {
    int count = 0;
    if (resume.educations.isNotEmpty) count += resume.educations.length;
    if (resume.workExperiences.isNotEmpty)
      count += resume.workExperiences.length;
    if (resume.projects.isNotEmpty) count += resume.projects.length;
    if (resume.skills.isNotEmpty) count += 1;
    if (resume.honors.isNotEmpty) count += 1;
    if (resume.languages.isNotEmpty) count += 1;
    if (resume.summary.isNotEmpty) count += 1;
    return count;
  }

  // ---- 各种添加/编辑/删除方法（保持不变） ----
  void _addWorkExperience() {
    final newExp = WorkExperience(
      company: '',
      position: '',
      startDate: DateTime.now(),
      endDate: null,
      description: '',
      achievements: [],
    );
    showDialog(
      context: context,
      builder: (ctx) => _WorkExperienceDialog(
        workExp: newExp,
        onSave: (exp) {
          setState(() {
            _currentResume.workExperiences.add(exp);
          });
        },
      ),
    );
  }

  void _editWorkExperience(int index) {
    showDialog(
      context: context,
      builder: (ctx) => _WorkExperienceDialog(
        workExp: _currentResume.workExperiences[index],
        onSave: (exp) {
          setState(() {
            _currentResume.workExperiences[index] = exp;
          });
        },
      ),
    );
  }

  void _deleteWorkExperience(int index) {
    setState(() {
      _currentResume.workExperiences.removeAt(index);
    });
  }

  void _addEducation() {
    final newEdu = Education(
      school: '',
      degree: '',
      startDate: DateTime.now(),
      endDate: null,
      description: '',
    );
    showDialog(
      context: context,
      builder: (ctx) => _EducationDialog(
        education: newEdu,
        onSave: (edu) {
          setState(() {
            _currentResume.educations.add(edu);
          });
        },
      ),
    );
  }

  void _editEducation(int index) {
    showDialog(
      context: context,
      builder: (ctx) => _EducationDialog(
        education: _currentResume.educations[index],
        onSave: (edu) {
          setState(() {
            _currentResume.educations[index] = edu;
          });
        },
      ),
    );
  }

  void _deleteEducation(int index) {
    setState(() {
      _currentResume.educations.removeAt(index);
    });
  }

  void _addSkill() {
    showDialog(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('添加技能'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: '技能名称'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('取消')),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _currentResume.skills.add(Skill(name: controller.text));
                  });
                }
                Navigator.pop(ctx);
              },
              child: Text('添加'),
            ),
          ],
        );
      },
    );
  }

  void _deleteSkill(int index) {
    setState(() {
      _currentResume.skills.removeAt(index);
    });
  }

  void _addProject() {
    showDialog(
      context: context,
      builder: (ctx) => _ProjectDialog(
        project: Project(name: '', role: '', description: '', technologies: []),
        onSave: (proj) {
          setState(() {
            _currentResume.projects.add(proj);
          });
        },
      ),
    );
  }

  void _editProject(int index) {
    showDialog(
      context: context,
      builder: (ctx) => _ProjectDialog(
        project: _currentResume.projects[index],
        onSave: (proj) {
          setState(() {
            _currentResume.projects[index] = proj;
          });
        },
      ),
    );
  }

  void _deleteProject(int index) {
    setState(() {
      _currentResume.projects.removeAt(index);
    });
  }

  void _addHonor() {
    showDialog(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('添加荣誉奖励'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: '荣誉奖励名称',
              hintText: '如：国家奖学金、优秀毕业生',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  setState(() {
                    _currentResume.honors.add(name);
                  });
                }
                Navigator.pop(ctx);
              },
              child: const Text('添加'),
            ),
          ],
        );
      },
    );
  }

  void _deleteHonor(int index) {
    setState(() {
      _currentResume.honors.removeAt(index);
    });
  }

  void _editHonor(int index) {
    final oldValue = _currentResume.honors[index];
    showDialog(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController(text: oldValue);
        return AlertDialog(
          title: const Text('编辑荣誉奖励'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: '荣誉奖励名称'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  setState(() {
                    _currentResume.honors[index] = name;
                  });
                }
                Navigator.pop(ctx);
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }

  void _addLanguage() {
    showDialog(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('添加语言能力'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: '语言名称',
              hintText: '如：英语、日语、粤语',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  setState(() {
                    _currentResume.languages = List.from(
                      _currentResume.languages,
                    );
                    _currentResume.languages.add(name);
                  });
                }
                Navigator.pop(ctx);
              },
              child: const Text('添加'),
            ),
          ],
        );
      },
    );
  }

  void _deleteLanguage(int index) {
    setState(() {
      _currentResume.languages.removeAt(index);
    });
  }

  void _editLanguage(int index) {
    final oldValue = _currentResume.languages[index];
    showDialog(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController(text: oldValue);
        return AlertDialog(
          title: const Text('编辑语言能力'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: '语言名称'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  setState(() {
                    _currentResume.languages[index] = name;
                  });
                }
                Navigator.pop(ctx);
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _polishSummary() async {
    final text = _currentResume.summary;
    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先输入需要润色的内容')));
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('AI正在润色，请稍候...')));
    try {
      final polished = await AiPolishService.polishText(text);
      setState(() => _currentResume.summary = polished);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('✅ 润色完成！')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ 润色失败: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('编辑简历'),
          leading: IconButton(
            icon: Icon(CupertinoIcons.back),
            onPressed: () => context.pop(),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: '编辑'),
              Tab(text: '预览'),
            ],
          ),
          actions: [TextButton(onPressed: _saveAndClose, child: Text('保存'))],
        ),
        body: Stack(
          children: [
            // 原有的 TabBarView
            TabBarView(children: [_buildEditorForm(), _buildPreviewTab()]),

            // ---- 加载遮罩 ----
            if (_isGeneratingPdf)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        '正在生成 PDF...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            if (_pdfErrorMessage != null)
              Container(
                color: Colors.red.withOpacity(0.1),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _pdfErrorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _pdfErrorMessage = null;
                          });
                        },
                        child: const Text('关闭'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportButton() {
    // 会员用户：直接导出，无限制
    if (_isMember) {
      return ElevatedButton.icon(
        onPressed: _exportPdf,
        icon: const Icon(Icons.picture_as_pdf, size: 22),
        label: const Text(
          '导出 PDF',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          minimumSize: const Size(150, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }

    // 免费用户：检查今日导出次数
    final remaining = 1 - _dailyExports;

    // 次数用尽 → 显示激励视频按钮
    if (remaining <= 0) {
      return RewardedAdButton(
        onRewarded: _handleRewardedExport,
        label: '观看广告获取导出机会',
        icon: Icons.play_circle_filled,
      );
    }

    // 还有剩余次数 → 显示普通导出按钮（带剩余次数提示）
    return ElevatedButton.icon(
      onPressed: _exportPdf,
      icon: const Icon(Icons.picture_as_pdf, size: 22),
      label: Text(
        '导出 PDF (剩余 $remaining 次)',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        minimumSize: const Size(150, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildPreviewTab() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCategoryButton('ats', 'ATS模板', Icons.description),
            const SizedBox(width: 16),
            _buildCategoryButton('design', '设计模板', Icons.palette),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: _templateCategory == 'ats'
                  ? _buildTemplateWidget()
                  : Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  12,
                                  16,
                                  4,
                                ),
                                child: Row(
                                  children: [
                                    const Text(
                                      '风格：',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _buildStyleChip('modern', '现代'),
                                    const SizedBox(width: 4),
                                    _buildStyleChip('classic', '经典'),
                                    const SizedBox(width: 4),
                                    _buildStyleChip('creative', '创意'),
                                    const SizedBox(width: 4),
                                    _buildStyleChip('dark', '深色'),
                                  ],
                                ),
                              ),
                              const Divider(height: 1, thickness: 1),
                              Expanded(child: _buildTemplateWidget()),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: _buildExportButton(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryButton(String value, String label, IconData icon) {
    final isSelected = _templateCategory == value;
    return ElevatedButton(
      onPressed: () => setState(() {
        _templateCategory = value;
        if (value == 'design' && _designStyle.isEmpty) {
          _designStyle = 'modern';
        }
      }),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).primaryColor
            : Colors.grey.shade300,
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 18), const SizedBox(width: 6), Text(label)],
      ),
    );
  }

  Widget _buildStyleChip(String value, String label) {
    final isSelected = _designStyle == value;
    final isAvailable = _isTemplateAvailable(value); // ✅ 使用方法
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) {
          // 无论是否可用，都切换选中状态（布局不变）
          setState(() {
            _designStyle = value;
          });
          // 如果模板可用，重新生成预览（但免费用户点击“现代”以外时，预览区会自动显示锁定遮罩）
          if (isAvailable) {
            _regeneratePreviewWithStyle(value); // 需要实现此方法
          }
          // 如果不可用，不重新生成，预览区会因 _isTemplateAvailable 为 false 而显示锁定遮罩
        }
      },
      selectedColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.grey.shade200,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      avatar: isAvailable
          ? null
          : const Icon(Icons.lock, size: 14, color: Colors.grey),
    );
  }

  Widget _buildTemplateWidget() {
    if (_templateCategory == 'ats') {
      return AtsTemplate(resume: _currentResume);
    } else {
      switch (_designStyle) {
        case 'modern':
          return ModernTemplate(resume: _currentResume);
        case 'classic':
          return ClassicTemplate(resume: _currentResume);
        case 'creative':
          return CreativeTemplate(resume: _currentResume);
        case 'dark':
          return DarkTemplate(resume: _currentResume);
        default:
          return ModernTemplate(resume: _currentResume);
      }
    }
  }

  /* Widget _buildLockedOverlay() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              '🔒 模板已锁定',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '升级会员解锁全部 4 套模板',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            const Text(
              '• PDF 无水印导出\n• 导出次数无限制\n• 100MB 云存储空间',
              style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.push('/member_center'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // 蓝色背景
                foregroundColor: Colors.white, // 白色文字
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('去升级', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }*/

  Future<void> _regeneratePreviewWithStyle(String style) async {
    // 重新生成对应风格的 PDF 预览（如果尚未实现）
    // 具体代码略，但可根据已有导出逻辑实现
  }

  // ================================================================
  // 核心：构建带标题栏和展开功能的模块
  // ================================================================
  Widget _buildSection({
    required String key,
    required String title,
    required IconData icon,
    required Widget content,
    bool hasContent = false,
    Widget? addButton,
  }) {
    final isExpanded = _expandedMap[key] ?? true;
    final bgColor = hasContent
        ? _bgEdited.withOpacity(0.7)
        : _bgEmpty.withOpacity(0.7);

    Widget trailingWidget;
    if (addButton != null) {
      trailingWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          addButton,
          IconButton(
            icon: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: _titleColor,
            ),
            onPressed: () {
              setState(() {
                _expandedMap[key] = !isExpanded;
              });
            },
          ),
        ],
      );
    } else {
      trailingWidget = IconButton(
        icon: Icon(
          isExpanded ? Icons.expand_less : Icons.expand_more,
          color: _titleColor,
        ),
        onPressed: () {
          setState(() {
            _expandedMap[key] = !isExpanded;
          });
        },
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: ListTile(
              leading: Icon(icon, color: _titleColor),
              title: Text(
                title,
                style: TextStyle(
                  fontWeight: _titleFontWeight,
                  fontSize: _titleFontSize,
                  color: _titleColor,
                ),
              ),
              trailing: trailingWidget,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Padding(
                    padding: EdgeInsets.all(_sectionContentPadding),
                    child: content,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // 编辑表单
  // ================================================================
  Widget _buildEditorForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ---- 简历名称 ----
            _buildSection(
              key: 'resumeName',
              title: '简历名称',
              icon: Icons.description,
              hasContent: _currentResume.name.isNotEmpty,
              content: Row(
                children: [
                  const Text(
                    '简历名称：',
                    style: TextStyle(
                      fontSize: _contentFontSize,
                      color: _contentColor,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: _currentResume.name,
                      decoration: _inputDecoration(hintText: '请输入简历名称'),
                      style: TextStyle(
                        fontSize: _contentFontSize,
                        color: _contentColor,
                      ),
                      onChanged: (v) {
                        setState(() {
                          _currentResume.name = v;
                        });
                      },
                      validator: (v) => v!.isEmpty ? '请输入简历名称' : null,
                    ),
                  ),
                ],
              ),
            ),

            // ---- 基本信息 ----
            _buildSection(
              key: 'basicInfo',
              title: '基本信息',
              icon: Icons.person,
              hasContent:
                  _currentResume.personal.fullName.isNotEmpty ||
                  _currentResume.personal.jobTitle.isNotEmpty ||
                  _currentResume.personal.phone.isNotEmpty ||
                  _currentResume.personal.email.isNotEmpty ||
                  _currentResume.personal.expectedCity.isNotEmpty ||
                  _currentResume.personal.salaryExpectation.isNotEmpty ||
                  _currentResume.personal.availableDate.isNotEmpty,
              content: LayoutBuilder(
                builder: (context, constraints) {
                  const double avatarWidth = 100.0;
                  double fieldWidth = constraints.maxWidth - avatarWidth - 16;
                  double itemWidth = (fieldWidth - 16) / 3;

                  List<Widget> fieldWidgets = [
                    _buildInfoFieldInline(
                      '姓名',
                      _currentResume.personal.fullName,
                      (v) {
                        _currentResume.personal.fullName = v;
                      },
                      width: itemWidth,
                    ),
                    _buildInfoFieldInline(
                      '求职意向',
                      _currentResume.personal.jobTitle,
                      (v) {
                        _currentResume.personal.jobTitle = v;
                      },
                      width: itemWidth,
                    ),
                    _buildInfoFieldInline(
                      '入职时间',
                      _currentResume.personal.availableDate,
                      (v) {
                        _currentResume.personal.availableDate = v;
                      },
                      width: itemWidth,
                    ),
                    _buildInfoFieldInline('邮箱', _currentResume.personal.email, (
                      v,
                    ) {
                      _currentResume.personal.email = v;
                    }, width: itemWidth),
                    _buildInfoFieldInline(
                      '意向城市',
                      _currentResume.personal.expectedCity,
                      (v) {
                        _currentResume.personal.expectedCity = v;
                      },
                      width: itemWidth,
                    ),
                    _buildInfoFieldInline(
                      '薪资要求',
                      _currentResume.personal.salaryExpectation,
                      (v) {
                        _currentResume.personal.salaryExpectation = v;
                      },
                      width: itemWidth,
                    ),
                    _buildInfoFieldInline('电话', _currentResume.personal.phone, (
                      v,
                    ) {
                      _currentResume.personal.phone = v;
                    }, width: itemWidth),

                    _buildInfoFieldInline(
                      '出生年月',
                      _currentResume.personal.birthDate ?? '',
                      (v) {
                        _currentResume.personal.birthDate = v;
                      },
                      width: itemWidth,
                    ),
                    _buildInfoFieldInline(
                      '籍贯',
                      _currentResume.personal.birthPlace ?? '',
                      (v) {
                        _currentResume.personal.birthPlace = v;
                      },
                      width: itemWidth,
                    ),
                    _buildInfoFieldInline(
                      '政治面貌',
                      _currentResume.personal.politicalStatus ?? '',
                      (v) {
                        _currentResume.personal.politicalStatus = v;
                      },
                      width: itemWidth,
                    ),
                    _buildInfoFieldInline(
                      '性别',
                      _currentResume.personal.gender ?? '',
                      (v) {
                        _currentResume.personal.gender = v;
                      },
                      width: itemWidth,
                    ),
                    _buildInfoFieldInline(
                      '民族',
                      _currentResume.personal.nation ?? '',
                      (v) {
                        _currentResume.personal.nation = v;
                      },
                      width: itemWidth,
                    ),
                  ];

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: fieldWidgets,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: _pickAvatar,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey.shade300,
                                backgroundImage:
                                    _currentResume.personal.avatarImage != null
                                    ? MemoryImage(
                                        _currentResume.personal.avatarImage!,
                                      )
                                    : null,
                                child:
                                    _currentResume.personal.avatarImage == null
                                    ? const Icon(
                                        Icons.add_a_photo,
                                        size: 30,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (_currentResume.personal.avatarImage != null)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _currentResume.personal.avatarImage = null;
                                  });
                                },
                                child: const Text(
                                  '移除',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // ---- 工作经历 ----
            _buildSection(
              key: 'workExp',
              title: '工作经历',
              icon: Icons.work,
              hasContent: _currentResume.workExperiences.isNotEmpty,
              addButton: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 254, 254, 255),
                ),
                onPressed: _addWorkExperience,
                tooltip: '添加工作经历',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildWorkExperienceList(),
              ),
            ),

            // ---- 教育经历 ----
            _buildSection(
              key: 'education',
              title: '教育经历',
              icon: Icons.school,
              hasContent: _currentResume.educations.isNotEmpty,
              addButton: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 254, 254, 255),
                ),
                onPressed: _addEducation,
                tooltip: '添加教育经历',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildEducationList(),
              ),
            ),

            // ---- 项目经验 ----
            _buildSection(
              key: 'project',
              title: '项目经验',
              icon: Icons.code,
              hasContent: _currentResume.projects.isNotEmpty,
              addButton: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 254, 254, 255),
                ),
                onPressed: _addProject,
                tooltip: '添加项目经验',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildProjectList(),
              ),
            ),

            // ---- 技能 ----
            _buildSection(
              key: 'skills',
              title: '技能',
              icon: Icons.build,
              hasContent: _currentResume.skills.isNotEmpty,
              addButton: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 254, 254, 255),
                ),
                onPressed: _addSkill,
                tooltip: '添加技能',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _currentResume.skills.asMap().entries.map((
                      entry,
                    ) {
                      int idx = entry.key;
                      Skill skill = entry.value;
                      return Chip(
                        label: Text(
                          skill.name,
                          style: TextStyle(
                            fontSize: _contentFontSize,
                            color: _contentColor,
                          ),
                        ),
                        deleteIcon: const Icon(CupertinoIcons.clear, size: 18),
                        onDeleted: () => _deleteSkill(idx),
                      );
                    }).toList(),
                  ),
                  if (_currentResume.skills.isEmpty)
                    Text(
                      '暂无技能，点击右上角➕添加',
                      style: TextStyle(
                        fontSize: _contentFontSize,
                        color: _contentColor.withOpacity(0.6),
                      ),
                    ),
                ],
              ),
            ),

            // ---- 语言能力 ----
            _buildSection(
              key: 'languages',
              title: '语言能力',
              icon: Icons.translate,
              hasContent: _currentResume.languages.isNotEmpty,
              addButton: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 254, 254, 255),
                ),
                onPressed: _addLanguage,
                tooltip: '添加语言',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_currentResume.languages.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _currentResume.languages.asMap().entries.map((
                        entry,
                      ) {
                        int idx = entry.key;
                        String lang = entry.value;
                        return GestureDetector(
                          onTap: () => _editLanguage(idx),
                          child: Chip(
                            label: Text(
                              lang,
                              style: TextStyle(
                                fontSize: _contentFontSize,
                                color: _contentColor,
                              ),
                            ),
                            deleteIcon: const Icon(
                              CupertinoIcons.clear,
                              size: 18,
                            ),
                            onDeleted: () => _deleteLanguage(idx),
                          ),
                        );
                      }).toList(),
                    )
                  else
                    Text(
                      '暂无语言能力，点击右上角➕添加',
                      style: TextStyle(
                        fontSize: _contentFontSize,
                        color: _contentColor.withOpacity(0.6),
                      ),
                    ),
                ],
              ),
            ),

            // ---- 荣誉奖励 ----
            _buildSection(
              key: 'honors',
              title: '荣誉奖励',
              icon: Icons.emoji_events,
              hasContent: _currentResume.honors.isNotEmpty,
              addButton: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 254, 254, 255),
                ),
                onPressed: _addHonor,
                tooltip: '添加荣誉',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_currentResume.honors.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _currentResume.honors.asMap().entries.map((
                        entry,
                      ) {
                        int idx = entry.key;
                        String honor = entry.value;
                        return GestureDetector(
                          onTap: () => _editHonor(idx),
                          child: Chip(
                            label: Text(
                              honor,
                              style: TextStyle(
                                fontSize: _contentFontSize,
                                color: _contentColor,
                              ),
                            ),
                            deleteIcon: const Icon(
                              CupertinoIcons.clear,
                              size: 18,
                            ),
                            onDeleted: () => _deleteHonor(idx),
                          ),
                        );
                      }).toList(),
                    )
                  else
                    Text(
                      '暂无荣誉奖励，点击右上角➕添加',
                      style: TextStyle(
                        fontSize: _contentFontSize,
                        color: _contentColor.withOpacity(0.6),
                      ),
                    ),
                ],
              ),
            ),

            // ---- 个人总结 ----
            _buildSection(
              key: 'summary',
              title: '个人总结',
              icon: Icons.summarize,
              hasContent: _currentResume.summary.isNotEmpty,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _polishSummary,
                        icon: const Icon(Icons.auto_awesome, size: 18),
                        label: const Text('AI润色'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    initialValue: _currentResume.summary,
                    minLines: 2,
                    maxLines: 10,
                    decoration: _inputDecoration(
                      hintText: '请输入个人总结（如：具备X年经验，擅长...）',
                    ),
                    style: TextStyle(
                      fontSize: _contentFontSize,
                      color: _contentColor,
                      height: _contentLineHeight,
                    ),
                    onChanged: (v) =>
                        setState(() => _currentResume.summary = v),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- 辅助：输入框装饰 ----
  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        horizontal: _inputHorizontalPadding,
        vertical: _inputVerticalPadding,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: _inputBorderColor.withOpacity(0.5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _inputBorderColor.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _inputBorderColor, width: 1.2),
      ),
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: _contentFontSize,
        color: _contentColor.withOpacity(0.4),
      ),
      isDense: true,
    );
  }

  // ---- 构建单个“标签：输入框”字段 ----
  Widget _buildInfoFieldInline(
    String label,
    String initialValue,
    Function(String) onChanged, {
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          Text(
            '$label：',
            style: TextStyle(fontSize: _contentFontSize, color: _contentColor),
          ),
          Expanded(
            child: TextFormField(
              initialValue: initialValue,
              decoration: _inputDecoration(),
              style: TextStyle(
                fontSize: _contentFontSize,
                color: _contentColor,
              ),
              onChanged: (v) {
                setState(() {
                  onChanged(v);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---- 列表构建方法 ----
  List<Widget> _buildWorkExperienceList() {
    if (_currentResume.workExperiences.isEmpty) {
      return [
        Text(
          '暂无工作经历，点击右上角➕添加',
          style: TextStyle(
            fontSize: _contentFontSize,
            color: _contentColor.withOpacity(0.6),
          ),
        ),
      ];
    }
    return _currentResume.workExperiences.asMap().entries.map((entry) {
      int idx = entry.key;
      WorkExperience exp = entry.value;
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          title: Text(
            '${exp.position} @ ${exp.company}',
            style: TextStyle(
              fontSize: _contentFontSize,
              fontWeight: FontWeight.w500,
              color: _contentColor,
            ),
          ),
          subtitle: Text(
            '${exp.startDate.year} - ${exp.endDate?.year ?? '至今'}',
            style: TextStyle(
              fontSize: _contentFontSize * 0.9,
              color: _contentColor.withOpacity(0.7),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(CupertinoIcons.pencil),
                onPressed: () => _editWorkExperience(idx),
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.delete),
                onPressed: () => _deleteWorkExperience(idx),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildEducationList() {
    if (_currentResume.educations.isEmpty) {
      return [
        Text(
          '暂无教育经历，点击右上角➕添加',
          style: TextStyle(
            fontSize: _contentFontSize,
            color: _contentColor.withOpacity(0.6),
          ),
        ),
      ];
    }
    return _currentResume.educations.asMap().entries.map((entry) {
      int idx = entry.key;
      Education edu = entry.value;
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          title: Text(
            '${edu.degree} @ ${edu.school}',
            style: TextStyle(
              fontSize: _contentFontSize,
              fontWeight: FontWeight.w500,
              color: _contentColor,
            ),
          ),
          subtitle: Text(
            '${edu.startDate.year} - ${edu.endDate?.year ?? '至今'}',
            style: TextStyle(
              fontSize: _contentFontSize * 0.9,
              color: _contentColor.withOpacity(0.7),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(CupertinoIcons.pencil),
                onPressed: () => _editEducation(idx),
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.delete),
                onPressed: () => _deleteEducation(idx),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildProjectList() {
    if (_currentResume.projects.isEmpty) {
      return [
        Text(
          '暂无项目经验，点击右上角➕添加',
          style: TextStyle(
            fontSize: _contentFontSize,
            color: _contentColor.withOpacity(0.6),
          ),
        ),
      ];
    }
    return _currentResume.projects.asMap().entries.map((entry) {
      int idx = entry.key;
      Project proj = entry.value;
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          title: Text(
            proj.name,
            style: TextStyle(
              fontSize: _contentFontSize,
              fontWeight: FontWeight.w500,
              color: _contentColor,
            ),
          ),
          subtitle: proj.description.isNotEmpty
              ? Text(
                  proj.description,
                  style: TextStyle(
                    fontSize: _contentFontSize * 0.9,
                    color: _contentColor.withOpacity(0.7),
                  ),
                )
              : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(CupertinoIcons.pencil),
                onPressed: () => _editProject(idx),
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.delete),
                onPressed: () => _deleteProject(idx),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

// ================================================================
// 以下 Dialog 组件均未改动，请保留原样
// ================================================================

class _WorkExperienceDialog extends StatefulWidget {
  final WorkExperience workExp;
  final Function(WorkExperience) onSave;
  const _WorkExperienceDialog({required this.workExp, required this.onSave});

  @override
  __WorkExperienceDialogState createState() => __WorkExperienceDialogState();
}

class __WorkExperienceDialogState extends State<_WorkExperienceDialog> {
  late TextEditingController _companyController;
  late TextEditingController _positionController;
  late DateTime _startDate;
  late DateTime? _endDate;
  late TextEditingController _descController;
  bool _isPolishing = false;

  @override
  void initState() {
    super.initState();
    _companyController = TextEditingController(text: widget.workExp.company);
    _positionController = TextEditingController(text: widget.workExp.position);
    _startDate = widget.workExp.startDate;
    _endDate = widget.workExp.endDate;
    _descController = TextEditingController(text: widget.workExp.description);
  }

  Future<void> _polishDescription() async {
    final text = _descController.text;
    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先输入工作描述')));
      return;
    }
    setState(() => _isPolishing = true);
    try {
      final polished = await AiPolishService.polishText(text);
      setState(() => _descController.text = polished);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('✅ 润色完成！')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ 润色失败: $e')));
    } finally {
      setState(() => _isPolishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('工作经历'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _companyController,
              decoration: InputDecoration(labelText: '公司'),
            ),
            TextField(
              controller: _positionController,
              decoration: InputDecoration(labelText: '职位'),
            ),
            ListTile(
              title: Text(
                '开始日期: ${_startDate.toLocal().toString().split(' ')[0]}',
              ),
              trailing: Icon(CupertinoIcons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) setState(() => _startDate = date);
              },
            ),
            ListTile(
              title: Text(
                '结束日期: ${_endDate?.toLocal().toString().split(' ')[0] ?? '至今'}',
              ),
              trailing: Icon(CupertinoIcons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _endDate ?? DateTime.now(),
                  firstDate: _startDate,
                  lastDate: DateTime(2030),
                );
                if (date != null) setState(() => _endDate = date);
              },
            ),
            Row(
              children: [
                const Text('工作描述'),
                const Spacer(),
                TextButton.icon(
                  onPressed: _polishDescription,
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text('AI润色'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.purple,
                    minimumSize: const Size(0, 30),
                  ),
                ),
              ],
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: '工作描述',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('取消')),
        TextButton(
          onPressed: () {
            final updated = WorkExperience(
              company: _companyController.text,
              position: _positionController.text,
              startDate: _startDate,
              endDate: _endDate,
              description: _descController.text,
              achievements: widget.workExp.achievements,
            );
            widget.onSave(updated);
            Navigator.pop(context);
          },
          child: Text('保存'),
        ),
      ],
    );
  }
}

class _EducationDialog extends StatefulWidget {
  final Education education;
  final Function(Education) onSave;
  const _EducationDialog({required this.education, required this.onSave});

  @override
  __EducationDialogState createState() => __EducationDialogState();
}

class __EducationDialogState extends State<_EducationDialog> {
  late TextEditingController _schoolController;
  late TextEditingController _degreeController;
  late TextEditingController _majorController;
  late DateTime _startDate;
  late DateTime? _endDate;
  late TextEditingController _descController;
  bool _isPolishing = false;

  @override
  void initState() {
    super.initState();
    _schoolController = TextEditingController(text: widget.education.school);
    _degreeController = TextEditingController(text: widget.education.degree);
    _majorController = TextEditingController(text: widget.education.major);
    _startDate = widget.education.startDate;
    _endDate = widget.education.endDate;
    _descController = TextEditingController(text: widget.education.description);
  }

  Future<void> _polishDescription() async {
    final text = _descController.text;
    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先输入教育专业描述')));
      return;
    }
    setState(() => _isPolishing = true);
    try {
      final polished = await AiPolishService.polishText(text);
      setState(() => _descController.text = polished);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('✅ 润色完成！')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ 润色失败: $e')));
    } finally {
      setState(() => _isPolishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('教育经历'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _schoolController,
              decoration: InputDecoration(labelText: '学校'),
            ),
            TextField(
              controller: _majorController,
              decoration: InputDecoration(labelText: '专业'),
            ),
            TextField(
              controller: _degreeController,
              decoration: InputDecoration(labelText: '学位'),
            ),
            ListTile(
              title: Text(
                '开始日期: ${_startDate.toLocal().toString().split(' ')[0]}',
              ),
              trailing: Icon(CupertinoIcons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(1980),
                  lastDate: DateTime.now(),
                );
                if (date != null) setState(() => _startDate = date);
              },
            ),
            ListTile(
              title: Text(
                '结束日期: ${_endDate?.toLocal().toString().split(' ')[0] ?? '至今'}',
              ),
              trailing: Icon(CupertinoIcons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _endDate ?? DateTime.now(),
                  firstDate: _startDate,
                  lastDate: DateTime(2030),
                );
                if (date != null) setState(() => _endDate = date);
              },
            ),
            Row(
              children: [
                const Text('专业描述'),
                const Spacer(),
                TextButton.icon(
                  onPressed: _isPolishing ? null : _polishDescription,
                  icon: _isPolishing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.auto_awesome, size: 16),
                  label: Text(_isPolishing ? '润色中...' : 'AI润色'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.purple,
                    minimumSize: const Size(0, 30),
                  ),
                ),
              ],
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: '描述'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('取消')),
        TextButton(
          onPressed: () {
            final updated = Education(
              school: _schoolController.text,
              degree: _degreeController.text,
              startDate: _startDate,
              endDate: _endDate,
              description: _descController.text,
              major: _majorController.text,
            );
            widget.onSave(updated);
            Navigator.pop(context);
          },
          child: Text('保存'),
        ),
      ],
    );
  }
}

class _ProjectDialog extends StatefulWidget {
  final Project project;
  final Function(Project) onSave;
  const _ProjectDialog({required this.project, required this.onSave});

  @override
  __ProjectDialogState createState() => __ProjectDialogState();
}

class __ProjectDialogState extends State<_ProjectDialog> {
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _descController;
  bool _isPolishing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project.name);
    _roleController = TextEditingController(text: widget.project.role);
    _descController = TextEditingController(text: widget.project.description);
  }

  Future<void> _polishDescription() async {
    final text = _descController.text;
    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先输入项目描述')));
      return;
    }
    setState(() => _isPolishing = true);
    try {
      final polished = await AiPolishService.polishText(text);
      setState(() => _descController.text = polished);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('✅ 润色完成！')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ 润色失败: $e')));
    } finally {
      setState(() => _isPolishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('项目经验'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '项目名称'),
            ),
            TextField(
              controller: _roleController,
              decoration: InputDecoration(labelText: '角色'),
            ),
            Row(
              children: [
                const Text('项目描述'),
                const Spacer(),
                TextButton.icon(
                  onPressed: _isPolishing ? null : _polishDescription,
                  icon: _isPolishing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.auto_awesome, size: 16),
                  label: Text(_isPolishing ? '润色中...' : 'AI润色'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.purple,
                    minimumSize: const Size(0, 30),
                  ),
                ),
              ],
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: '项目描述'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('取消')),
        TextButton(
          onPressed: () {
            final updated = Project(
              name: _nameController.text,
              role: _roleController.text,
              description: _descController.text,
              technologies: [],
            );
            widget.onSave(updated);
            Navigator.pop(context);
          },
          child: Text('保存'),
        ),
      ],
    );
  }
}
