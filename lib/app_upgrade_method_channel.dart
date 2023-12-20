import 'package:app_update/src/app_market.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'app_upgrade.dart';
import 'app_upgrade_platform_interface.dart';

/// An implementation of [AppUpgradePlatform] that uses method channels.
class MethodChannelAppUpgrade extends AppUpgradePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('app_upgrade');

  @override
  Future<AppInfo> get appInfo async {
    final result = await methodChannel.invokeMethod('getAppInfo');
    return AppInfo(
      versionName: result['versionName'],
      versionCode: result['versionCode'],
      packageName: result['packageName'],
    );
  }

  @override
  Future<String> get apkDownloadPath async {
    return await methodChannel.invokeMethod('getApkDownloadPath');
  }

  @override
  Future<void> installAppForAndroid(String path) async {
    var map = {'path': path};
    return await methodChannel.invokeMethod('install', map);
  }

  @override
  Future<void> toAppStore(String id) async {
    var map = {'id': id};
    return await methodChannel.invokeMethod('toAppStore', map);
  }

  @override
  Future<List<String>> getInstallMarket(
      {List<String>? marketPackageNames}) async {
    List<String> packageNameList = AppMarket.buildInPackageNameList;
    if (marketPackageNames != null && marketPackageNames.isNotEmpty) {
      packageNameList.addAll(marketPackageNames);
    }
    var map = {'packages': packageNameList};
    var result = await methodChannel.invokeMethod('getInstallMarket', map);
    List<String> resultList = (result as List).map((f) {
      return '$f';
    }).toList();
    return resultList;
  }

  @override
  Future<void> toMarket({AppMarketInfo? appMarketInfo}) async {
    var map = {
      'marketPackageName':
          appMarketInfo != null ? appMarketInfo.packageName : '',
      'marketClassName': appMarketInfo != null ? appMarketInfo.className : '',
      'marketName': appMarketInfo != null ? appMarketInfo.marketName : ''
    };
    return await methodChannel.invokeMethod('toMarket', map);
  }
}
