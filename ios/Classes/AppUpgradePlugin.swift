import Flutter
import UIKit

public class AppUpgradePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "app_upgrade", binaryMessenger: registrar.messenger())
    let instance = AppUpgradePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getAppInfo":
        let infoDictionary = Bundle.main.infoDictionary!
        let majorVersion = infoDictionary["CFBundleShortVersionString"]//主程序版本号
        let bundleIdentifier = infoDictionary["CFBundleIdentifier"]
        var map = [String: String]()
        map["packageName"] = bundleIdentifier as? String
        map["versionName"] = majorVersion as? String
        map["versionCode"] = "0"
        result(map)
    case "toAppStore":
        let args = call.arguments as! Dictionary<String, String>
        let urlString = "itms-apps://itunes.apple.com/app/" + (args["id"] ?? "")
        if let url = URL(string: urlString) {
            //根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],completionHandler: {(success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
