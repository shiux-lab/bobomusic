// ignore_for_file: must_be_immutable

import "package:bobomusic/components/custom_dialog/custom_dialog.dart";
import "package:bobomusic/db/db.dart";
import "package:bobomusic/modules/music_order/utils.dart";
import "package:bot_toast/bot_toast.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";

// 编辑/创建歌单
class EditMusicOrder extends StatefulWidget {
  final String name;
  final Function update;

  const EditMusicOrder({
    super.key,
    required this.name,
    required this.update,
  });

  @override
  State<EditMusicOrder> createState() => EditMusicOrderState();
}

class EditMusicOrderState extends State<EditMusicOrder> {
  final TextEditingController _nameController = TextEditingController();
  final DBOrder db = DBOrder();
  bool get _isCreate => widget.name == "";

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
  }

  Future<void> dropOrderTable() async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await db.dropTable(widget.name);

    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4 + 40,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _isCreate ? "创建歌单" : "修改歌单",
                    maxLines: 1,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              !_isCreate ? Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialog(
                          title: "提示",
                          body: const Text("确定删除此歌单?"),
                          onConfirm: () async {
                            await dropOrderTable();
                            delCustomOrderItem(name: _nameController.text);
                            widget.update();

                            final orderList = await getAllOrderList();
                            setCurrentTabIndex(index: orderList.length - 1);

                            if (context.mounted) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                          },
                          onCancel: () {
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.grey,
                  ),
                )
              ) : const Text(""),
            ],
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _nameController,
            maxLength: 10,
            autofocus: true,
            cursorColor: Colors.grey,
            decoration: const InputDecoration(
              // 正常状态下的边框样式和颜色
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
              ),
              // 获得焦点时的边框样式和颜色
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
              ),
              label: Text("歌单名称 (必填，仅支持中文英文数字，限 10 字符)", style: TextStyle(color: Colors.grey)),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[\w\u4e00-\u9fa5]")),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                try {
                  if (await checkOrderName(newName: _nameController.text, oldName: widget.name)) {
                    bool success = false;
                    if (_isCreate) {
                      success = await setCustomOrderItem(newName: _nameController.text);
                      await db.createOrderTable(_nameController.text);
                    } else {
                      success = await setCustomOrderItem(newName: _nameController.text.trim(), oldName: widget.name);
                      await db.updateTableName(oldTableName: widget.name, newTableName: _nameController.text);
                    }

                    if (success) {
                      widget.update();

                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  }
                } catch (e) {
                  if (_isCreate) {
                    delCustomOrderItem(name: _nameController.text);
                  }

                  BotToast.showText(
                    text: "${_isCreate ? "创建" : "更新"}失败，这个名称可能不太合适，换一个吧 QAQ",
                  );
                }

                if (_isCreate) {
                  final orderList = await getAllOrderList();
                  setCurrentTabIndex(index: orderList.length - 1);
                }
              },
              child: const Text("确认"),
            ),
          ),
        ],
      ),
    );
  }
}
