import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';
import 'editor_page.dart';
import 'models/resume.dart';
import 'login_page.dart';
import 'settings_page.dart';
import 'splash_screen.dart';
import 'member_center_page.dart';

// 全局主题模式通知器（用于动态切换）
final ValueNotifier<String> themeNotifier = ValueNotifier(
  'dark',
); // 'dark' 或 'light'

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化 Hive（存储简历数据）
  await Hive.initFlutter();
  await Hive.openBox<String>('resumes_json');

  final box = Hive.box<String>('resumes_json');
  debugPrint('📦 Box 中现有数据条数: ${box.keys.length}');
  for (var key in box.keys) {
    debugPrint('Key: $key, Value: ${box.get(key)}');
  }

  // 加载主题偏好（使用 SharedPreferences）
  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('themeMode') ?? 'dark';
  themeNotifier.value = savedTheme;

  // 加载字体（非阻塞）
  try {
    final data = await rootBundle.load('assets/fonts/SourceHanSansCN-VF.ttf');
    debugPrint('字体加载成功，大小：${data.lengthInBytes}');
  } catch (e) {
    debugPrint('字体加载失败：$e');
  }

  runApp(const MyApp());
}

/// 亮色主题配置
ThemeData _lightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: const Color(0xFF7C3AED), // 紫色
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF7C3AED),
      secondary: Color(0xFF06B6D4), // 青色
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.grey.shade100,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF7C3AED),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade200,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
    ),
  );
}

/// 暗色主题配置（当前风格）
ThemeData _darkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF7C3AED), // 紫色
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF7C3AED),
      secondary: Color(0xFF06B6D4), // 青色
      surface: Color(0xFF1E1E2E), // 深灰背景
    ),
    scaffoldBackgroundColor: const Color(0xFF1E1E2E),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Color(0xFF2D2D3A),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF7C3AED),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2D2D3A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/editor',
      name: 'editor',
      builder: (context, state) {
        final resume = state.extra as Resume?;
        return EditorPage(resume: resume);
      },
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginDialog()),
    GoRoute(
      path: '/member_center',
      name: 'member_center',
      builder: (context, state) => const MemberCenterPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '简历编辑器',
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF7C3AED),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7C3AED),
          secondary: Color(0xFF06B6D4),
          surface: Color(0xFF1E1E2E),
        ),
        scaffoldBackgroundColor: const Color(0xFF1E1E2E),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xFF2D2D3A),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF7C3AED),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2D2D3A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 12,
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}
