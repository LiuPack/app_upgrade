class AppMarket {
  /// 获取所有内置的应用商店
  static List<AppMarketInfo> get buildInMarketList {
    return [
      xiaoMi,
      meiZu,
      vivo,
      oppo,
      huaWei,
      zte,
      qiHoo,
      tencent,
      pp,
      wanDouJia
    ];
  }

  /// 小米
  static const xiaoMi = AppMarketInfo(
    marketName: 'xiaoMi',
    packageName: 'com.xiaomi.market',
    className: 'com.xiaomi.market.ui.AppDetailActivity',
  );

  /// 魅族
  static const meiZu = AppMarketInfo(
    marketName: 'meiZu',
    packageName: 'com.meizu.mstore',
    className: 'com.meizu.flyme.appcenter.activitys.AppMainActivity',
  );

  /// vivo
  static const vivo = AppMarketInfo(
    marketName: 'vivo',
    packageName: 'com.bbk.appstore',
    className: 'com.bbk.appstore.ui.AppStoreTabActivity',
  );

  /// oppo
  static const oppo = AppMarketInfo(
    marketName: 'oppo',
    packageName: 'com.oppo.market',
    className: 'a.a.a.aoz',
  );

  /// 华为
  static const huaWei = AppMarketInfo(
    marketName: 'huaWei',
    packageName: 'com.huawei.appmarket',
    className: 'com.huawei.appmarket.service.externalapi.view.ThirdApiActivity',
  );

  /// zte
  static const zte = AppMarketInfo(
    marketName: 'zte',
    packageName: 'zte.com.market',
    className: 'zte.com.market.view.zte.drain.ZtDrainTrafficActivity',
  );

  /// 360
  static const qiHoo = AppMarketInfo(
    marketName: 'qiHoo',
    packageName: 'com.qihoo.appstore',
    className: 'com.qihoo.appstore.distribute.SearchDistributionActivity',
  );

  /// 应用宝
  static const tencent = AppMarketInfo(
    marketName: 'tencent',
    packageName: 'com.tencent.android.qqdownloader',
    className: 'com.tencent.pangu.link.LinkProxyActivity',
  );

  /// pp助手
  static const pp = AppMarketInfo(
    marketName: 'pp',
    packageName: 'com.pp.assistant',
    className: 'com.pp.assistant.activity.MainActivity',
  );

  /// 豌豆荚
  static const wanDouJia = AppMarketInfo(
    marketName: 'wanDouJia',
    packageName: 'com.wandoujia.phoenix2',
    className: 'com.pp.assistant.activity.PPMainActivity',
  );

  /// 获取所有内置的应用商店的包名
  static List<String> get buildInPackageNameList {
    return buildInMarketList.map((f) {
      return f.packageName;
    }).toList();
  }

  /// 通过包名获取内置应用商店
  static List<AppMarketInfo> getBuildInMarketList(List<String> packageNames) {
    List<AppMarketInfo> marketList = [];
    for (final packageName in packageNames) {
      for (final f in buildInMarketList) {
        if (f.packageName == packageName) {
          marketList.add(f);
        }
      }
    }
    return marketList;
  }

  /// 通过包名获取商店
  static AppMarketInfo? getBuildInMarket(String packageName) {
    AppMarketInfo? info;
    for (final f in buildInMarketList) {
      if (f.packageName == packageName) {
        info = f;
      }
    }
    return info;
  }
}

class AppMarketInfo {
  final String marketName;
  final String packageName;
  final String className;

  const AppMarketInfo({
    required this.marketName,
    required this.packageName,
    required this.className,
  });
}
