import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import '../models/resume.dart';
import '../models/work_experience.dart';
import '../models/education.dart';
import '../models/project.dart';


// ================================================================
// 现代模板配置类（ModernPdfConfig）
// ================================================================
class ModernPdfConfig {
  // ---- 左右栏比例 ----
  final int leftFlex; // 左栏宽度比例（百分比整数）
  final int rightFlex; // 右栏宽度比例（百分比整数）

  // ---- 内边距 ----
  final double leftPadding; // 左栏内边距（所有方向）
  final double rightPadding; // 右栏右侧内边距（仅右侧）

  // ---- 颜色 ----
  final PdfColor leftBgColor; // 左栏背景色（浅蓝）
  final PdfColor primaryColor; // 主题色（头像背景等）
  final PdfColor secondaryColor; // 辅助色（备用）
  final PdfColor textColor; // 文字颜色（黑色）
  final PdfColor backgroundColor; // 整体背景色（白色）

  // ---- 头像 ----
  final double avatarSize; // 头像直径
  final double avatarTextSize; // 无头像时首字母字号

  // ---- 左侧信息 ----
  final double leftInfoFontSize; // 基础信息字号
  final double leftInfoSpacing; // 信息项之间的垂直间距

  // ---- 左侧标题 ----
  final double leftTitleFontSize; // 标题字号
  final double leftTitleIconSize; // 标题图标字号

  // ---- 左侧标签（chip） ----
  final double leftChipFontSize; // 标签文字字号
  final double leftChipPaddingH; // 标签水平内边距
  final double leftChipPaddingV; // 标签垂直内边距
  final double leftChipRadius; // 标签圆角半径
  final double leftChipBorderWidth; // 标签边框宽度
  final PdfColor leftChipBgColor; // 标签背景色（半透明蓝）
  final PdfColor leftChipBorderColor; // 标签边框颜色

  // ---- 左侧荣誉标签 ----
  final double leftHonorChipFontSize; // 荣誉标签文字字号

  // ---- 右侧内容 ----
  final double rightNameFontSize; // 姓名字号
  final double rightJobTitleFontSize; // 求职意向标签字号（备用）
  final double rightChipFontSize; // 标签（意向职位/城市）字号
  final double rightTitleFontSize; // 各章节标题字号
  final double rightTitleIconSize; // 章节标题图标字号
  final double rightDividerWidth; // 标题下方分割线宽度
  final double rightDividerHeight; // 标题下方分割线高度

  // ---- 右侧各模块字号 ----
  final double rightEduFontSize; // 教育经历字号
  final double rightWorkFontSize; // 工作经历字号
  final double rightProjectFontSize; // 项目经验字号
  final double rightSummaryFontSize; // 自我评价字号
  final double rightDescFontSize; // 描述列表字号

  // ---- 右侧字重 ----
  final pw.FontWeight rightNameWeight; // 姓名字重
  final pw.FontWeight rightTitleWeight; // 标题字重
  final pw.FontWeight rightEduBoldWeight; // 教育经历加粗部分
  final pw.FontWeight rightWorkBoldWeight; // 工作经历加粗部分
  final pw.FontWeight rightProjectBoldWeight; // 项目经验加粗部分

  // ---- 间距 ----
  final double sectionSpacing; // 模块之间的间距
  final double itemSpacing; // 条目之间的间距（通用）
  final double eduItemSpacing; // 教育条目间距
  final double workItemSpacing; // 工作条目间距
  final double projectItemSpacing; // 项目条目间距

  const ModernPdfConfig({
    required this.leftFlex,
    required this.rightFlex,
    required this.leftPadding,
    required this.rightPadding,
    required this.leftBgColor,
    required this.avatarSize,
    required this.avatarTextSize,
    required this.leftInfoFontSize,
    required this.leftInfoSpacing,
    required this.leftTitleFontSize,
    required this.leftTitleIconSize,
    required this.leftChipFontSize,
    required this.leftChipPaddingH,
    required this.leftChipPaddingV,
    required this.leftChipRadius,
    required this.leftChipBorderWidth,
    required this.leftChipBgColor,
    required this.leftChipBorderColor,
    required this.leftHonorChipFontSize,
    required this.rightNameFontSize,
    required this.rightJobTitleFontSize,
    required this.rightChipFontSize,
    required this.rightTitleFontSize,
    required this.rightTitleIconSize,
    required this.rightDividerWidth,
    required this.rightDividerHeight,
    required this.rightEduFontSize,
    required this.rightWorkFontSize,
    required this.rightProjectFontSize,
    required this.rightSummaryFontSize,
    required this.rightDescFontSize,
    required this.rightNameWeight,
    required this.rightTitleWeight,
    required this.rightEduBoldWeight,
    required this.rightWorkBoldWeight,
    required this.rightProjectBoldWeight,
    required this.sectionSpacing,
    required this.itemSpacing,
    required this.eduItemSpacing,
    required this.workItemSpacing,
    required this.projectItemSpacing,
    required this.primaryColor,
    required this.secondaryColor,
    required this.textColor,
    required this.backgroundColor,
  });

  ModernPdfConfig scaled(double factor) {
    return ModernPdfConfig(
      // ---- 比例和颜色（保持不变） ----
      leftFlex: leftFlex,
      rightFlex: rightFlex,
      leftPadding: leftPadding * factor, // 内边距可缩放，也可不缩放，视需要
      rightPadding: rightPadding * factor,
      leftBgColor: leftBgColor,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      textColor: textColor,
      backgroundColor: backgroundColor,

      // ---- 头像（固定尺寸，不缩放） ----
      avatarSize: avatarSize,
      avatarTextSize: avatarTextSize, // 或可缩放，但通常头像首字母不大
      // ---- 左侧信息（字号和间距缩放） ----
      leftInfoFontSize: leftInfoFontSize * factor,
      leftInfoSpacing: leftInfoSpacing * factor,

      // ---- 左侧标题（字号缩放） ----
      leftTitleFontSize: leftTitleFontSize * factor,
      leftTitleIconSize: leftTitleIconSize * factor,

      // ---- 左侧标签（chip） ----
      leftChipFontSize: leftChipFontSize * factor,
      leftChipPaddingH: leftChipPaddingH * factor,
      leftChipPaddingV: leftChipPaddingV * factor,
      leftChipRadius: leftChipRadius * factor,
      leftChipBorderWidth: leftChipBorderWidth, // 边框宽度通常不缩放
      leftChipBgColor: leftChipBgColor,
      leftChipBorderColor: leftChipBorderColor,
      leftHonorChipFontSize: leftHonorChipFontSize * factor,

      // ---- 右侧内容（字号缩放） ----
      rightNameFontSize: rightNameFontSize * factor,
      rightJobTitleFontSize: rightJobTitleFontSize * factor,
      rightChipFontSize: rightChipFontSize * factor,
      rightTitleFontSize: rightTitleFontSize * factor,
      rightTitleIconSize: rightTitleIconSize * factor,
      rightDividerWidth: rightDividerWidth * factor,
      rightDividerHeight: rightDividerHeight * factor,

      rightEduFontSize: rightEduFontSize * factor,
      rightWorkFontSize: rightWorkFontSize * factor,
      rightProjectFontSize: rightProjectFontSize * factor,
      rightSummaryFontSize: rightSummaryFontSize * factor,
      rightDescFontSize: rightDescFontSize * factor,

      // ---- 字重（保持不变） ----
      rightNameWeight: rightNameWeight,
      rightTitleWeight: rightTitleWeight,
      rightEduBoldWeight: rightEduBoldWeight,
      rightWorkBoldWeight: rightWorkBoldWeight,
      rightProjectBoldWeight: rightProjectBoldWeight,

      // ---- 间距（缩放） ----
      sectionSpacing: sectionSpacing * factor,
      itemSpacing: itemSpacing * factor,
      eduItemSpacing: eduItemSpacing * factor,
      workItemSpacing: workItemSpacing * factor,
      projectItemSpacing: projectItemSpacing * factor,
    );
  }
}

ModernPdfConfig _getModernConfig() {
  return ModernPdfConfig(
    leftFlex: 35, // 左栏宽度百分比
    rightFlex: 65, // 右栏宽度百分比
    leftPadding: 14, // 左栏内边距
    rightPadding: 30, // 右栏右侧内边距
    leftBgColor: PdfColor(0.8, 0.9, 1.0), // 左栏浅蓝背景
    avatarSize: 130, // 头像直径
    avatarTextSize: 28, // 首字母字号
    leftInfoFontSize: 10, // 左侧信息字号
    leftInfoSpacing: 12, // 信息项间距
    leftTitleFontSize: 16, // 左侧标题字号
    leftTitleIconSize: 16, // 左侧标题图标字号
    leftChipFontSize: 10, // 左侧标签字号
    leftChipPaddingH: 10, // 标签水平内边距
    leftChipPaddingV: 3, // 标签垂直内边距
    leftChipRadius: 12, // 标签圆角
    leftChipBorderWidth: 1, // 标签边框宽度
    leftChipBgColor: PdfColors.blue200.withAlpha(0.5), // 标签背景色（半透明蓝）
    leftChipBorderColor: PdfColors.blue200, // 标签边框色
    leftHonorChipFontSize: 10, // 荣誉标签字号
    rightNameFontSize: 26, // 姓名字号
    rightJobTitleFontSize: 13, // （备用）
    rightChipFontSize: 11, // 意向标签字号
    rightTitleFontSize: 16, // 右侧标题字号
    rightTitleIconSize: 16, // 右侧标题图标
    rightDividerWidth: 380, // 分割线宽度
    rightDividerHeight: 0.5, // 分割线高度
    rightEduFontSize: 11, // 教育字号
    rightWorkFontSize: 11, // 工作字号
    rightProjectFontSize: 11, // 项目字号
    rightSummaryFontSize: 11, // 自我评价字号
    rightDescFontSize: 10, // 描述列表字号
    rightNameWeight: pw.FontWeight.bold, // 姓名加粗
    rightTitleWeight: pw.FontWeight.bold, // 标题加粗
    rightEduBoldWeight: pw.FontWeight.bold, // 教育加粗
    rightWorkBoldWeight: pw.FontWeight.bold, // 工作加粗
    rightProjectBoldWeight: pw.FontWeight.bold, // 项目加粗
    sectionSpacing: 10, // 模块间距
    itemSpacing: 8, // 通用条目间距
    eduItemSpacing: 6, // 教育条目间距
    workItemSpacing: 6, // 工作条目间距
    projectItemSpacing: 6, // 项目条目间距
    primaryColor: PdfColors.blue800, // 主题色
    secondaryColor: PdfColors.amber700, // 辅助色
    textColor: PdfColors.black, // 文字颜色
    backgroundColor: PdfColors.white, // 背景色
  );
}

// ================================================================
// 创意模板配置类（CreativePdfConfig）
// ================================================================

class CreativePdfConfig {
  // ---- 头部相关 ----
  final PdfColor headerBgColor; // 头部背景色（深蓝 #062844）
  final double avatarRadius; // 头像半径
  final double headerSpacing; // 头像与右侧文字间距
  final double headerInfoLeftPadding; // 姓名/信息左内边距（右移距离）
  final double headerColumnsSpacing; // 基础信息两列之间的间距
  final double headerNameFontSize; // 姓名字号
  final double headerInfoFontSize; // 基础信息字号

  // ---- 标题装饰相关 ----
  final double titleHeight; // 标题栏高度
  final double titlePaddingHorizontal; // 标题文字左右内边距
  final double titleLineLength; // 标题下方横线长度
  final double rightTriangleHorizontal; // 右侧三角形水平直角边
  final double rightTriangleVertical; // 右侧三角形垂直直角边
  final double leftTriangleHorizontal; // 左侧三角形水平直角边
  final double leftTriangleVertical; // 左侧三角形垂直直角边
  final double strokeWidth; // 标题边框/三角形描边宽度
  final PdfColor titleBgColor; // 标题背景色
  final double titleBackgroundWidth;

  // ---- 内容区域 ----
  final double contentLeftPadding; // 章节内容左侧缩进
  final double contentVerticalPadding; // 内容区域上下内边距

  // ---- 贯穿竖线 ----
  final double verticalLineWidth; // 竖线宽度
  final double verticalLineLeftOffset; // 竖线水平偏移（向右为正）
  final double verticalLineStartOffset; // 竖线起始垂直偏移（向下为正）
  final PdfColor verticalLineColor; // 竖线颜色

  // ---- 间距 ----
  final double headerBottomSpacing; // 头部与内容间距
  final double workPositionSpacing; // 工作经历：公司与职位间距
  final double projectRoleSpacing; // 项目经验：项目名与角色间距

  // ---- 各模块字号 ----
  final double intentChipLabelFontSize; // 求职意向标签文字字号
  final double intentChipValueFontSize; // 求职意向值文字字号
  final double eduFontSize; // 教育经历字号
  final double workFontSize; // 工作经历字号
  final double projectFontSize; // 项目经验字号
  final double honorFontSize; // 荣誉奖励字号
  final double skillFontSize; // 技能特长字号
  final double summaryFontSize; // 自我评价字号
  final double descFontSize; // 描述列表字号
  final double titleFontSize; // 章节标题字号

  // ---- 颜色 ----
  final PdfColor primaryColor; // 主题色（用于chip背景）
  final PdfColor accentColor; // 强调色（用于chip边框）
  final PdfColor textColor; // 文字颜色
  final PdfColor backgroundColor; // 整体背景色

  const CreativePdfConfig({
    this.headerBgColor = const PdfColor(0.024, 0.157, 0.267), // 头部深蓝背景
    this.avatarRadius = 50.0, // 头像半径
    this.headerSpacing = 16.0, // 头像与文字间距
    this.headerInfoLeftPadding = 60.0, // 姓名/信息右移距离
    this.headerColumnsSpacing = 25.0, // 信息两列间距
    this.headerNameFontSize = 26.0, // 姓名字号
    this.headerInfoFontSize = 11.0, // 基础信息字号
    this.titleHeight = 18.0, // 标题栏高度
    this.titlePaddingHorizontal = 10.0, // 标题文字左右内边距
    this.titleLineLength = 600.0, // 标题下方横线长度
    this.rightTriangleHorizontal = 13.0, // 右侧三角形水平直角边
    this.rightTriangleVertical = 19.0, // 右侧三角形垂直直角边
    this.leftTriangleHorizontal = 19.0, // 左侧三角形水平直角边
    this.leftTriangleVertical = 13.0, // 左侧三角形垂直直角边
    this.strokeWidth = 1.0, // 标题边框宽度
    this.titleBgColor = const PdfColor(0.024, 0.157, 0.267), // 标题背景色（同头部）
    this.contentLeftPadding = 30.0, // 章节内容左侧缩进
    this.contentVerticalPadding = 24.0, // 内容区域上下内边距
    this.verticalLineWidth = 1.0, // 竖线宽度
    this.verticalLineLeftOffset = 19.0, // 竖线水平偏移
    this.verticalLineStartOffset = 0.0, // 竖线垂直偏移
    this.verticalLineColor = const PdfColor(0.024, 0.157, 0.267), // 竖线颜色
    this.headerBottomSpacing = 0, // 头部与内容间距
    this.workPositionSpacing = 40.0, // 工作经历：公司与职位间距
    this.projectRoleSpacing = 40.0, // 项目经验：项目名与角色间距
    this.intentChipLabelFontSize = 10.0, // 求职意向标签字号
    this.intentChipValueFontSize = 10.0, // 求职意向值字号
    this.eduFontSize = 10.0, // 教育经历字号
    this.workFontSize = 10.0, // 工作经历字号
    this.projectFontSize = 10.0, // 项目经验字号

    this.honorFontSize = 10.0, // 荣誉奖励字号
    this.skillFontSize = 10.0, // 技能特长字号
    this.summaryFontSize = 10.0, // 自我评价字号
    this.descFontSize = 10.0, // 描述列表字号
    this.titleFontSize = 14.0, // 章节标题字号
    this.primaryColor = const PdfColor(0.85, 0.85, 0.85), // 主题色（#1A237E）
    this.accentColor = const PdfColor(1.0, 0.835, 0.31), // 强调色（#FFD54F）
    this.textColor = PdfColors.black, // 文字颜色
    this.backgroundColor = PdfColors.white, // 整体背景色
    this.titleBackgroundWidth = 40.0, // 默认固定值
  });
  CreativePdfConfig scaled(double factor) {
    return CreativePdfConfig(
      headerBgColor: headerBgColor,
      avatarRadius: avatarRadius, // 头像尺寸固定
      headerSpacing: headerSpacing * factor,
      headerInfoLeftPadding: headerInfoLeftPadding * factor,
      headerColumnsSpacing: headerColumnsSpacing * factor,
      headerNameFontSize: headerNameFontSize * factor,
      headerInfoFontSize: headerInfoFontSize * factor,
      titleHeight: titleHeight * factor,
      titlePaddingHorizontal: titlePaddingHorizontal * factor,
      titleLineLength: titleLineLength * factor,
      rightTriangleHorizontal: rightTriangleHorizontal * factor,
      rightTriangleVertical: rightTriangleVertical * factor,
      leftTriangleHorizontal: leftTriangleHorizontal * factor,
      leftTriangleVertical: leftTriangleVertical * factor,
      strokeWidth: strokeWidth, // 边框宽度固定
      titleBgColor: titleBgColor,
      contentLeftPadding: contentLeftPadding * factor,
      contentVerticalPadding: contentVerticalPadding * factor,
      verticalLineWidth: verticalLineWidth, // 竖线宽度固定
      verticalLineLeftOffset: verticalLineLeftOffset * factor,
      verticalLineStartOffset: verticalLineStartOffset * factor,
      verticalLineColor: verticalLineColor,
      headerBottomSpacing: headerBottomSpacing * factor,
      workPositionSpacing: workPositionSpacing * factor,
      projectRoleSpacing: projectRoleSpacing * factor,
      intentChipLabelFontSize: intentChipLabelFontSize * factor,
      intentChipValueFontSize: intentChipValueFontSize * factor,
      eduFontSize: eduFontSize * factor,
      workFontSize: workFontSize * factor,
      projectFontSize: projectFontSize * factor,
      honorFontSize: honorFontSize * factor,
      skillFontSize: skillFontSize * factor,
      summaryFontSize: summaryFontSize * factor,
      descFontSize: descFontSize * factor,
      titleFontSize: titleFontSize * factor,
      primaryColor: primaryColor,
      accentColor: accentColor,
      textColor: textColor,
      backgroundColor: backgroundColor,
    );
  }
}

CreativePdfConfig _getCreativeConfig() => CreativePdfConfig();

// ================================================================
// 经典模板配置类（ClassicPdfConfig）
// ================================================================
class ClassicPdfConfig {
  // ---- 颜色 ----
  final PdfColor headerBgColor; // 头部背景色（深蓝黑）
  final PdfColor headerTextColor; // 头部文字颜色（白色）
  final PdfColor textColor; // 正文文字颜色（黑色）
  final PdfColor sectionTitleBgColor; // 章节标题背景色
  final PdfColor sectionTitleTextColor; // 章节标题文字颜色（白色）
  final PdfColor sectionRightBarColor; // 右侧延伸矩形颜色（浅色）
  final PdfColor sectionDecorationBgColor; // 装饰条颜色（淡紫）

  // ---- 尺寸与间距 ----
  final double sectionSpacing; // 模块间距
  final double itemSpacing; // 条目间距
  final double headerPaddingVertical; // 头部上下内边距
  final double headerPaddingLeft; // 头部左内边距
  final double contentPaddingHorizontal; // 内容区域左右内边距

  // ---- 章节标题 ----
  final double sectionTitleHeight; // 标题栏高度
  final double sectionTitleIconSize; // 标题图标大小
  final double sectionTitleFontSize; // 标题字号
  final double sectionTitlePaddingHorizontal; // 标题左右内边距
  final double sectionLeftBarWidth; // 左侧小长方形宽度
  final double sectionLeftBarHeight; // 左侧小长方形高度
  final double sectionLeftBarSpacing; // 小长方形与标题背景间距
  final double sectionRightBarHeight; // 右侧延伸矩形高度

  // ---- 头部 ----
  final double headerColumn1Width; // 第一列宽度
  final double headerColumn2Width; // 第二列宽度
  final double headerColumn3Width; // 第三列宽度
  final double headerColumnSpacing; // 列间距
  final double headerLabelFontSize; // 标签字号
  final double headerValueFontSize; // 值字号
  final double headerItemSpacing; // 条目垂直间距
  final double avatarSize; // 头像尺寸（正方形）
  final double avatarTopOffset; // 头像上偏移
  final double avatarRightOffset; // 头像右偏移

  // ---- 教育经历 ----
  final double eduTimeWidth; // 时间列宽
  final double eduFontSize; // 字段字号
  final double eduDescriptionFontSize; // 描述字号
  final double eduDescriptionHeight; // 描述行高
  final double eduItemSpacing; // 条目底部间距

  // ---- 工作经历 ----
  final double workTimeCompanySpacing; // 时间与公司间距
  final double workTimeFontSize; // 时间字号
  final double workCompanyFontSize; // 公司字号
  final double workPositionFontSize; // 岗位字号
  final double workDescriptionFontSize; // 描述字号
  final double workDescriptionHeight; // 描述行高
  final double workItemSpacing; // 条目底部间距

  // ---- 项目经验 ----
  final double projectNameFontSize; // 项目名称字号
  final double projectRoleFontSize; // 角色字号
  final double projectDescriptionFontSize; // 描述字号
  final double projectDescriptionHeight; // 描述行高
  final double projectItemSpacing; // 条目底部间距

  // ---- 个人技能 ----
  final double skillLabelWidth; // 标签宽度
  final double skillLabelFontSize; // 标签字号
  final double skillValueFontSize; // 值字号
  final double skillItemSpacing; // 行间距

  // ---- 个人评价 ----
  final double summaryFontSize; // 评价字号
  final double summaryHeight; // 行高
  final String summaryIndent; // 首行缩进（两个全角空格）

  // ---- 装饰条配置 ----

  final double decoLeftWidth; // 左侧条宽度
  final double decoRightWidth; // 右侧条宽度
  final double decoLeftHeight; // 左侧条高度
  final double decoRightHeight; // 右侧条高度
  final double decoLeftTopOffset; // 左侧条在容器内的顶部偏移（向下为正）
  final double decoRightTopOffset; // 右侧条在容器内的顶部偏移
  final double decoSkew; // 倾斜角度（tan值，例如 0.2）
  final PdfColor decoLeftColor; // 左侧条颜色（头部背景色）
  final PdfColor decoRightColor; // 右侧条颜色（深黄色）
  final double decoContainerHeight; //容器高度

  const ClassicPdfConfig({
    this.headerBgColor = const PdfColor(0.039, 0.086, 0.157), // #0A1628
    this.headerTextColor = PdfColors.white,
    this.textColor = PdfColors.black,
    this.sectionTitleBgColor = const PdfColor(0.039, 0.086, 0.157),
    this.sectionTitleTextColor = PdfColors.white,
    this.sectionRightBarColor = const PdfColor(0.91, 0.92, 0.96), // #E8EAF6
    this.sectionDecorationBgColor = const PdfColor(0.91, 0.92, 0.96),
    this.sectionSpacing = 8.0,
    this.itemSpacing = 6.0,
    this.headerPaddingVertical = 20.0,
    this.headerPaddingLeft = 30.0,
    this.contentPaddingHorizontal = 24.0,
    this.sectionTitleHeight = 25.0,
    this.sectionTitleIconSize = 18.0,
    this.sectionTitleFontSize = 16.0,
    this.sectionTitlePaddingHorizontal = 16.0,
    this.sectionLeftBarWidth = 6.0,
    this.sectionLeftBarHeight = 24.0,
    this.sectionLeftBarSpacing = 8.0,
    this.sectionRightBarHeight = 25.0,
    this.headerColumn1Width = 180.0,
    this.headerColumn2Width = 280.0,
    this.headerColumn3Width = 60.0,
    this.headerColumnSpacing = 4.0,
    this.headerLabelFontSize = 14.0,
    this.headerValueFontSize = 14.0,
    this.headerItemSpacing = 8.0,
    this.avatarSize = 110.0,
    this.avatarTopOffset = 10.0,
    this.avatarRightOffset = 0.0,
    this.eduTimeWidth = 100.0,
    this.eduFontSize = 13.0,
    this.eduDescriptionFontSize = 12.0,
    this.eduDescriptionHeight = 1.4,
    this.eduItemSpacing = 6.0,
    this.workTimeCompanySpacing = 60.0,
    this.workTimeFontSize = 13.0,
    this.workCompanyFontSize = 13.0,
    this.workPositionFontSize = 12.0,
    this.workDescriptionFontSize = 12.0,
    this.workDescriptionHeight = 1.4,
    this.workItemSpacing = 6.0,
    this.projectNameFontSize = 14.0,
    this.projectRoleFontSize = 12.0,
    this.projectDescriptionFontSize = 12.0,
    this.projectDescriptionHeight = 1.4,
    this.projectItemSpacing = 6.0,
    this.skillLabelWidth = 72.0,
    this.skillLabelFontSize = 13.0,
    this.skillValueFontSize = 13.0,
    this.skillItemSpacing = 4.0,
    this.summaryFontSize = 13.0,
    this.summaryHeight = 1.5,
    this.summaryIndent = '\u3000\u3000',
    // ---- ★ 装饰条配置（平行四边形条，已修改） ----
    this.decoLeftWidth = 400.0,
    this.decoRightWidth = 180.0,
    this.decoLeftHeight = 8.0,
    this.decoRightHeight = 8.0,
    this.decoLeftTopOffset = 12,
    this.decoRightTopOffset = 18.0,
    this.decoSkew = 1,
    this.decoLeftColor = const PdfColor(0.831, 0.627, 0.09),
    this.decoRightColor = const PdfColor(0.039, 0.086, 0.157),
    this.decoContainerHeight = 40,
  });

  ClassicPdfConfig scaled(double factor) {
    return ClassicPdfConfig(
      headerBgColor: headerBgColor,
      headerTextColor: headerTextColor,
      textColor: textColor,
      sectionTitleBgColor: sectionTitleBgColor,
      sectionTitleTextColor: sectionTitleTextColor,
      sectionRightBarColor: sectionRightBarColor,
      sectionDecorationBgColor: sectionDecorationBgColor,
      sectionSpacing: sectionSpacing * factor,
      itemSpacing: itemSpacing * factor,
      headerPaddingVertical: headerPaddingVertical * factor,
      headerPaddingLeft: headerPaddingLeft * factor,
      contentPaddingHorizontal: contentPaddingHorizontal * factor,
      sectionTitleHeight: sectionTitleHeight * factor,
      sectionTitleIconSize: sectionTitleIconSize * factor,
      sectionTitleFontSize: sectionTitleFontSize * factor,
      sectionTitlePaddingHorizontal: sectionTitlePaddingHorizontal * factor,
      sectionLeftBarWidth: sectionLeftBarWidth * factor,
      sectionLeftBarHeight: sectionLeftBarHeight * factor,
      sectionLeftBarSpacing: sectionLeftBarSpacing * factor,
      sectionRightBarHeight: sectionRightBarHeight * factor,
      headerColumn1Width: headerColumn1Width * factor,
      headerColumn2Width: headerColumn2Width * factor,
      headerColumn3Width: headerColumn3Width * factor,
      headerColumnSpacing: headerColumnSpacing * factor,
      headerLabelFontSize: headerLabelFontSize * factor,
      headerValueFontSize: headerValueFontSize * factor,
      headerItemSpacing: headerItemSpacing * factor,
      avatarSize: avatarSize * factor, // 头像尺寸固定
      avatarTopOffset: avatarTopOffset * factor,
      avatarRightOffset: avatarRightOffset * factor,
      eduTimeWidth: eduTimeWidth * factor,
      eduFontSize: eduFontSize * factor,
      eduDescriptionFontSize: eduDescriptionFontSize * factor,
      eduDescriptionHeight: eduDescriptionHeight, // 行高不缩放
      eduItemSpacing: eduItemSpacing * factor,
      workTimeCompanySpacing: workTimeCompanySpacing * factor,
      workTimeFontSize: workTimeFontSize * factor,
      workCompanyFontSize: workCompanyFontSize * factor,
      workPositionFontSize: workPositionFontSize * factor,
      workDescriptionFontSize: workDescriptionFontSize * factor,
      workDescriptionHeight: workDescriptionHeight,
      workItemSpacing: workItemSpacing * factor,
      projectNameFontSize: projectNameFontSize * factor,
      projectRoleFontSize: projectRoleFontSize * factor,
      projectDescriptionFontSize: projectDescriptionFontSize * factor,
      projectDescriptionHeight: projectDescriptionHeight,
      projectItemSpacing: projectItemSpacing * factor,
      skillLabelWidth: skillLabelWidth * factor,
      skillLabelFontSize: skillLabelFontSize * factor,
      skillValueFontSize: skillValueFontSize * factor,
      skillItemSpacing: skillItemSpacing * factor,
      summaryFontSize: summaryFontSize * factor,
      summaryHeight: summaryHeight,
      summaryIndent: summaryIndent,
    );
  }
}

ClassicPdfConfig _getClassicConfig() => ClassicPdfConfig();

// ================================================================
// 深色模板配置类（DarkPdfConfig）
// ================================================================

class DarkPdfConfig {
  // ---- 颜色 ----
  final PdfColor headerBgColor; // 头部背景色
  final PdfColor leftBgColor; // 左侧区域背景色
  final PdfColor rightBgColor; // 右侧区域背景色（白色）
  final PdfColor sectionTitleBgColor; // 章节标题背景色
  final PdfColor sectionTitleTextColor; // 标题文字颜色（白色）
  final PdfColor dividerColor; // 分割条颜色
  final PdfColor lightTextColor; // 浅色背景正文（黑色）
  final PdfColor lightSubTextColor; // 浅色背景次要（黑色）
  final PdfColor darkTextColor; // 深色背景文字（白色）

  // ---- 尺寸与间距 ----
  final double dividerHeight; // 分割条高度
  final double sectionSpacing; // 模块间距
  final double itemSpacing; // 条目间距
  final double headerPaddingVertical; // 头部上下内边距
  final double headerPaddingHorizontal; // 头部左右内边距
  final double contentPadding; // 内容区域内边距
  final double leftWidthFactor; // 左侧宽度占比
  final double rightWidthFactor; // 右侧宽度占比

  // ---- 头部 ----
  final double headerHeight; // 头部总高度
  final double headerNameFontSize; // 姓名字号
  final double headerJobFontSize; // 求职意向字号
  final double avatarSize; // 头像尺寸（矩形）
  final double avatarLeftOffset1; // 头像左偏移
  final double avatarTopOffset1; // 头像上偏移
  final double avatarCornerRadius; // 头像圆角半径

  // ---- 基础信息 ----
  final double infoFontSize;
  final double infoItemSpacing;

  // ---- 章节标题 ----
  final double sectionTitleHeight;
  final double sectionTitleIconSize;
  final double sectionTitleFontSize;
  final double sectionTitlePaddingHorizontal;

  // ---- 工作经历 ----
  final double workTimeWidth;
  final double workTimeFontSize;
  final double workCompanyFontSize;
  final double workPositionFontSize;
  final double workDescriptionFontSize;
  final double workDescriptionHeight;
  final double workItemSpacing;

  // ---- 教育经历 ----
  final double eduTimeWidth;
  final double eduFontSize;
  final double eduDescriptionFontSize;
  final double eduDescriptionHeight;
  final double eduItemSpacing;

  // ---- 项目经验 ----
  final double projectNameFontSize;
  final double projectRoleFontSize;
  final double projectDescriptionFontSize;
  final double projectDescriptionHeight;
  final double projectItemSpacing;

  // ---- 个人评价 ----
  final double summaryFontSize;
  final double summaryHeight;
  final String summaryIndent;

  // ---- 技能荣誉 ----
  final double skillItemSpacing;
  final double skillFontSize;

  const DarkPdfConfig({
    this.headerBgColor = const PdfColor(0.102, 0.102, 0.188), // #1A1A30
    this.leftBgColor = const PdfColor(0.878, 0.878, 0.918), // #E0E0EA
    this.rightBgColor = PdfColors.white,
    this.sectionTitleBgColor = const PdfColor(0.102, 0.102, 0.227), // #1A1A3A
    this.sectionTitleTextColor = PdfColors.white,
    this.dividerColor = const PdfColor(0.094, 0.169, 0.192), // #182B31
    this.lightTextColor = PdfColors.black,
    this.lightSubTextColor = PdfColors.black,
    this.darkTextColor = PdfColors.white,
    this.dividerHeight = 8.0,
    this.sectionSpacing = 12.0,
    this.itemSpacing = 4.0,
    this.headerPaddingVertical = 16.0,
    this.headerPaddingHorizontal = 24.0,
    this.contentPadding = 16.0,
    this.leftWidthFactor = 0.3,
    this.rightWidthFactor = 0.7,
    this.headerHeight = 150.0,
    this.headerNameFontSize = 26.0,
    this.headerJobFontSize = 16.0,
    this.avatarSize = 110.0,
    this.avatarLeftOffset1 = 24.0,
    this.avatarTopOffset1 = 5.0,
    this.avatarCornerRadius = 6.0,
    this.infoFontSize = 13.0,
    this.infoItemSpacing = 6.0,
    this.sectionTitleHeight = 32.0,
    this.sectionTitleIconSize = 18.0,
    this.sectionTitleFontSize = 15.0,
    this.sectionTitlePaddingHorizontal = 16.0,
    this.workTimeWidth = 90.0,
    this.workTimeFontSize = 13.0,
    this.workCompanyFontSize = 14.0,
    this.workPositionFontSize = 13.0,
    this.workDescriptionFontSize = 12.0,
    this.workDescriptionHeight = 1.4,
    this.workItemSpacing = 8.0,
    this.eduTimeWidth = 90.0,
    this.eduFontSize = 13.0,
    this.eduDescriptionFontSize = 12.0,
    this.eduDescriptionHeight = 1.4,
    this.eduItemSpacing = 8.0,
    this.projectNameFontSize = 14.0,
    this.projectRoleFontSize = 13.0,
    this.projectDescriptionFontSize = 12.0,
    this.projectDescriptionHeight = 1.4,
    this.projectItemSpacing = 8.0,
    this.summaryFontSize = 13.0,
    this.summaryHeight = 1.6,
    this.summaryIndent = '\u3000\u3000',
    this.skillItemSpacing = 4.0,
    this.skillFontSize = 13.0,
  });

  DarkPdfConfig scaled(double factor) {
    return DarkPdfConfig(
      headerBgColor: headerBgColor,
      leftBgColor: leftBgColor,
      rightBgColor: rightBgColor,
      sectionTitleBgColor: sectionTitleBgColor,
      sectionTitleTextColor: sectionTitleTextColor,
      dividerColor: dividerColor,
      lightTextColor: lightTextColor,
      lightSubTextColor: lightSubTextColor,
      darkTextColor: darkTextColor,
      dividerHeight: dividerHeight * factor,
      sectionSpacing: sectionSpacing * factor,
      itemSpacing: itemSpacing * factor,
      headerPaddingVertical: headerPaddingVertical * factor,
      headerPaddingHorizontal: headerPaddingHorizontal * factor,
      contentPadding: contentPadding * factor,
      leftWidthFactor: leftWidthFactor,
      rightWidthFactor: rightWidthFactor,
      headerHeight: headerHeight * factor,
      headerNameFontSize: headerNameFontSize * factor,
      headerJobFontSize: headerJobFontSize * factor,
      avatarSize: avatarSize * factor, // 头像固定
      avatarLeftOffset1: avatarLeftOffset1 * factor,
      avatarTopOffset1: avatarTopOffset1 * factor,
      avatarCornerRadius: avatarCornerRadius * factor,
      infoFontSize: infoFontSize * factor,
      infoItemSpacing: infoItemSpacing * factor,
      sectionTitleHeight: sectionTitleHeight * factor,
      sectionTitleIconSize: sectionTitleIconSize * factor,
      sectionTitleFontSize: sectionTitleFontSize * factor,
      sectionTitlePaddingHorizontal: sectionTitlePaddingHorizontal * factor,
      workTimeWidth: workTimeWidth * factor,
      workTimeFontSize: workTimeFontSize * factor,
      workCompanyFontSize: workCompanyFontSize * factor,
      workPositionFontSize: workPositionFontSize * factor,
      workDescriptionFontSize: workDescriptionFontSize * factor,
      workDescriptionHeight: workDescriptionHeight,
      workItemSpacing: workItemSpacing * factor,
      eduTimeWidth: eduTimeWidth * factor,
      eduFontSize: eduFontSize * factor,
      eduDescriptionFontSize: eduDescriptionFontSize * factor,
      eduDescriptionHeight: eduDescriptionHeight,
      eduItemSpacing: eduItemSpacing * factor,
      projectNameFontSize: projectNameFontSize * factor,
      projectRoleFontSize: projectRoleFontSize * factor,
      projectDescriptionFontSize: projectDescriptionFontSize * factor,
      projectDescriptionHeight: projectDescriptionHeight,
      projectItemSpacing: projectItemSpacing * factor,
      summaryFontSize: summaryFontSize * factor,
      summaryHeight: summaryHeight,
      summaryIndent: summaryIndent,
      skillItemSpacing: skillItemSpacing * factor,
      skillFontSize: skillFontSize * factor,
    );
  }
}

DarkPdfConfig _getDarkConfig() => DarkPdfConfig();

// ================================================================
// PDF导出主类
// ================================================================
class DesignPdfExporter {
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
    if (count <= 9) return 1;
    if (count <= 10) return 0.9;
    if (count <= 12) return 0.8;
    return 0.75;
  }

  static double getAutoScaleFactor(Resume resume) {
    return _calculateScaleFactor(resume);
  }

  // 在 design_pdf_exporter.dart 中
  static Future<Uint8List> generateDesignPdf(
    Resume resume,
    String style, {
    double? userScale,
  }) async {
    final pdf = pw.Document();

    // 加载字体
    final fontData = await rootBundle.load(
      'assets/fonts/SourceHanSansCN-Regular.ttf',
    );
    final boldFontData = await rootBundle.load(
      'assets/fonts/SourceHanSansCN-Bold.ttf',
    );
    final faFontData = await rootBundle.load('assets/fonts/fa-solid-900.ttf');
    final font = pw.Font.ttf(fontData.buffer.asByteData());
    final boldFont = pw.Font.ttf(boldFontData.buffer.asByteData());
    final faFont = pw.Font.ttf(faFontData.buffer.asByteData());

    // 确定缩放因子
    double scaleFactor;
    if (userScale != null) {
      scaleFactor = userScale.clamp(0.5, 1.8);
    } else {
      scaleFactor = _calculateScaleFactor(resume);
    }
    print('✅ generateDesignPdf 使用的缩放因子: $scaleFactor');

    // 根据风格构建内容（使用缩放后的配置）
    List<pw.Widget> content;
    if (style == 'modern') {
      final config = _getModernConfig().scaled(scaleFactor);
      content = _buildModernContent(resume, font, boldFont, faFont, config);
    } else if (style == 'creative') {
      final config = _getCreativeConfig().scaled(scaleFactor);
      content = _buildCreativeContent(resume, font, boldFont, faFont, config);
    } else if (style == 'classic') {
      final config = _getClassicConfig().scaled(scaleFactor);
      content = _buildClassicContent(resume, font, boldFont, faFont, config);
    } else if (style == 'dark') {
      final config = _getDarkConfig().scaled(scaleFactor);
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (context) => _buildDarkContent(
            resume,
            font,
            boldFont,
            faFont,
            config,
          ), // 直接使用局部变量
        ),
      );
      return await pdf.save();
    } else {
      final config = _getModernConfig().scaled(scaleFactor);
      content = _buildModernContent(resume, font, boldFont, faFont, config);
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) => content,
      ),
    );

    return await pdf.save();
  }

  // ================================================================
  // 现代模板构建方法
  // ================================================================
  static List<pw.Widget> _buildModernContent(
    Resume resume,
    pw.Font font,
    pw.Font boldFont,
    pw.Font faFont,
    ModernPdfConfig config,
  ) {
    final List<pw.Widget> content = [];

    final List<MapEntry<String, String>> leftInfoItems = [];

    if ((resume.personal.birthDate ?? '').isNotEmpty) {
      leftInfoItems.add(MapEntry('出生年月：', resume.personal.birthDate!));
    }
    if ((resume.personal.birthPlace ?? '').isNotEmpty) {
      leftInfoItems.add(MapEntry('籍贯：', resume.personal.birthPlace!));
    }
    if ((resume.personal.politicalStatus ?? '').isNotEmpty) {
      leftInfoItems.add(MapEntry('政治面貌：', resume.personal.politicalStatus!));
    }
    if ((resume.personal.gender ?? '').isNotEmpty) {
      leftInfoItems.add(MapEntry('性别：', resume.personal.gender!));
    }
    if ((resume.personal.nation ?? '').isNotEmpty) {
      leftInfoItems.add(MapEntry('民族：', resume.personal.nation!));
    }
    if (resume.personal.phone.isNotEmpty) {
      leftInfoItems.add(MapEntry('电话：', resume.personal.phone));
    }
    if (resume.personal.email.isNotEmpty) {
      leftInfoItems.add(MapEntry('邮箱：', resume.personal.email));
    }

    content.add(
      pw.Expanded(
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: config.leftFlex,
              child: pw.Container(
                decoration: pw.BoxDecoration(color: config.leftBgColor),
                child: pw.Padding(
                  padding: pw.EdgeInsets.all(config.leftPadding),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.SizedBox(height: 24),
                      pw.Container(
                        width: config.avatarSize,
                        height: config.avatarSize,
                        decoration: pw.BoxDecoration(
                          color: config.primaryColor,
                          shape: pw.BoxShape.circle,
                        ),
                        child: pw.ClipOval(
                          child: resume.personal.avatarImage != null
                              ? pw.Image(
                                  pw.MemoryImage(resume.personal.avatarImage!),
                                  fit: pw.BoxFit.cover,
                                  width: config.avatarSize,
                                  height: config.avatarSize,
                                )
                              : pw.Center(
                                  child: pw.Text(
                                    resume.personal.fullName.isNotEmpty
                                        ? resume.personal.fullName[0]
                                        : '?',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontSize: config.avatarTextSize,
                                      color: PdfColors.white,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      pw.SizedBox(height: 24),
                      pw.Container(
                        width: double.infinity,
                        padding: const pw.EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: leftInfoItems.asMap().entries.map((entry) {
                            final index = entry.key;
                            final label = entry.value.key;
                            final value = entry.value.value;
                            final isLast = index == leftInfoItems.length - 1;
                            return pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  '$label$value',
                                  style: pw.TextStyle(
                                    font: font,
                                    fontSize: config.leftInfoFontSize,
                                  ),
                                ),
                                if (!isLast)
                                  pw.SizedBox(height: config.leftInfoSpacing),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      pw.SizedBox(height: config.sectionSpacing),
                      if (resume.skills.isNotEmpty) ...[
                        _buildModernSectionTitle(
                          '技能特长',
                          font,
                          boldFont,
                          faFont,
                          iconCode: 0xf0ad,
                          showDivider: false,
                          config: config,
                        ),
                        pw.SizedBox(height: 16),
                        pw.Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: resume.skills.map((s) {
                            return pw.Container(
                              padding: pw.EdgeInsets.symmetric(
                                horizontal: config.leftChipPaddingH,
                                vertical: config.leftChipPaddingV,
                              ),
                              decoration: pw.BoxDecoration(
                                color: config.leftChipBgColor,
                                borderRadius: pw.BorderRadius.circular(
                                  config.leftChipRadius,
                                ),
                                border: pw.Border.all(
                                  color: config.leftChipBorderColor,
                                  width: config.leftChipBorderWidth,
                                ),
                              ),
                              child: pw.Text(
                                s.name,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: config.leftChipFontSize,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        pw.SizedBox(height: config.sectionSpacing),
                      ],
                      if (resume.languages.isNotEmpty) ...[
                        _buildModernSectionTitle(
                          '语言能力',
                          font,
                          boldFont,
                          faFont,
                          iconCode: 0xf1ab,
                          showDivider: false,
                          config: config,
                        ),
                        pw.SizedBox(height: 16),
                        pw.Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: resume.languages.map((lang) {
                            return pw.Container(
                              padding: pw.EdgeInsets.symmetric(
                                horizontal: config.leftChipPaddingH,
                                vertical: config.leftChipPaddingV,
                              ),
                              decoration: pw.BoxDecoration(
                                color: config.leftChipBgColor,
                                borderRadius: pw.BorderRadius.circular(
                                  config.leftChipRadius,
                                ),
                                border: pw.Border.all(
                                  color: config.leftChipBorderColor,
                                  width: config.leftChipBorderWidth,
                                ),
                              ),
                              child: pw.Text(
                                lang,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: config.leftChipFontSize,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        pw.SizedBox(height: config.sectionSpacing),
                      ],
                      if (resume.honors.isNotEmpty) ...[
                        _buildModernSectionTitle(
                          '荣誉奖励',
                          font,
                          boldFont,
                          faFont,
                          iconCode: 0xf091,
                          showDivider: false,
                          config: config,
                        ),
                        pw.SizedBox(height: 16),
                        pw.Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: resume.honors.map((s) {
                            return pw.Container(
                              padding: pw.EdgeInsets.symmetric(
                                horizontal: config.leftChipPaddingH,
                                vertical: config.leftChipPaddingV + 1,
                              ),
                              decoration: pw.BoxDecoration(
                                color: config.leftChipBgColor,
                                borderRadius: pw.BorderRadius.circular(
                                  config.leftChipRadius,
                                ),
                                border: pw.Border.all(
                                  color: config.leftChipBorderColor,
                                  width: config.leftChipBorderWidth,
                                ),
                              ),
                              child: pw.Text(
                                s,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: config.leftHonorChipFontSize,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        pw.SizedBox(height: config.sectionSpacing),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            pw.SizedBox(width: 20),
            pw.Expanded(
              flex: config.rightFlex,
              child: pw.Padding(
                padding: pw.EdgeInsets.only(
                  right: config.rightPadding,
                  top: 14,
                  bottom: 14,
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      resume.personal.fullName.isNotEmpty
                          ? resume.personal.fullName
                          : '你的名字',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: config.rightNameFontSize,
                        fontWeight: config.rightNameWeight,
                        letterSpacing: 2,
                        color: config.textColor,
                      ),
                    ),
                    pw.SizedBox(height: 16),
                    pw.Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _buildModernChip(
                          '意向职位',
                          resume.personal.jobTitle.isNotEmpty
                              ? resume.personal.jobTitle
                              : '未填写',
                          font,
                          config.rightChipFontSize,
                          config.textColor,
                        ),
                        _buildModernChip(
                          '意向城市',
                          resume.personal.expectedCity.isNotEmpty
                              ? resume.personal.expectedCity
                              : '未填写',
                          font,
                          config.rightChipFontSize,
                          config.textColor,
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 16),
                    if (resume.educations.isNotEmpty) ...[
                      _buildModernSectionTitle(
                        '教育背景',
                        font,
                        boldFont,
                        faFont,
                        iconCode: 0xf19d,
                        showDivider: true,
                        config: config,
                      ),
                      pw.SizedBox(height: config.itemSpacing),
                      ...resume.educations.map(
                        (edu) => pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Expanded(
                                  flex: 1,
                                  child: pw.Text(
                                    '${edu.startDate.year} - ${edu.endDate?.year ?? '至今'}',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontSize: config.rightEduFontSize,
                                      color: config.textColor.withAlpha(0.6),
                                    ),
                                    textAlign: pw.TextAlign.left,
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 1,
                                  child: pw.Text(
                                    edu.degree,
                                    style: pw.TextStyle(
                                      font: font,
                                      fontSize: config.rightEduFontSize,
                                      fontWeight: config.rightEduBoldWeight,
                                    ),
                                    textAlign: pw.TextAlign.center,
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Text(
                                    edu.school,
                                    style: pw.TextStyle(
                                      font: font,
                                      fontSize: config.rightEduFontSize,
                                      fontWeight: config.rightEduBoldWeight,
                                    ),
                                    textAlign: pw.TextAlign.center,
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 1,
                                  child: pw.Text(
                                    edu.major,
                                    style: pw.TextStyle(
                                      font: font,
                                      fontSize: config.rightEduFontSize,
                                    ),
                                    textAlign: pw.TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: config.eduItemSpacing),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: config.sectionSpacing),
                    ],
                    if (resume.workExperiences.isNotEmpty) ...[
                      _buildModernSectionTitle(
                        '工作经历',
                        font,
                        boldFont,
                        faFont,
                        iconCode: 0xf0b1,
                        showDivider: true,
                        config: config,
                      ),
                      pw.SizedBox(height: config.itemSpacing),
                      ...resume.workExperiences.map(
                        (exp) => pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.SizedBox(
                                  width: 90,
                                  child: pw.Text(
                                    '${exp.startDate.year} - ${exp.endDate?.year ?? '至今'}',
                                    style: pw.TextStyle(
                                      font: boldFont,
                                      fontSize: config.rightWorkFontSize,
                                      fontWeight: config.rightWorkBoldWeight,
                                    ),
                                    textAlign: pw.TextAlign.left,
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    exp.company,
                                    style: pw.TextStyle(
                                      font: boldFont,
                                      fontSize: config.rightWorkFontSize,
                                      fontWeight: config.rightWorkBoldWeight,
                                      color: config.textColor.withAlpha(0.7),
                                    ),
                                    textAlign: pw.TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              '岗位: ${exp.position}',
                              style: pw.TextStyle(
                                font: font,
                                fontSize: config.rightWorkFontSize,
                              ),
                            ),
                            if (exp.description.isNotEmpty) ...[
                              pw.SizedBox(height: 6),
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
                                    return pw.Padding(
                                      padding: const pw.EdgeInsets.only(
                                        left: 4,
                                        bottom: 1,
                                      ),
                                      child: pw.Row(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.SizedBox(
                                            width: 12,
                                            child: pw.Text(
                                              '▪',
                                              style: pw.TextStyle(
                                                font: font,
                                                fontSize:
                                                    config.rightDescFontSize,
                                              ),
                                              textAlign: pw.TextAlign.right,
                                            ),
                                          ),
                                          pw.Expanded(
                                            child: pw.Text(
                                              cleaned,
                                              style: pw.TextStyle(
                                                font: font,
                                                fontSize:
                                                    config.rightDescFontSize,
                                              ),
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                            pw.SizedBox(height: config.workItemSpacing),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: config.sectionSpacing),
                    ],
                    if (resume.projects.isNotEmpty) ...[
                      _buildModernSectionTitle(
                        '项目经验',
                        font,
                        boldFont,
                        faFont,
                        iconCode: 0xf07c,
                        showDivider: true,
                        config: config,
                      ),
                      pw.SizedBox(height: config.itemSpacing),
                      ...resume.projects.map(
                        (proj) => pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              proj.name,
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: config.rightProjectFontSize,
                                fontWeight: config.rightProjectBoldWeight,
                              ),
                            ),
                            pw.SizedBox(height: 6),
                            if (proj.role.isNotEmpty)
                              pw.Text(
                                '角色: ${proj.role}',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: config.rightProjectFontSize,
                                  color: config.textColor.withAlpha(0.7),
                                ),
                              ),
                            if (proj.description.isNotEmpty) ...[
                              pw.SizedBox(height: 6),
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
                                    return pw.Padding(
                                      padding: const pw.EdgeInsets.only(
                                        left: 4,
                                        bottom: 1,
                                      ),
                                      child: pw.Row(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.SizedBox(
                                            width: 12,
                                            child: pw.Text(
                                              '▪',
                                              style: pw.TextStyle(
                                                font: font,
                                                fontSize:
                                                    config.rightDescFontSize,
                                              ),
                                              textAlign: pw.TextAlign.right,
                                            ),
                                          ),
                                          pw.Expanded(
                                            child: pw.Text(
                                              cleaned,
                                              style: pw.TextStyle(
                                                font: font,
                                                fontSize:
                                                    config.rightDescFontSize,
                                              ),
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                            pw.SizedBox(height: config.projectItemSpacing),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: config.sectionSpacing),
                    ],
                    if (resume.summary.isNotEmpty) ...[
                      _buildModernSectionTitle(
                        '自我评价',
                        font,
                        boldFont,
                        faFont,
                        iconCode: 0xf007,
                        showDivider: true,
                        config: config,
                      ),
                      pw.SizedBox(height: config.itemSpacing),
                      pw.Text(
                        resume.summary, // 两个全角空格（U+3000）
                        style: pw.TextStyle(
                          font: font,
                          fontSize: config.rightSummaryFontSize,
                          height: 1.6,
                        ),
                      ),
                      pw.SizedBox(height: config.sectionSpacing),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    pw.SizedBox(height: 20);
    return content;
  }

  static pw.Widget _buildModernSectionTitle(
    String title,
    pw.Font font,
    pw.Font boldFont,
    pw.Font faFont, {
    int? iconCode,
    double? iconSize,
    bool showDivider = true,
    required ModernPdfConfig config,
  }) {
    final titleRow = pw.Row(
      children: [
        if (iconCode != null) ...[
          pw.Text(
            String.fromCharCode(iconCode),
            style: pw.TextStyle(
              font: faFont,
              fontSize: iconSize ?? config.rightTitleIconSize,
              color: config.textColor,
            ),
          ),
          pw.SizedBox(width: 8),
        ],
        pw.Text(
          title,
          style: pw.TextStyle(
            font: boldFont,
            fontSize: config.rightTitleFontSize,
            fontWeight: config.rightTitleWeight,
            color: config.textColor,
          ),
        ),
      ],
    );
    if (!showDivider) {
      return titleRow;
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        titleRow,
        pw.SizedBox(height: 2),
        pw.Container(
          width: config.rightDividerWidth,
          height: config.rightDividerHeight,
          color: config.textColor.withAlpha(0.2),
        ),
      ],
    );
  }

  static pw.Widget _buildModernChip(
    String label,
    String value,
    pw.Font font,
    double fontSize,
    PdfColor textColor,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey200,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            '$label: ',
            style: pw.TextStyle(
              font: font,
              fontSize: fontSize,
              color: textColor,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              font: font,
              fontSize: fontSize,
              fontWeight: pw.FontWeight.normal,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // 创意模板构建方法
  // ================================================================
  static List<pw.Widget> _buildCreativeContent(
    Resume resume,
    pw.Font font,
    pw.Font boldFont,
    pw.Font faFont,
    CreativePdfConfig config,
  ) {
    final List<pw.Widget> content = [];

    // ---- 计算最高学历 ----
    String highestDegree = '未填写';
    if (resume.educations.isNotEmpty) {
      final sorted = List<Education>.from(resume.educations)
        ..sort((a, b) => b.startDate.compareTo(a.startDate));
      highestDegree = sorted.first.degree;
    }

    // ---- 准备基础信息条目 ----
    final List<MapEntry<String, String>> infoItems = [];
    if ((resume.personal.birthDate ?? '').isNotEmpty) {
      infoItems.add(MapEntry('出生年月：', resume.personal.birthDate!));
    }
    if (resume.personal.phone.isNotEmpty) {
      infoItems.add(MapEntry('电话：', resume.personal.phone));
    }
    if (resume.personal.email.isNotEmpty) {
      infoItems.add(MapEntry('邮箱：', resume.personal.email));
    }
    infoItems.add(MapEntry('最高学历：', highestDegree));
    if ((resume.personal.birthPlace ?? '').isNotEmpty) {
      infoItems.add(MapEntry('籍贯：', resume.personal.birthPlace!));
    }
    if ((resume.personal.politicalStatus ?? '').isNotEmpty) {
      infoItems.add(MapEntry('政治面貌：', resume.personal.politicalStatus!));
    }
    if ((resume.personal.gender ?? '').isNotEmpty) {
      infoItems.add(MapEntry('性别：', resume.personal.gender!));
    }
    if ((resume.personal.nation ?? '').isNotEmpty) {
      infoItems.add(MapEntry('民族：', resume.personal.nation!));
    }

    // ---- 构建基础信息行（两列） ----
    List<pw.Widget> infoRows = [];
    for (int i = 0; i < infoItems.length; i += 2) {
      final leftItem = infoItems[i];
      final rightItem = (i + 1 < infoItems.length) ? infoItems[i + 1] : null;

      final rowChildren = <pw.Widget>[
        pw.Expanded(
          child: pw.Text(
            '${leftItem.key}${leftItem.value}',
            style: pw.TextStyle(
              font: font,
              fontSize: config.headerInfoFontSize,
              color: PdfColors.white,
            ),
          ),
        ),
      ];
      if (rightItem != null) {
        rowChildren.addAll([
          pw.SizedBox(width: config.headerColumnsSpacing),
          pw.Expanded(
            child: pw.Text(
              '${rightItem.key}${rightItem.value}',
              style: pw.TextStyle(
                font: font,
                fontSize: config.headerInfoFontSize,
                color: PdfColors.white,
              ),
            ),
          ),
        ]);
      }
      infoRows.add(
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: rowChildren,
        ),
      );
      if (i + 2 < infoItems.length) {
        infoRows.add(pw.SizedBox(height: 4));
      }
    }

    // ---- 头部（深蓝背景） ----
    content.add(
      pw.Container(
        decoration: pw.BoxDecoration(color: config.headerBgColor),
        padding: const pw.EdgeInsets.symmetric(vertical: 16, horizontal: 30),
        child: pw.Row(
          children: [
            // 头像
            pw.Container(
              width: config.avatarRadius * 2,
              height: config.avatarRadius * 2,
              decoration: pw.BoxDecoration(
                color: config.primaryColor,
                shape: pw.BoxShape.circle,
              ),
              child: pw.ClipOval(
                child: resume.personal.avatarImage != null
                    ? pw.Image(
                        pw.MemoryImage(resume.personal.avatarImage!),
                        fit: pw.BoxFit.cover,
                        width: config.avatarRadius * 2,
                        height: config.avatarRadius * 2,
                      )
                    : pw.Center(
                        child: pw.Text(
                          resume.personal.fullName.isNotEmpty
                              ? resume.personal.fullName[0]
                              : '?',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 38,
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ),
            pw.SizedBox(width: config.headerSpacing),
            pw.Expanded(
              child: pw.Padding(
                padding: pw.EdgeInsets.only(left: config.headerInfoLeftPadding),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      resume.personal.fullName.isNotEmpty
                          ? resume.personal.fullName
                          : '你的名字',
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: config.headerNameFontSize,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: infoRows,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // ---- ★★★ 修复：使用 Stack 实现竖线 + 内容 ★★★ ----
    content.add(
      pw.Padding(
        padding: pw.EdgeInsets.symmetric(
          horizontal: 30,
          vertical: config.contentVerticalPadding,
        ),
        child: pw.Stack(
          children: [
            // 竖线（背景层，自动拉伸到父容器高度）
            pw.Positioned(
              left: config.verticalLineLeftOffset,
              top: 0,
              bottom: 0,
              child: pw.Container(
                width: config.verticalLineWidth,
                color: config.verticalLineColor,
              ),
            ),
            // 内容主体（前景层，左侧留出竖线宽度）
            pw.Padding(
              padding: pw.EdgeInsets.only(left: 0),
              child: _buildCreativeContentBody(
                resume,
                font,
                boldFont,
                faFont,
                config,
              ),
            ),
          ],
        ),
      ),
    );

    return content;
  }

  // ---- 创意模板：内容主体 ----
  /// 创意模板：内容主体（所有章节）
  static pw.Widget _buildCreativeContentBody(
    Resume resume,
    pw.Font font,
    pw.Font boldFont,
    pw.Font faFont,
    CreativePdfConfig config,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // ----- 求职意向（始终显示） -----
        _buildCreativeSectionTitleWithTag(
          '求职意向',
          font,
          boldFont,
          faFont,
          config,
        ),

        pw.Padding(
          padding: pw.EdgeInsets.only(left: config.contentLeftPadding),
          child: pw.Wrap(
            spacing: 42,
            runSpacing: 6,
            children: [
              _buildCreativeIntentChip(
                '意向岗位',
                resume.personal.jobTitle.isNotEmpty
                    ? resume.personal.jobTitle
                    : '未填写',
                font,
                config,
              ),
              _buildCreativeIntentChip(
                '意向城市',
                resume.personal.expectedCity.isNotEmpty
                    ? resume.personal.expectedCity
                    : '未填写',
                font,
                config,
              ),
              _buildCreativeIntentChip(
                '薪资要求',
                resume.personal.salaryExpectation.isNotEmpty
                    ? resume.personal.salaryExpectation
                    : '未填写',
                font,
                config,
              ),
              _buildCreativeIntentChip(
                '入职时间',
                resume.personal.availableDate.isNotEmpty
                    ? resume.personal.availableDate
                    : '未填写',
                font,
                config,
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 12),

        // ----- 教育背景 -----
        if (resume.educations.isNotEmpty) ...[
          _buildCreativeSectionTitleWithTag(
            '教育背景',
            font,
            boldFont,
            faFont,
            config,
          ),

          pw.Padding(
            padding: pw.EdgeInsets.only(left: config.contentLeftPadding),
            child: pw.Column(
              children: resume.educations.map((edu) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Row(
                    children: [
                      pw.SizedBox(
                        width: 100,
                        child: pw.Text(
                          '${edu.startDate.year}~${edu.endDate?.year ?? '至今'}',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: config.eduFontSize,
                            color: config.textColor,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          edu.degree,
                          style: pw.TextStyle(
                            font: font,
                            fontSize: config.eduFontSize,
                            fontWeight: pw.FontWeight.bold,
                            color: config.textColor,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          edu.school,
                          style: pw.TextStyle(
                            font: font,
                            fontSize: config.eduFontSize,
                            fontWeight: pw.FontWeight.bold,
                            color: config.textColor,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          edu.major.isNotEmpty ? edu.major : '',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: config.eduFontSize,
                            color: config.textColor,
                          ),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          pw.SizedBox(height: 4),
        ],

        // ----- 工作经历 -----
        if (resume.workExperiences.isNotEmpty) ...[
          _buildCreativeSectionTitleWithTag(
            '工作经历',
            font,
            boldFont,
            faFont,
            config,
          ),

          pw.Padding(
            padding: pw.EdgeInsets.only(left: config.contentLeftPadding),
            child: pw.Column(
              children: resume.workExperiences.map((exp) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 12),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        children: [
                          pw.SizedBox(
                            width: 100,
                            child: pw.Text(
                              '${exp.startDate.year}~${exp.endDate?.year ?? '至今'}',
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: config.workFontSize,
                                fontWeight: pw.FontWeight.bold,
                                color: config.textColor,
                              ),
                              textAlign: pw.TextAlign.left,
                            ),
                          ),

                          pw.Expanded(
                            child: pw.Text(
                              exp.company,
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: config.workFontSize,
                                fontWeight: pw.FontWeight.bold,
                                color: config.textColor,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),

                          pw.SizedBox(
                            width: 100,
                            child: pw.Text(
                              exp.position,
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: config.workFontSize,
                                fontWeight: pw.FontWeight.bold,
                                color: config.textColor,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      if (exp.description.isNotEmpty) ...[
                        pw.SizedBox(height: 2),
                        ...exp.description.split('\n').map((line) {
                          final trimmed = line.trim();
                          if (trimmed.isEmpty) return pw.SizedBox.shrink();
                          String content = trimmed;
                          if (content.startsWith('-') ||
                              content.startsWith('•') ||
                              content.startsWith('*')) {
                            content = content.substring(1).trim();
                          }
                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(
                              left: 4,
                              bottom: 2,
                            ),
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: 14,
                                  child: pw.Text(
                                    '-',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontSize: config.descFontSize,
                                      color: config.textColor,
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    content,
                                    style: pw.TextStyle(
                                      font: font,
                                      fontSize: config.descFontSize,
                                      height: 1.2,
                                      color: config.textColor,
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
                );
              }).toList(),
            ),
          ),
        ],

        // ----- 项目经验 -----
        if (resume.projects.isNotEmpty) ...[
          _buildCreativeSectionTitleWithTag(
            '项目经验',
            font,
            boldFont,
            faFont,
            config,
          ),

          pw.Padding(
            padding: pw.EdgeInsets.only(left: config.contentLeftPadding),
            child: pw.Column(
              children: resume.projects.map((proj) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 12),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Text(
                              proj.name,
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: config.projectFontSize,
                                fontWeight: pw.FontWeight.bold,
                                color: config.textColor,
                              ),
                            ),
                          ),

                          pw.Text(
                            ' ------ ',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: config.projectFontSize,
                              color: config.textColor,
                            ),
                          ),
                          pw.Text(
                            ' ${proj.role.isNotEmpty ? proj.role : '未填写'}',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: config.projectFontSize,
                              fontWeight: pw.FontWeight.bold,
                              color: config.textColor,
                            ),
                          ),
                        ],
                      ),
                      if (proj.description.isNotEmpty) ...[
                        pw.SizedBox(height: 2),
                        ...proj.description.split('\n').map((line) {
                          final trimmed = line.trim();
                          if (trimmed.isEmpty) return pw.SizedBox.shrink();
                          String content = trimmed;
                          if (content.startsWith('-') ||
                              content.startsWith('•') ||
                              content.startsWith('*')) {
                            content = content.substring(1).trim();
                          }
                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(
                              left: 4,
                              bottom: 2,
                            ),
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.SizedBox(
                                  width: 14,
                                  child: pw.Text(
                                    '-',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontSize: config.descFontSize,
                                      color: config.textColor,
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    content,
                                    style: pw.TextStyle(
                                      font: font,
                                      fontSize: config.descFontSize,
                                      height: 1.2,
                                      color: config.textColor,
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
                );
              }).toList(),
            ),
          ),
        ],

        // ----- 荣誉奖励 -----
        if (resume.honors.isNotEmpty) ...[
          _buildCreativeSectionTitleWithTag(
            '荣誉奖励',
            font,
            boldFont,
            faFont,
            config,
          ),

          pw.Padding(
            padding: pw.EdgeInsets.only(left: config.contentLeftPadding),
            child: pw.Wrap(
              spacing: 8,
              runSpacing: 8,
              children: resume.honors.map((h) {
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 3,
                  ),
                  decoration: pw.BoxDecoration(
                    color: config.primaryColor.withAlpha(0.05),
                    borderRadius: pw.BorderRadius.circular(8),
                    border: pw.Border.all(
                      color: config.primaryColor.withAlpha(0.05),
                    ),
                  ),
                  child: pw.Text(
                    h,
                    style: pw.TextStyle(
                      font: font,
                      fontSize: config.honorFontSize,
                      color: config.textColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          pw.SizedBox(height: 12),
        ],

        // ----- 技能特长 -----
        if (resume.skills.isNotEmpty) ...[
          _buildCreativeSectionTitleWithTag(
            '技能特长',
            font,
            boldFont,
            faFont,
            config,
          ),

          pw.Padding(
            padding: pw.EdgeInsets.only(left: config.contentLeftPadding),
            child: pw.Wrap(
              spacing: 8,
              runSpacing: 8,
              children: resume.skills.map((s) {
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 3,
                  ),
                  decoration: pw.BoxDecoration(
                    color: config.primaryColor.withAlpha(0.05),
                    borderRadius: pw.BorderRadius.circular(8),
                    border: pw.Border.all(
                      color: config.primaryColor.withAlpha(0.05),
                    ),
                  ),
                  child: pw.Text(
                    s.name,
                    style: pw.TextStyle(
                      font: font,
                      fontSize: config.skillFontSize,
                      color: config.textColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          pw.SizedBox(height: 12),
        ],

        // ----- 自我评价 -----
        if (resume.summary.isNotEmpty) ...[
          _buildCreativeSectionTitleWithTag(
            '自我评价',
            font,
            boldFont,
            faFont,
            config,
          ),

          pw.Padding(
            padding: pw.EdgeInsets.only(left: config.contentLeftPadding),
            child: pw.Text(
              '\u2003\u2003${resume.summary}', // 两个全角空格（U+3000）
              style: pw.TextStyle(
                font: font,
                fontSize: config.summaryFontSize,
                height: 1.2,
                color: config.textColor,
              ),
            ),
          ),
        ],
        pw.SizedBox(height: 20),
      ],
    );
  }

  // ---- ★★★ 创意模板：标题装饰（使用旋转矩形模拟三角形） ★★★ ----
  // ---- 创意模板：标题装饰（两行布局） ----
  /// 第一行：矩形背景 + 右侧三角形 + 底部横线
  /// 第二行：左下角三角形（单独一行，左侧对齐）
  static pw.Widget _buildCreativeSectionTitleWithTag(
    String title,
    pw.Font font,
    pw.Font boldFont,
    pw.Font faFont,
    CreativePdfConfig config,
  ) {
    final titleColor = config.titleBgColor;
    final titleHeight = config.titleHeight;
    final titleFontSize = config.titleFontSize;
    final leftPadding =
        config.contentLeftPadding + config.titlePaddingHorizontal;
    final rightPadding = config.titlePaddingHorizontal;
    final strokeWidth = config.strokeWidth;
    final lineLength = config.titleLineLength;
    final leftW = config.leftTriangleHorizontal;
    final leftH = config.leftTriangleVertical;
    final rightW = config.rightTriangleHorizontal;
    final rightH = config.rightTriangleVertical;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        // ---- 第一行：矩形背景 + 右侧三角形（水平并排），下方紧接横线 ----
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.Row(
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                // 矩形背景（含文字）
                pw.Container(
                  height: titleHeight,
                  padding: pw.EdgeInsets.only(
                    left: leftPadding,
                    right: rightPadding,
                  ),
                  alignment: pw.Alignment.centerLeft,
                  decoration: pw.BoxDecoration(
                    color: titleColor,
                    border: pw.Border(
                      top: pw.BorderSide(color: titleColor, width: strokeWidth),
                      right: pw.BorderSide(
                        color: titleColor,
                        width: strokeWidth,
                      ),
                      bottom: pw.BorderSide(
                        color: titleColor,
                        width: strokeWidth,
                      ),
                    ),
                  ),
                  child: pw.Text(
                    title,
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: titleFontSize,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                // 右侧三角形
                pw.SizedBox(
                  width: rightW,
                  height: rightH,
                  child: pw.CustomPaint(
                    painter: (PdfGraphics graphics, PdfPoint size) {
                      graphics.setFillColor(titleColor);
                      graphics.setStrokeColor(titleColor);
                      graphics.setLineWidth(strokeWidth);
                      graphics.moveTo(0, 0);
                      graphics.lineTo(0, size.y);
                      graphics.lineTo(size.x, 0);
                      graphics.closePath();
                      graphics.setFillColor(titleColor);
                      graphics.fillPath();
                    },
                  ),
                ),
              ],
            ),
            // 底部横线（紧接第一行下方）
            pw.Container(height: 1, width: lineLength, color: titleColor),
          ],
        ),
        // ---- 第二行：左下角三角形（单独一行，与第一行左侧对齐） ----
        pw.SizedBox(
          width: leftW,
          height: leftH,
          child: pw.CustomPaint(
            painter: (PdfGraphics graphics, PdfPoint size) {
              graphics.setFillColor(titleColor);
              graphics.setStrokeColor(titleColor);
              graphics.setLineWidth(strokeWidth);
              // 直角在右上角，朝左和朝下（与之前一致）
              graphics.moveTo(size.x, size.y);
              graphics.lineTo(0, size.y);
              graphics.lineTo(size.x, 0);
              graphics.closePath();
              graphics.setFillColor(titleColor);
              graphics.fillPath();
            },
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildCreativeIntentChip(
    String label,
    String value,
    pw.Font font,
    CreativePdfConfig config,
  ) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text(
          '$label：',
          style: pw.TextStyle(
            font: font,
            fontSize: config.intentChipLabelFontSize,
            color: config.textColor,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            font: font,
            fontSize: config.intentChipValueFontSize,
            fontWeight: pw.FontWeight.normal,
            color: config.textColor,
          ),
        ),
      ],
    );
  }

  // ================================================================
  // 经典模板构建方法
  // ================================================================
  static List<pw.Widget> _buildClassicContent(
    Resume resume,
    pw.Font font,
    pw.Font boldFont,
    pw.Font faFont,
    ClassicPdfConfig config,
  ) {
    final List<pw.Widget> content = [];

    // ---- 头部（不含头像） ----
    final header = _buildClassicHeaderWithoutAvatar(
      resume,
      font,
      boldFont,
      faFont,
      config,
    );

    // ---- 装饰条 ----
    final deco = _buildClassicDecorations(config);

    // ---- 头像（独立） ----
    final avatar = _buildClassicAvatar(resume, config);

    // ---- 整个头部区域用 Stack 组合 ----
    content.add(
      pw.Stack(
        children: [
          // 背景：头部 + 装饰条
          pw.Column(children: [header, deco]),
          // 头像：浮动在右上角
          pw.Positioned(
            top: config.avatarTopOffset,
            right:
                config.avatarRightOffset +
                config.headerPaddingLeft, // 与 Flutter 版本对齐
            child: avatar,
          ),
        ],
      ),
    );

    // ---- 头部与内容间距 ----
    content.add(pw.SizedBox(height: config.sectionSpacing));
    // ---- 内容区域（章节） ----
    content.add(
      pw.Padding(
        padding: pw.EdgeInsets.symmetric(
          horizontal: config.contentPaddingHorizontal,
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (resume.educations.isNotEmpty) ...[
              _buildClassicSectionTitle(
                '教育背景',
                0xf19d,
                font,
                boldFont,
                faFont,
                config,
              ),
              pw.SizedBox(height: config.itemSpacing),
              ...resume.educations.map(
                (edu) => _buildClassicEducationItem(edu, font, config),
              ),
              pw.SizedBox(height: config.sectionSpacing),
            ],
            if (resume.workExperiences.isNotEmpty) ...[
              _buildClassicSectionTitle(
                '工作经历',
                0xf0b1,
                font,
                boldFont,
                faFont,
                config,
              ),
              pw.SizedBox(height: config.itemSpacing),
              ...resume.workExperiences.map(
                (exp) => _buildClassicWorkItem(exp, font, boldFont, config),
              ),
              pw.SizedBox(height: config.sectionSpacing),
            ],
            if (resume.projects.isNotEmpty) ...[
              _buildClassicSectionTitle(
                '项目经验',
                0xf07c,
                font,
                boldFont,
                faFont,
                config,
              ),
              pw.SizedBox(height: config.itemSpacing),
              ...resume.projects.map(
                (proj) =>
                    _buildClassicProjectItem(proj, font, boldFont, config),
              ),
              pw.SizedBox(height: config.sectionSpacing),
            ],
            if (resume.skills.isNotEmpty ||
                resume.honors.isNotEmpty ||
                resume.languages.isNotEmpty) ...[
              _buildClassicSectionTitle(
                '个人技能',
                0xf0b0,
                font,
                boldFont,
                faFont,
                config,
              ),
              pw.SizedBox(height: config.itemSpacing),
              _buildClassicSkillSection(resume, font, config),
              pw.SizedBox(height: config.sectionSpacing),
            ],
            if (resume.summary.isNotEmpty) ...[
              _buildClassicSectionTitle(
                '个人评价',
                0xf007,
                font,
                boldFont,
                faFont,
                config,
              ),
              pw.SizedBox(height: config.itemSpacing),
              pw.Text(
                '${config.summaryIndent}${resume.summary}',
                style: pw.TextStyle(
                  font: font,
                  fontSize: config.summaryFontSize,
                  height: config.summaryHeight,
                ),
              ),
              pw.SizedBox(height: config.sectionSpacing),
            ],
          ],
        ),
      ),
    );
    pw.SizedBox(height: 20);
    return content;
  }

  // ---- 经典模板：头部 ----
  static pw.Widget _buildClassicHeaderWithoutAvatar(
    Resume resume,
    pw.Font font,
    pw.Font boldFont,
    pw.Font faFont,
    ClassicPdfConfig config,
  ) {
    final column1 = <pw.Widget>[];
    final column2 = <pw.Widget>[];

    column1.add(
      _buildClassicHeaderInfo(
        '姓名:',
        resume.personal.fullName.isNotEmpty ? resume.personal.fullName : '未填写',
        font,
        config,
      ),
    );
    column1.add(
      _buildClassicHeaderInfo(
        '出生:',
        resume.personal.birthDate ?? '未填写',
        font,
        config,
      ),
    );
    column1.add(
      _buildClassicHeaderInfo(
        '籍贯:',
        resume.personal.birthPlace ?? '未填写',
        font,
        config,
      ),
    );

    column2.add(
      _buildClassicHeaderInfo(
        '电子邮箱:',
        resume.personal.email.isNotEmpty ? resume.personal.email : '未填写',
        font,
        config,
      ),
    );
    column2.add(
      _buildClassicHeaderInfo(
        '求职意向:',
        resume.personal.jobTitle.isNotEmpty ? resume.personal.jobTitle : '未填写',
        font,
        config,
      ),
    );
    column2.add(
      _buildClassicHeaderInfo(
        '联系电话:',
        resume.personal.phone.isNotEmpty ? resume.personal.phone : '未填写',
        font,
        config,
      ),
    );

    // 头部内容
    return pw.Container(
      width: double.infinity,
      padding: pw.EdgeInsets.symmetric(
        vertical: config.headerPaddingVertical,
        horizontal: config.headerPaddingLeft,
      ),
      color: config.headerBgColor,
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 1,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: column1,
            ),
          ),
          pw.SizedBox(width: config.headerColumnSpacing),
          pw.Expanded(
            flex: 2,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: column2,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildClassicAvatar(Resume resume, ClassicPdfConfig config) {
    return pw.Container(
      width: config.avatarSize,
      height: config.avatarSize,
      decoration: pw.BoxDecoration(
        color: pdf.PdfColors.white,
        border: pw.Border.all(color: pdf.PdfColors.white.withAlpha(0.3)),
      ),
      child: resume.personal.avatarImage != null
          ? pw.Image(
              pw.MemoryImage(resume.personal.avatarImage!),
              fit: pw.BoxFit.cover,
            )
          : pw.Center(
              child: pw.Icon(
                pw.IconData(0xf007),
                size: 50,
                color: pdf.PdfColors.grey,
              ),
            ),
    );
  }

  /// 构建经典模板的装饰条（两条平行四边形）
  static pw.Widget _buildClassicDecorations(ClassicPdfConfig config) {
    return pw.Container(
      height: config.decoContainerHeight,
      child: pw.Stack(
        children: [
          // 左侧平行四边形（左边缘垂直）
          pw.Positioned(
            left: 0,
            top: config.decoLeftTopOffset,
            child: pw.SizedBox(
              width: config.decoLeftWidth,
              height: config.decoLeftHeight,
              child: pw.CustomPaint(
                painter: (pdf.PdfGraphics graphics, pdf.PdfPoint size) {
                  graphics.setFillColor(config.decoLeftColor);
                  final skewOffset = size.y * config.decoSkew;
                  // 左下 → 左上 → 右上（倾斜）→ 右下
                  graphics.moveTo(0, size.y);
                  graphics.lineTo(0, 0);
                  graphics.lineTo(size.x + skewOffset, 0);
                  graphics.lineTo(size.x, size.y);
                  graphics.closePath();
                  graphics.fillPath();
                },
              ),
            ),
          ),
          // 右侧平行四边形（右边缘垂直）
          pw.Positioned(
            right: 0,
            top: config.decoRightTopOffset,
            child: pw.SizedBox(
              width: config.decoRightWidth,
              height: config.decoRightHeight,
              child: pw.CustomPaint(
                painter: (pdf.PdfGraphics graphics, pdf.PdfPoint size) {
                  graphics.setFillColor(config.decoRightColor);
                  final skewOffset = size.y * config.decoSkew;
                  // 左上（倾斜）→ 右上 → 右下 → 左下
                  graphics.moveTo(skewOffset, 0);
                  graphics.lineTo(size.x, 0);
                  graphics.lineTo(size.x, size.y);
                  graphics.lineTo(0, size.y);
                  graphics.closePath();
                  graphics.fillPath();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildClassicHeaderInfo(
    String label,
    String value,
    pw.Font font,
    ClassicPdfConfig config,
  ) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: config.headerItemSpacing),
      child: pw.Row(
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              font: font,
              fontSize: config.headerLabelFontSize,
              color: config.headerTextColor,
            ),
          ),
          pw.SizedBox(width: 8),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                font: font,
                fontSize: config.headerValueFontSize,
                color: config.headerTextColor,
              ),
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }

  // ---- 经典模板：章节标题（带左侧小长方形 + 右侧延伸矩形） ----
  static pw.Widget _buildClassicSectionTitle(
    String title,
    int iconCode,
    pw.Font font,
    pw.Font boldFont,
    pw.Font faFont,
    ClassicPdfConfig config,
  ) {
    // 左侧小长方形
    final leftBar = pw.Container(
      width: config.sectionLeftBarWidth,
      height: config.sectionLeftBarHeight,
      color: config.sectionTitleBgColor,
    );

    // 标题主体
    final titleMain = pw.Container(
      height: config.sectionTitleHeight,
      padding: pw.EdgeInsets.symmetric(
        horizontal: config.sectionTitlePaddingHorizontal,
      ),
      color: config.sectionTitleBgColor,
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            String.fromCharCode(iconCode),
            style: pw.TextStyle(
              font: faFont,
              fontSize: config.sectionTitleIconSize,
              color: config.sectionTitleTextColor,
            ),
          ),
          pw.SizedBox(width: 8),
          pw.Text(
            title,
            style: pw.TextStyle(
              font: boldFont,
              fontSize: config.sectionTitleFontSize,
              fontWeight: pw.FontWeight.bold,
              color: config.sectionTitleTextColor,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );

    // 右侧延伸矩形
    final rightBar = pw.Container(
      height: config.sectionRightBarHeight,
      color: config.sectionRightBarColor,
    );

    return pw.Row(
      children: [
        leftBar,
        pw.SizedBox(width: config.sectionLeftBarSpacing),
        titleMain,
        pw.SizedBox(width: 8),
        pw.Expanded(child: rightBar),
      ],
    );
  }

  // ---- 经典模板：教育经历 ----
  static pw.Widget _buildClassicEducationItem(
    Education edu,
    pw.Font font,
    ClassicPdfConfig config,
  ) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: config.eduItemSpacing),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.SizedBox(
                width: config.eduTimeWidth,
                child: pw.Text(
                  '${edu.startDate.year}.${edu.startDate.month.toString().padLeft(2, '0')} - ${edu.endDate?.year ?? '至今'}',
                  style: pw.TextStyle(font: font, fontSize: config.eduFontSize),
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  edu.school,
                  style: pw.TextStyle(font: font, fontSize: config.eduFontSize),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Expanded(
                flex: 1,
                child: pw.Text(
                  edu.degree,
                  style: pw.TextStyle(font: font, fontSize: config.eduFontSize),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Expanded(
                flex: 1,
                child: pw.Text(
                  edu.major,
                  style: pw.TextStyle(font: font, fontSize: config.eduFontSize),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
          if (edu.description.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              edu.description,
              style: pw.TextStyle(
                font: font,
                fontSize: config.eduDescriptionFontSize,
                height: config.eduDescriptionHeight,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---- 经典模板：工作经历 ----
  static pw.Widget _buildClassicWorkItem(
    WorkExperience exp,
    pw.Font font,
    pw.Font boldFont,
    ClassicPdfConfig config,
  ) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: config.workItemSpacing),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Text(
                '${exp.startDate.year}.${exp.startDate.month.toString().padLeft(2, '0')} - ${exp.endDate?.year ?? '至今'}',
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: config.workTimeFontSize,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(width: config.workTimeCompanySpacing),
              pw.Text(
                exp.company,
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: config.workCompanyFontSize,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.Text(
            '岗位：${exp.position}',
            style: pw.TextStyle(
              font: font,
              fontSize: config.workPositionFontSize,
            ),
          ),
          if (exp.description.isNotEmpty) ...[
            pw.SizedBox(height: 4),
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
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 12, bottom: 2),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          '• ',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: config.workDescriptionFontSize,
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            cleaned,
                            style: pw.TextStyle(
                              font: font,
                              fontSize: config.workDescriptionFontSize,
                              height: config.workDescriptionHeight,
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
    );
  }

  // ---- 经典模板：项目经验 ----
  static pw.Widget _buildClassicProjectItem(
    Project proj,
    pw.Font font,
    pw.Font boldFont,
    ClassicPdfConfig config,
  ) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: config.projectItemSpacing),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            proj.name,
            style: pw.TextStyle(
              font: boldFont,
              fontSize: config.projectNameFontSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          if (proj.role.isNotEmpty)
            pw.Text(
              '角色：${proj.role}',
              style: pw.TextStyle(
                font: font,
                fontSize: config.projectRoleFontSize,
              ),
            ),
          if (proj.description.isNotEmpty) ...[
            pw.SizedBox(height: 4),
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
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 12, bottom: 2),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          '• ',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: config.projectDescriptionFontSize,
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            cleaned,
                            style: pw.TextStyle(
                              font: font,
                              fontSize: config.projectDescriptionFontSize,
                              height: config.projectDescriptionHeight,
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
    );
  }

  // ---- 经典模板：个人技能（合并技能、荣誉、语言） ----
  static pw.Widget _buildClassicSkillSection(
    Resume resume,
    pw.Font font,
    ClassicPdfConfig config,
  ) {
    final List<pw.Widget> rows = [];

    if (resume.skills.isNotEmpty) {
      rows.add(
        _buildClassicSkillRow(
          '技　　能:',
          resume.skills.map((s) => s.name).toList(),
          font,
          config,
        ),
      );
    }
    if (resume.honors.isNotEmpty) {
      rows.add(_buildClassicSkillRow('荣誉奖励:', resume.honors, font, config));
    }
    if (resume.languages.isNotEmpty) {
      rows.add(_buildClassicSkillRow('语言能力:', resume.languages, font, config));
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: rows,
    );
  }

  static pw.Widget _buildClassicSkillRow(
    String label,
    List<String> items,
    pw.Font font,
    ClassicPdfConfig config,
  ) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: config.skillItemSpacing),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: config.skillLabelWidth,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                font: font,
                fontSize: config.skillLabelFontSize,
                fontWeight: pw.FontWeight.normal,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              items.join('、'),
              style: pw.TextStyle(
                font: font,
                fontSize: config.skillValueFontSize,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // 深色模板构建方法
  // ================================================================

  static pw.Widget _buildDarkContent(
    Resume resume,
    pw.Font font,
    pw.Font boldFont,
    pw.Font faFont,
    DarkPdfConfig config,
  ) {
    // ---- 头部 ----
    final headerWidget = pw.Stack(
      children: [
        pw.Column(
          children: [
            _buildDarkHeader(resume, font, boldFont, config),
            pw.Container(
              height: config.dividerHeight,
              color: config.dividerColor,
            ),
          ],
        ),
        pw.Positioned(
          left: config.avatarLeftOffset1,
          top: config.headerHeight - config.avatarSize - 15,
          child: _buildDarkAvatar(resume, config),
        ),
      ],
    );

    // ---- 左右栏内容（不带背景） ----
    final leftContent = _buildDarkLeftContent(
      resume,
      font,
      boldFont,
      faFont,
      config,
    );
    final rightContent = _buildDarkRightContent(
      resume,
      font,
      boldFont,
      faFont,
      config,
    );

    // ---- 使用 LayoutBuilder 获取可用高度 ----
    return pw.LayoutBuilder(
      builder: (context, constraints) {
        final double maxHeight = (constraints?.maxHeight ?? 0.0).toDouble();
        final double maxWidth = (constraints?.maxWidth ?? 0.0).toDouble();

        final double headerHeight = config.headerHeight + config.dividerHeight;
        final double availableHeight =
            maxHeight - headerHeight - config.sectionSpacing;
        final double bodyHeight = availableHeight > 0 ? availableHeight : 0.0;

        return pw.Column(
          children: [
            headerWidget,
            pw.SizedBox(height: config.sectionSpacing),
            pw.Container(
              height: bodyHeight,
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Container(
                    width: maxWidth * config.leftWidthFactor,
                    color: config.leftBgColor,
                    padding: pw.EdgeInsets.all(config.contentPadding),
                    child: leftContent,
                  ),
                  pw.Container(
                    width: maxWidth * config.rightWidthFactor,
                    color: config.rightBgColor,
                    padding: pw.EdgeInsets.all(config.contentPadding),
                    child: rightContent,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // ---- 深色模板：头像 ----
  static pw.Widget _buildDarkAvatar(Resume resume, DarkPdfConfig config) {
    return pw.Container(
      width: config.avatarSize,
      height: config.avatarSize,
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(config.avatarCornerRadius),
        boxShadow: [
          pw.BoxShadow(
            color: PdfColors.black.withAlpha(0.26),
            blurRadius: 8,
            offset: pdf.PdfPoint(0, 4),
          ),
        ],
      ),
      child: pw.ClipRRect(
        horizontalRadius: config.avatarCornerRadius, // 水平圆角半径
        verticalRadius: config.avatarCornerRadius, // 垂直圆角半径
        child: resume.personal.avatarImage != null
            ? pw.Image(
                pw.MemoryImage(resume.personal.avatarImage!),
                fit: pw.BoxFit.cover,
              )
            : pw.Center(
                child: pw.Icon(
                  pw.IconData(0xf007),
                  size: 60,
                  color: PdfColors.grey,
                ),
              ),
      ),
    );
  }

  // ---- 深色模板：头部 ----
  static pw.Widget _buildDarkHeader(
    Resume resume,
    pw.Font font,
    pw.Font boldFont,
    DarkPdfConfig config,
  ) {
    final name = resume.personal.fullName.isNotEmpty
        ? resume.personal.fullName
        : '未填写';
    final job = resume.personal.jobTitle.isNotEmpty
        ? resume.personal.jobTitle
        : '未填写';

    return pw.Container(
      height: config.headerHeight,
      width: double.infinity,
      color: config.headerBgColor,
      padding: pw.EdgeInsets.symmetric(
        horizontal: config.headerPaddingHorizontal,
        vertical: config.headerPaddingVertical,
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(width: config.avatarSize + 45), // 留白给头像
          pw.Expanded(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  name,
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: config.headerNameFontSize,
                    fontWeight: pw.FontWeight.bold,
                    color: config.darkTextColor,
                    letterSpacing: 2,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  '求职意向：$job',
                  style: pw.TextStyle(
                    font: font,
                    fontSize: config.headerJobFontSize,
                    color: config.darkTextColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                '个人简历',
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: config.darkTextColor,
                  letterSpacing: 4,
                ),
              ),
              pw.Text(
                'RESUME',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 12,
                  color: config.darkTextColor,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- 深色模板：左侧内容 ----
  static pw.Widget _buildDarkLeftContent(
    Resume resume,
    pw.Font font,
    pw.Font boldFont,
    pw.Font faFont,
    DarkPdfConfig config,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildDarkSectionTitle('基础信息', 0xf007, font, boldFont, faFont, config),
        pw.SizedBox(height: config.itemSpacing),
        _buildDarkInfoSection(resume, font, config),
        pw.SizedBox(height: config.sectionSpacing),

        if (resume.skills.isNotEmpty) ...[
          _buildDarkSectionTitle(
            '个人技能',
            0xf0b0,
            font,
            boldFont,
            faFont,
            config,
          ),
          pw.SizedBox(height: config.itemSpacing),
          _buildDarkSkillList(
            resume.skills.map((s) => s.name).toList(),
            font,
            config,
          ),
          pw.SizedBox(height: config.sectionSpacing),
        ],

        if (resume.honors.isNotEmpty) ...[
          _buildDarkSectionTitle(
            '荣誉奖励',
            0xf091,
            font,
            boldFont,
            faFont,
            config,
          ),
          pw.SizedBox(height: config.itemSpacing),
          _buildDarkSkillList(resume.honors, font, config),
          pw.SizedBox(height: config.sectionSpacing),
        ],

        if (resume.languages.isNotEmpty) ...[
          _buildDarkSectionTitle(
            '语言能力',
            0xf1ab,
            font,
            boldFont,
            faFont,
            config,
          ),
          pw.SizedBox(height: config.itemSpacing),
          _buildDarkSkillList(resume.languages, font, config),
          pw.SizedBox(height: config.sectionSpacing),
        ],
      ],
    );
  }

  // ---- 深色模板：右侧内容 ----
  static pw.Widget _buildDarkRightContent(
    Resume resume,
    pw.Font font,
    pw.Font boldFont,
    pw.Font faFont,
    DarkPdfConfig config,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (resume.educations.isNotEmpty) ...[
          _buildDarkSectionTitle(
            '教育经历',
            0xf19d,
            font,
            boldFont,
            faFont,
            config,
          ),
          pw.SizedBox(height: config.itemSpacing),
          ...resume.educations.map(
            (edu) => _buildDarkEducationItem(edu, font, config),
          ),
          pw.SizedBox(height: config.sectionSpacing),
        ],

        if (resume.workExperiences.isNotEmpty) ...[
          _buildDarkSectionTitle(
            '工作经历',
            0xf0b1,
            font,
            boldFont,
            faFont,
            config,
          ),
          pw.SizedBox(height: config.itemSpacing),
          ...resume.workExperiences.map(
            (exp) => _buildDarkWorkItem(exp, font, boldFont, config),
          ),
          pw.SizedBox(height: config.sectionSpacing),
        ],

        if (resume.projects.isNotEmpty) ...[
          _buildDarkSectionTitle(
            '项目经验',
            0xf07c,
            font,
            boldFont,
            faFont,
            config,
          ),
          pw.SizedBox(height: config.itemSpacing),
          ...resume.projects.map(
            (proj) => _buildDarkProjectItem(proj, font, boldFont, config),
          ),
          pw.SizedBox(height: config.sectionSpacing),
        ],

        if (resume.summary.isNotEmpty) ...[
          _buildDarkSectionTitle(
            '自我评价',
            0xf007,
            font,
            boldFont,
            faFont,
            config,
          ),
          pw.SizedBox(height: config.itemSpacing),
          pw.Text(
            '\u2003\u2003${resume.summary}',
            style: pw.TextStyle(
              font: font,
              fontSize: config.summaryFontSize,
              height: config.summaryHeight,
              color: config.lightTextColor,
            ),
          ),
          pw.SizedBox(height: config.sectionSpacing),
          pw.SizedBox(height: 20),
        ],
      ],
    );
  }

  // ---- 深色模板：章节标题 ----
  static pw.Widget _buildDarkSectionTitle(
    String title,
    int iconCode,
    pw.Font font,
    pw.Font boldFont,
    pw.Font faFont,
    DarkPdfConfig config,
  ) {
    return pw.Container(
      width: double.infinity,
      height: config.sectionTitleHeight,
      padding: pw.EdgeInsets.symmetric(
        horizontal: config.sectionTitlePaddingHorizontal,
      ),
      color: config.sectionTitleBgColor,
      child: pw.Row(
        children: [
          pw.Text(
            String.fromCharCode(iconCode),
            style: pw.TextStyle(
              font: faFont,
              fontSize: config.sectionTitleIconSize,
              color: config.sectionTitleTextColor,
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Text(
            title,
            style: pw.TextStyle(
              font: boldFont,
              fontSize: config.sectionTitleFontSize,
              fontWeight: pw.FontWeight.bold,
              color: config.sectionTitleTextColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ---- 深色模板：基础信息 ----
  static pw.Widget _buildDarkInfoSection(
    Resume resume,
    pw.Font font,
    DarkPdfConfig config,
  ) {
    final personal = resume.personal;
    final items = <String, String>{
      '姓名': personal.fullName.isNotEmpty ? personal.fullName : '未填写',
      '出生日期': personal.birthDate ?? '未填写',
      '学历': _getHighestDegreeInternal(resume),
      '电话': personal.phone.isNotEmpty ? personal.phone : '未填写',
      '邮箱': personal.email.isNotEmpty ? personal.email : '未填写',
      '民族': personal.nation ?? '未填写',
      '籍贯': personal.birthPlace ?? '未填写',
    };

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: items.entries.map((entry) {
        return pw.Padding(
          padding: pw.EdgeInsets.only(bottom: config.infoItemSpacing),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                entry.key + '：',
                style: pw.TextStyle(
                  font: font,
                  fontSize: config.infoFontSize,
                  fontWeight: pw.FontWeight.normal,
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  entry.value,
                  style: pw.TextStyle(
                    font: font,
                    fontSize: config.infoFontSize,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  static String _getHighestDegreeInternal(Resume resume) {
    if (resume.educations.isEmpty) return '未填写';
    final sorted = List<Education>.from(resume.educations)
      ..sort(
        (a, b) => (b.endDate ?? DateTime.now()).compareTo(
          a.endDate ?? DateTime.now(),
        ),
      );
    return sorted.first.degree;
  }

  // ---- 深色模板：技能列表 ----
  static pw.Widget _buildDarkSkillList(
    List<String> items,
    pw.Font font,
    DarkPdfConfig config,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: items.map((item) {
        return pw.Padding(
          padding: pw.EdgeInsets.only(bottom: config.skillItemSpacing),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '• ',
                style: pw.TextStyle(font: font, fontSize: config.skillFontSize),
              ),
              pw.Expanded(
                child: pw.Text(
                  item,
                  style: pw.TextStyle(
                    font: font,
                    fontSize: config.skillFontSize,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ---- 深色模板：教育经历 ----
  static pw.Widget _buildDarkEducationItem(
    Education edu,
    pw.Font font,
    DarkPdfConfig config,
  ) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: config.eduItemSpacing),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.SizedBox(
                width: config.eduTimeWidth,
                child: pw.Text(
                  '${edu.startDate.year}.${edu.startDate.month.toString().padLeft(2, '0')} - ${edu.endDate?.year ?? '至今'}',
                  style: pw.TextStyle(font: font, fontSize: config.eduFontSize),
                  textAlign: pw.TextAlign.left,
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                flex: 3,
                child: pw.Text(
                  edu.school,
                  style: pw.TextStyle(font: font, fontSize: config.eduFontSize),
                  textAlign: pw.TextAlign.left,
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                flex: 1,
                child: pw.Text(
                  edu.degree,
                  style: pw.TextStyle(font: font, fontSize: config.eduFontSize),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  edu.major,
                  style: pw.TextStyle(font: font, fontSize: config.eduFontSize),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
          if (edu.description.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              edu.description,
              style: pw.TextStyle(
                font: font,
                fontSize: config.eduDescriptionFontSize,
                height: config.eduDescriptionHeight,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---- 深色模板：工作经历 ----
  static pw.Widget _buildDarkWorkItem(
    WorkExperience exp,
    pw.Font font,
    pw.Font boldFont,
    DarkPdfConfig config,
  ) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: config.workItemSpacing),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.SizedBox(
                width: config.workTimeWidth,
                child: pw.Text(
                  '${exp.startDate.year}.${exp.startDate.month.toString().padLeft(2, '0')} - ${exp.endDate?.year ?? '至今'}',
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: config.workTimeFontSize,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.left,
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: pw.Text(
                  exp.company,
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: config.workCompanyFontSize,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
          pw.Text(
            '岗位：${exp.position}',
            style: pw.TextStyle(
              font: font,
              fontSize: config.workPositionFontSize,
            ),
          ),
          if (exp.description.isNotEmpty) ...[
            pw.SizedBox(height: 4),
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
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 12, bottom: 2),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          '• ',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: config.workDescriptionFontSize,
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            cleaned,
                            style: pw.TextStyle(
                              font: font,
                              fontSize: config.workDescriptionFontSize,
                              height: config.workDescriptionHeight,
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
    );
  }

  // ---- 深色模板：项目经验 ----
  static pw.Widget _buildDarkProjectItem(
    Project proj,
    pw.Font font,
    pw.Font boldFont,
    DarkPdfConfig config,
  ) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: config.projectItemSpacing),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Text(
                  proj.name,
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: config.projectNameFontSize,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.left,
                ),
              ),
              pw.SizedBox(width: 40),
              pw.Expanded(
                child: pw.Text(
                  '角色：${proj.role.isNotEmpty ? proj.role : '未填写'}',
                  style: pw.TextStyle(
                    font: font,
                    fontSize: config.projectRoleFontSize,
                  ),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
          if (proj.description.isNotEmpty) ...[
            pw.SizedBox(height: 4),
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
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 12, bottom: 2),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          '• ',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: config.projectDescriptionFontSize,
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            cleaned,
                            style: pw.TextStyle(
                              font: font,
                              fontSize: config.projectDescriptionFontSize,
                              height: config.projectDescriptionHeight,
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
    );
  }
}
