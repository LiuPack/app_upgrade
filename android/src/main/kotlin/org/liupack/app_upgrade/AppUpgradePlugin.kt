package org.liupack.app_upgrade

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.widget.Toast
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.io.File

class AppUpgradePlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "app_upgrade")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getAppInfo" -> {
                getAppInfo(context, result)
            }

            "getApkDownloadPath" -> {
                result.success(context.getExternalFilesDir("")?.absolutePath.plus("/temp.apk"))
            }

            "install" -> {
                //安装app
                val path = call.argument<String>("path")
                path?.also {
                    startInstall(context, it)
                }
            }

            "getInstallMarket" -> {
                val packageList = getInstallMarket(call.argument<List<String>>("packages"))
                result.success(packageList)
            }

            "toMarket" -> {
                val marketPackageName = call.argument<String>("marketPackageName")
                val marketClassName = call.argument<String>("marketClassName")
                val marketName = call.argument<String>("marketName")
                toMarket(context, marketPackageName, marketClassName, marketName)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    /**
     * 获取app信息
     */
    private fun getAppInfo(context: Context, result: MethodChannel.Result) {
        context.also {
            val packageInfo = it.packageManager.getPackageInfo(it.packageName, 0)
            val map = HashMap<String, String>()
            map["packageName"] = packageInfo.packageName
            map["versionName"] = packageInfo.versionName
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                map["versionCode"] = "${packageInfo.longVersionCode}"
            } else {
                @Suppress("DEPRECATION")
                map["versionCode"] = "${packageInfo.versionCode}"
            }
            result.success(map)
        }
    }


    /**
     * 安装app，android 7.0及以上和以下方式不同
     */
    private fun startInstall(context: Context, path: String) {
        val file = File(path)
        if (!file.exists()) {
            return
        }

        val intent = Intent(Intent.ACTION_VIEW)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            //7.0及以上
            println("安装地址:$path")
            val contentUri =
                FileProvider.getUriForFile(context, "${context.packageName}.fileProvider", file)
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            intent.setDataAndType(contentUri, "application/vnd.android.package-archive")
            context.startActivity(intent)
        } else {
            //7.0以下
            intent.setDataAndType(Uri.fromFile(file), "application/vnd.android.package-archive")
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
        }
    }


    /**
     * 获取已安装应用商店的包名列表
     */
    private fun getInstallMarket(packages: List<String>?): List<String> {
        val pkgs = ArrayList<String>()
        packages?.also {
            for (i in packages.indices) {
                if (isPackageExist(context, packages[i])) {
                    pkgs.add(packages[i])
                }
            }
        }
        return pkgs
    }


    /**
     * 是否存在当前应用市场
     *
     */
    private fun isPackageExist(context: Context, packageName: String?): Boolean {
        val manager = context.packageManager
        val intent = Intent().setPackage(packageName)
        val list = manager.queryIntentActivities(
            intent, 0
        )
        return list.size > 0
    }


    /**
     * 直接跳转到指定应用市场
     *
     * @param context
     * @param marketPackageName
     */
    private fun toMarket(
        context: Context,
        marketPackageName: String?,
        marketClassName: String?,
        marketName: String?
    ) {
        try {
            val packageInfo = context.packageManager.getPackageInfo(context.packageName, 0)
            val uri =
                Uri.parse("market://details?id=${packageInfo.packageName}")
            val nameEmpty = marketPackageName.isNullOrEmpty()
            val classEmpty = marketClassName.isNullOrEmpty()
            val goToMarket = Intent(Intent.ACTION_VIEW, uri)
            if (nameEmpty || classEmpty) {
                goToMarket.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            } else {
                goToMarket.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                if (marketPackageName != null && marketClassName != null) {
                    goToMarket.setClassName(marketPackageName, marketClassName)
                }
            }
            context.startActivity(goToMarket)
        } catch (e: ActivityNotFoundException) {
            e.printStackTrace()
            Toast.makeText(context, "您的手机没有安装应用商店($marketName)", Toast.LENGTH_SHORT)
                .show()
        }
    }
}
