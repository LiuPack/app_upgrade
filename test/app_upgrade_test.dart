import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:update_app/app_upgrade.dart';
import 'package:update_app/app_upgrade_method_channel.dart';
import 'package:update_app/app_upgrade_platform_interface.dart';
import 'package:update_app/src/app_market.dart';

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
