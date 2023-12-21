import 'package:app_upgrade_liupack/app_upgrade.dart';
import 'package:app_upgrade_liupack/app_upgrade_method_channel.dart';
import 'package:app_upgrade_liupack/app_upgrade_platform_interface.dart';
import 'package:app_upgrade_liupack/src/app_market.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppUpgradePlatform
    with MockPlatformInterfaceMixin
    implements AppUpgradePlatform {
  @override
  Future<String> get apkDownloadPath => throw UnimplementedError();

  @override
  Future<AppInfo> get appInfo => throw UnimplementedError();

  @override
  Future<List<String>> getInstallMarket({List<String>? marketPackageNames}) {
    throw UnimplementedError();
  }

  @override
  Future<void> installAppForAndroid(String path) {
    throw UnimplementedError();
  }

  @override
  Future<void> toAppStore(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> toMarket({AppMarketInfo? appMarketInfo}) {
    throw UnimplementedError();
  }
}

void main() {
  final AppUpgradePlatform initialPlatform = AppUpgradePlatform.instance;

  test('$MethodChannelAppUpgrade is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppUpgrade>());
  });
}
