import "package:bobomusic/constants/cache_key.dart";
import "package:bobomusic/db/db.dart";
import "package:bobomusic/event_bus/event_bus.dart";
import "package:bobomusic/modules/setting/components/setting_card.dart";
import "package:bobomusic/modules/setting/pages/help_doc.dart";
import "package:bobomusic/modules/setting/pages/limit.dart";
import "package:bobomusic/modules/setting/pages/support_me.dart";
import "package:bobomusic/modules/setting/pages/thanks.dart";
import "package:bobomusic/modules/setting/pages/theme_color_setting.dart";
import "package:bobomusic/utils/get_cache_color.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

final db = DBOrder();

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => SettingViewState();
}

class SettingViewState extends State<SettingView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SafeArea(
        bottom: true,
        child: Container(
          color: const Color.fromARGB(255, 245, 245, 245),
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SettingCard(
                settingItems: [
                  SettingItem(title: "个性化"),
                  SettingItem(
                    leadingIcon: Icons.color_lens,
                    title: "更换主题色",
                    trailing: Icon(Icons.chevron_right, color: Theme.of(context).primaryColor),
                    onTap: () async {
                      Color initialColor = await getCacheColor();

                      if (context.mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return ThemeColorSetting(
                                initialColor: initialColor,
                                onColorChanged: (color, colorName, callback) async {
                                  eventBus.fire(ThemeColorChanged(color));
                                  final localStorage = await SharedPreferences.getInstance();
                                  // ignore: deprecated_member_use
                                  localStorage.setString(CacheKey.themeColor, colorName);
                                  callback();
                                }
                              );
                            },
                          ),
                        );
                      }
                    }
                  )
                ],
              ),
              const SizedBox(height: 20),
              SettingCard(
                settingItems: [
                  SettingItem(title: "帮助与支持"),
                  SettingItem(
                    leadingIcon: Icons.info,
                    title: "使用帮助",
                    trailing: Icon(Icons.chevron_right, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const HelpDoc();
                          },
                        ),
                      );
                    }
                  ),
                  SettingItem(
                    leadingIcon: Icons.warning_rounded,
                    title: "声明与限制",
                    trailing: Icon(Icons.chevron_right, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const Limit();
                          },
                        ),
                      );
                    }
                  )
                ],
              ),
              const SizedBox(height: 20),
              SettingCard(
                settingItems: [
                  SettingItem(title: "关于"),
                  SettingItem(
                    leadingIcon: Icons.coffee,
                    title: "支持开发",
                    trailing: Icon(Icons.chevron_right, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const SupportMe();
                          },
                        ),
                      );
                    }
                  ),
                  SettingItem(
                    leadingIcon: Icons.handshake,
                    title: "鸣谢",
                    trailing: Icon(Icons.chevron_right, color: Theme.of(context).primaryColor),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const Thanks();
                          },
                        ),
                      );
                    }
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 8,
                    backgroundImage: AssetImage("assets/ic_launch.png"),
                  ),
                  SizedBox(width: 6),
                  Text("啵啵音乐v1.3.0", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 6),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Powered By & Copyright @ Xiwenge", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
        )
      )
    );
  }
}
