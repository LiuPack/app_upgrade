import 'package:app_update/app_upgrade.dart';
import 'package:app_update/src/app_market.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'app_upgrade_method_channel.dart';

abstract class AppUpgradePlatform extends PlatformInterface {
  /// Constructs a AppUpgradePlatform.
  AppUpgradePlatform() : super(token: _token);

  static final Object _token = Object();

  static AppUpgradePlatform _instance = MethodChannelAppUpgrade();

  /// The default instance of [AppUpgradePlatform] to use.
  ///
  /// Defaults to [MethodChannelAppUpgrade].
  static AppUpgradePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppUpgradePlatform] when
  /// they register themselves.
  static set instance(AppUpgradePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 获取 App 信息
  Future<AppInfo> get appInfo async {
    throw UnimplementedError('appInfo has not been implemented.');
  }

  /// 获取 apk 下载路径
  Future<String> get apkDownloadPath async {
    throw UnimplementedError("apkDownloadPath has not been implemented");
  }

  /// Android 安装 app
  Future<void> installAppForAndroid(String path) async {
    throw UnimplementedError(
        "installAppForAndroid(String path) has not been implemented");
  }

  /// 跳转 App Store
  Future<void> toAppStore(String id) async {
    throw UnimplementedError("toAppStore(String id) has not been implemented");
  }

  /// 获取android手机上安装的应用商店
  Future<List<String>> getInstallMarket(
      {List<String>? marketPackageNames}) async {
    throw UnimplementedError(
        "getInstallMarket({List<String>? marketPackageNames}) has not been implemented");
  }

  /// 跳转到应用商店
  Future<void> toMarket({AppMarketInfo? appMarketInfo}) async {
    throw UnimplementedError(
        "toMarket({AppMarketInfo? appMarketInfo}) has not been implemented");
  }
}
