import 'package:flutter/material.dart';

class LoadingService {
  static OverlayEntry? _overlayEntry;

  /// 显示加载指示器
  static void show(BuildContext context, {String message = '加载中...'}) {
    hide(); // 先移除已有的

    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade800
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final overlay = Overlay.of(context);
    if (overlay.mounted) {
      overlay.insert(_overlayEntry!);
    }
  }

  /// 隐藏加载指示器
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// 检查是否正在显示
  static bool get isShowing => _overlayEntry != null;
}