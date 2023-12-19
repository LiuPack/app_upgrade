import 'dart:io';

import 'package:app_upgrade/app_upgrade.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const apkUrl =
      'https://d4608e3e07fd93f5f4d35ba6b67a5876.dlied1.cdntips.net/downv6.qq.com/qqweb/QQ_1/android_apk/Android_8.9.28.10155_537147618_64.apk?mkey=65811a1c716336ed&f=dc62&cip=113.99.16.24&proto=https&access_type=&tx_domain=down.qq.com&tx_path=%2Fqqweb%2F&tx_id=6c9382a8c8';
  AppInfo? _appInfo;
  String _installMarkets = '';

  @override
  void initState() {
    _getAppInfo();
    super.initState();
    _getInstallMarket();
  }

  Future<AppUpgradeInfo> _checkVersion() async {
    return Future.delayed(const Duration(seconds: 1), () {
      return AppUpgradeInfo(
        title: '新版本V1.1.1',
        apkDownloadUrl: apkUrl,
        contents: [
          '1、支持立体声蓝牙耳机，同时改善配对性能',
          '2、提供屏幕虚拟键盘',
          '3、更简洁更流畅，使用起来更快',
          '4、修复一些软件在使用时自动退出bug',
          '5、新增加了分类查看功能'
        ],
        force: false,
      );
    });
  }

  _getAppInfo() async {
    var appInfo = await AppUpgrade.appInfo;
    setState(() {
      _appInfo = appInfo;
    });
  }

  _getInstallMarket() async {
    if (Platform.isAndroid) {
      List<String> marketList = await AppUpgrade.getInstallMarket();
      for (var f in marketList) {
        _installMarkets += '$f,';
      }
    }
  }

  _checkAppUpgrade() {
    AppUpgrade.appUpgrade(
      context,
      _checkVersion(),
      cancelText: '以后再说',
      okText: '马上升级',
      iosAppId: 'id444934666',
      // appMarketInfo: AppMarket.tencent,
      okBackgroundColors: [const Color(0xFF765CFE), const Color(0xFF765CFE)],
      progressBarColor: const Color(0xFF5A46BE).withOpacity(.4),
      isDark: true,
      onCancel: () {
        debugPrint('onCancel');
      },
      onOk: () {
        debugPrint('onOk');
      },
      downloadProgress: (count, total) {
        // debugPrint('count:$count,total:$total');
      },
      downloadStatusChange: (status, {dynamic error}) {
        debugPrint('status:$status,error:$error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('packageName:${_appInfo?.packageName}'),
        Text('versionName:${_appInfo?.versionName}'),
        Text('versionCode:${_appInfo?.versionCode}'),
        if (Platform.isAndroid) Text('安装的应用商店:$_installMarkets'),
        ElevatedButton(
          onPressed: _checkAppUpgrade,
          child: const Text('显示更新弹窗'),
        ),
        if (Platform.isAndroid)
          MaterialButton(
            onPressed: () {
              AppUpgrade.apkDownloadPath.then((value) {
                debugPrint("apk is $value");
                return AppUpgrade.installAppForAndroid(value);
              });
            },
            child: const Text('直接安装'),
          )
      ],
    );
  }
}
