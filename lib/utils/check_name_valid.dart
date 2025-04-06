import "package:bobomusic/utils/measure_text_width.dart";
import "package:bot_toast/bot_toast.dart";
import "package:flutter/material.dart";

checkNameValid(String newName, String? oldName) {
  if (newName.isEmpty && (oldName != null && oldName.isEmpty)) {
    BotToast.showText(text: "名称不能为空", duration: const Duration(seconds: 2));
    return false;
  }

  if (newName == oldName) {
    return true;
  }

  if (RegExp(r"^\d+$").hasMatch(newName)) {
    BotToast.showText(text: "名称不能全是数字", duration: const Duration(seconds: 2));
    return false;
  }

  if (RegExp(r"^\d+").hasMatch(newName)) {
    BotToast.showText(text: "名称不能以数字开头", duration: const Duration(seconds: 2));
    return false;
  }

  if (measureTextWidth(newName, const TextStyle(fontSize: 14)) < 16) {
    BotToast.showText(text: "名称长度太短", duration: const Duration(seconds: 2));
    return false;
  }
}