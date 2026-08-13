// lib/ads/rewarded_ad_button.dart
import 'package:flutter/material.dart';
import 'ad_manager.dart';

class RewardedAdButton extends StatelessWidget {
  final VoidCallback onRewarded;
  final String label;
  final IconData icon;

  const RewardedAdButton({
    super.key,
    required this.onRewarded,
    this.label = '观看广告获取奖励',
    this.icon = Icons.play_circle_outline,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        // 显示加载遮罩
        final overlay = Overlay.of(context);
        OverlayEntry? entry;

        // 创建遮罩
        entry = OverlayEntry(
          builder: (ctx) => Material(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('加载广告中...', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        );

        // 插入遮罩
        overlay.insert(entry);

        try {
          // 调用广告管理器
          await AdManager.showRewardedAd(() {
            // 奖励回调：先移除遮罩，再触发奖励
            entry?.remove();
            onRewarded();
          });
        } catch (e) {
          // 异常时也移除遮罩
          entry?.remove();
          // 可选：显示错误提示
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('广告加载失败: $e')));
          }
        } finally {
          // 确保遮罩被移除（安全兜底）
          // 使用 Future.delayed 给动画一点时间，避免闪烁
          Future.delayed(const Duration(milliseconds: 500), () {
            entry?.remove();
            entry = null;
          });
        }
      },
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blue,
        side: const BorderSide(color: Colors.blue),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}
