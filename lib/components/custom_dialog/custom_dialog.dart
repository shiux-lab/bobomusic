// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String? title;
  final Widget body;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CustomDialog({
    Key? key,
    this.title,
    required this.body,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 标题和关闭按钮区域
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4, bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(
                    title!,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: onCancel,
                  ),
                ],
              ),
            ),
          // 内容区域
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: body,
          ),
          // 底部按钮区域
          Container(
            padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text('取消', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 20),
                FilledButton(
                  onPressed: onConfirm,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('确认'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
