import "dart:async";

import "package:bobomusic/components/music_list_tile/music_list_tile.dart";
import "package:bobomusic/components/sheet/bottom_sheet.dart";
import "package:bobomusic/db/db.dart";
import "package:bobomusic/event_bus/event_bus.dart";
import "package:bobomusic/modules/download/model.dart";
import "package:bobomusic/modules/music_order/components/edit_music.dart";
import "package:bobomusic/modules/music_order/utils.dart";
import "package:bobomusic/modules/player/model.dart";
import "package:bobomusic/origin_sdk/origin_types.dart";
import "package:bobomusic/utils/check_music_local_repeat.dart";
import "package:bot_toast/bot_toast.dart";
import "package:flutter/material.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:provider/provider.dart";

final DBOrder db = DBOrder();

class MusicListCommon extends StatefulWidget {
  final String tabName;
  const MusicListCommon({super.key, required this.tabName});

  @override
  State<MusicListCommon> createState() => MusicListCommonState();
}

class MusicListCommonState extends State<MusicListCommon> {
  List<MusicItem> musicList = [];

  @override
  void initState() {
    super.initState();
    _loadData();

    eventBus.on<RefreshMusicList>().listen((event) {
      _loadData();
      RefreshMusicList(tabName: "");
    });

    eventBus.on<ClearMusicList>().listen((event) {
      _clearData();
    });
  }

  Future<void> _loadData({bool? forceLoading = false}) async {
    musicList.clear();
    final musics = await getUpdatedMusicList(tabName: widget.tabName);

    if (mounted && musics.isNotEmpty) {
      setState(() {
        musicList = musics;
      });
    } else if (mounted) {
      setState(() {
        musicList = [];
      });
    }
  }

  Future<void> _clearData() async {
    musicList.clear();
    EasyLoading.show(maskType: EasyLoadingMaskType.black);

    try {
      setState(() {
        musicList = [];
      });

      await db.deleteAll(widget.tabName);
    } catch (error) {
      print(error);
    }

    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: musicList.isEmpty ?
        SizedBox(
          height: MediaQuery.of(context).size.height - 300,
          child: const Center(child: Text("没有歌曲，去广场逛一逛吧 ~"))
        ) :
        ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: musicList.length,
          itemBuilder: (context, index) {
            if (musicList.isEmpty) return null;
            final item = musicList[index];
            return MusicListTile(
              item,
              onMore: () {
                showItemSheet(context, item);
              },
            );
          }
        ),
    );
  }

  void showItemSheet(BuildContext context, MusicItem musicItem) {
    final player = Provider.of<PlayerModel>(context, listen: false);
    openBottomSheet(context, [
      SheetItem(
        title: Text(
          musicItem.name,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      SheetItem(
        title: const Text("播放"),
        onPressed: () {
          player.play(music: musicItem);
        },
      ),
      SheetItem(
        title: const Text("添加到歌单"),
        onPressed: () {
          collectToMusicOrder(context: context, musicList: [musicItem], onConfirm: _loadData);
        },
      ),
      SheetItem(
        title: const Text("添加到待播放列表"),
        onPressed: () {
          player.addPlayerList([musicItem], showToast: true);
        },
      ),
      SheetItem(
        title: const Text("编辑"),
        onPressed: () {
          if (player.current?.playId != null && player.current!.playId.isNotEmpty && player.current!.playId == musicItem.playId) {
            BotToast.showText(text: "当前歌曲正在播放，不支持编辑");
            return;
          }

          Navigator.of(context).push(
            ModalBottomSheetRoute(
              isScrollControlled: true,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: EditMusic(
                    musicItem: musicItem,
                    onOk: (music) async {
                      await db.update(widget.tabName, musicItem2Row(music: music));
                      _loadData();
                    },
                  )
                );
              },
            )
          );
        },
      ),
      SheetItem(
        title: const Text("删除"),
        onPressed: () async {
          EasyLoading.show(maskType: EasyLoadingMaskType.black);
          await db.delete(widget.tabName, musicItem.id);
          EasyLoading.dismiss();

          _loadData();
        },
      ),
      if (musicItem.localPath.isEmpty)
      SheetItem(
        title: const Text("下载"),
        onPressed: () {
          checkMusicLocalRepeat(context, musicItem, () {
            final downloadModel = Provider.of<DownloadModel>(context, listen: false);
            downloadModel.download([musicItem]);
          });
        },
      ),
    ]);
  }
}
