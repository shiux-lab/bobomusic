import "package:bobomusic/components/music_list_tile/music_list_tile.dart";
import "package:bobomusic/modules/download/model.dart";
import "package:bobomusic/modules/music_order/utils.dart";
import "package:bobomusic/utils/check_music_local_repeat.dart";
import "package:flutter/material.dart";
import "package:bobomusic/components/sheet/bottom_sheet.dart";
import "package:bobomusic/modules/player/model.dart";
import "package:bobomusic/origin_sdk/origin_types.dart";
import "package:provider/provider.dart";

class PlayerList extends StatelessWidget {
  const PlayerList({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 2;
    double topHeight = 56;
    return Consumer<PlayerModel>(
      builder: (context, player, child) {
        return SizedBox(
          height: height,
          width: MediaQuery.of(context).size.width,
          child: Flex(
            direction: Axis.vertical,
            children: [
              _buildTopBar(context, player, topHeight),
              _buildList(context, player, height - topHeight)
            ],
          ),
        );
      },
    );
  }
}

_buildTopBar(context, player, topHeight) {
  return Container(
    height: topHeight,
    padding: const EdgeInsets.only(
      left: 15,
      right: 15,
      top: 5,
      bottom: 5,
    ),
    child: Row(
      children: [
        Expanded(
          child: Row(
            children: [
              const Text(
                "待播放列表",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "${player.playerList.length}首歌曲",
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).disabledColor,
                ),
              )
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            Provider.of<PlayerModel>(context, listen: false).clearPlayerList();
          },
          child: const Text("清空列表"),
        )
      ],
    ),
  );
}

_buildList(context, player, h) {
  if (player.playerList.isEmpty) {
    return Container(
      padding: const EdgeInsets.only(top: 100),
      child: const Text("没有歌曲"),
    );
  }

  return SizedBox(
    height: h,
    child: ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: player.playerList.length,
      itemBuilder: (context, index) {
        final item = player.playerList.toList()[index];
        return MusicListTile(
          item,
          showAddIcon: false,
          onMore: () {
            showItemSheet(context, item);
          },
        );
      },
    ),
  );
}

void showItemSheet(BuildContext context, MusicItem data) {
  final playerModel = Provider.of<PlayerModel>(context, listen: false);
  openBottomSheet(context, [
    SheetItem(
      title: Text(
        data.name,
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
        playerModel.play(music: data);
      },
    ),
    SheetItem(
      title: const Text("添加到歌单"),
      onPressed: () {
        collectToMusicOrder(context: context, musicList: [data]);
      },
    ),
    SheetItem(
      title: const Text("从待播放列表中移除"),
      onPressed: () {
        playerModel.removePlayerList([data]);
      },
    ),
    SheetItem(
      title: const Text("下载"),
      onPressed: () {
        checkMusicLocalRepeat(context, data, () {
          final downloadModel = Provider.of<DownloadModel>(context, listen: false);
          downloadModel.download([data]);
        });
      },
    ),
  ]);
}
