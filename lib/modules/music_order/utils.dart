import "dart:async";

import "package:bobomusic/components/add_to_order/add_to_order.dart";
import "package:bobomusic/constants/cache_key.dart";
import "package:bobomusic/db/db.dart";
import "package:bobomusic/origin_sdk/origin_types.dart";
import "package:bobomusic/utils/check_name_valid.dart";
import "package:bot_toast/bot_toast.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

Future<List<String>> getCustomOrderList() async {
  final localStorage = await SharedPreferences.getInstance();
  final List<String> nameList = localStorage.getStringList(CacheKey.customOrder) ?? [];
  return nameList.where((e) => e.isNotEmpty).toList();
}

Future<List<String>> getAllOrderList() async {
  final customOrderList = await getCustomOrderList();
  return [TableName.musicLocal, TableName.musicILike, ...customOrderList];
}

Future<bool> checkOrderName({ required String newName, String? oldName }) async {
  if (!checkNameValid(newName, oldName)) {
    return false;
  }

  final localStorage = await SharedPreferences.getInstance();
  final List<String> nameList = localStorage.getStringList(CacheKey.customOrder) ?? [];

  if ([TableName.musicILike, TableName.musicLocal, ...nameList].contains(newName)) {
    BotToast.showText(text: "歌单已经存在", duration: const Duration(seconds: 2));
    return false;
  }

  return true;
}

Future<bool> setCustomOrderItem({ required String newName, String? oldName }) async {
  final localStorage = await SharedPreferences.getInstance();
  final List<String> nameList = localStorage.getStringList(CacheKey.customOrder) ?? [];

  if (oldName != null) {
    // 遍历列表，将 oldName 替换为 newName
    for (int i = 0; i < nameList.length; i++) {
      if (nameList[i] == oldName) {
        nameList[i] = newName;
      }
    }
  } else {
    if (nameList.length == 20) {
      BotToast.showText(text: "歌单最多创建 20 个", duration: const Duration(seconds: 2));
      return false;
    }
    nameList.add(newName);
  }
  // 将更新后的列表存回本地缓存
  await localStorage.setStringList(CacheKey.customOrder, nameList);

  return true;
}

delCustomOrderItem({required String name}) async {
  final localStorage = await SharedPreferences.getInstance();
  final List<String> nameList = localStorage.getStringList(CacheKey.customOrder) ?? [];

  nameList.remove(name);

  // 将更新后的列表存回本地缓存
  await localStorage.setStringList(CacheKey.customOrder, nameList);
}

/// 收藏进歌单
collectToMusicOrder({required context, required musicList, onConfirm}) {
  Navigator.of(context, rootNavigator: false).push(ModalBottomSheetRoute(
    isScrollControlled: true,
    builder: (context) {
      return AddToOrder(wantToCollectMusics: musicList, onConfirm: onConfirm);
    },
  ));
}

Future<List<MusicItem>> findMusicFromNotLocalOrders({required String param}) async {
  final DBOrder db = DBOrder();
  final list = await getCustomOrderList();
  List<MusicItem> musics = [];

  for (var order in [TableName.musicILike, ...list]) {
    final dbMusics = await db.queryByParam(order, param);

    if (dbMusics.isNotEmpty) {
      for (var dbm in dbMusics) {
        final musicItem = row2MusicItem(dbRow: dbm);

        if (dbMusics.isNotEmpty) {
          musics.add(musicItem);
        }
      }
    }
  }

  return musics;
}

Future<List<MusicItem>> findMusicFromLocalOrders({required String param}) async {
  final DBOrder db = DBOrder();
  List<MusicItem> musics = [];

  final dbMusics = await db.queryByParam(TableName.musicLocal, param);

  if (dbMusics.isNotEmpty) {
    for (var dbm in dbMusics) {
      final musicItem = row2MusicItem(dbRow: dbm);

      if (dbMusics.isNotEmpty) {
        musics.add(musicItem);
      }
    }
  }

  return musics;
}

Future<List<MusicItem>> getUpdatedMusicList({required String tabName}) async {
  final DBOrder db = DBOrder();
  List<MusicItem> newMusicList = [];
  final isWaitPlay = tabName == TableName.musicWaitPlay;

  try {
    final dbMusics = await db.queryAll(tabName, groupBy: isWaitPlay ? "playId" : "name", needOrder: isWaitPlay ? false : true);
    final len = dbMusics.length;

    if (dbMusics.isNotEmpty) {
      for (int index = 0; index < len; index++) {
        final isLast = dbMusics[index]["playId"] == dbMusics.last["playId"];
        final prev = index > 0 ? dbMusics[index - 1]["playId"] : dbMusics.last["playId"];
        final next = isLast ? dbMusics.first["playId"] : dbMusics[index + 1]["playId"];
        final mPrev = dbMusics[index]["prev"] as String;
        final mNext = dbMusics[index]["next"] as String;

        if (mPrev.isEmpty || mNext.isEmpty || prev != mPrev || next != mNext) {
          final newM = row2MusicItem(
            dbRow: dbMusics[index],
            prev: prev,
            next: next,
            isFirst: index == 0 ? "true" : "false",
            isLast: isLast ? "true" : "false",
          );

          newMusicList.add(newM);
          await db.update(tabName, musicItem2Row(music: newM));
        } else {
          final newM = row2MusicItem(
            dbRow: dbMusics[index],
          );

          newMusicList.add(newM);
        }
      }
    }

    return newMusicList;
  } catch (error) {
    return [];
  }
}


Future<int> getCurrentTabIndex() async {
  final localStorage = await SharedPreferences.getInstance();
  final int index = localStorage.getInt(CacheKey.currentTabIndex) ?? 0;
  return index;
}

setCurrentTabIndex({required int index}) async {
  final localStorage = await SharedPreferences.getInstance();
  await localStorage.setInt(CacheKey.currentTabIndex, index);
}
