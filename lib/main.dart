import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:posumkm/preferences/UserPreferences.dart';
import 'package:posumkm/providers/UserProvider.dart';
import 'package:posumkm/views/SplashScreenPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/UserModel.dart';

UserModel? userLoggedInApps;
var databaseFactory;
DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
Map<String, dynamic> deviceData = <String, dynamic>{};

void main() async {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // if(Platform.isWindows || Platform.isLinux){
  //   sqfliteFfiInit();
  // }

  // databaseFactory = databaseFactoryFfi;
  WidgetsFlutterBinding.ensureInitialized();
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  deviceData = await getDeviceInfo();
  runApp(const MyApp());
  await _loadUserLoggedIn();
}

Future<Map<String, dynamic>> getDeviceInfo() async {
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'deviceId': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'displaySizeInches':
          ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
      'displayWidthPixels': build.displayMetrics.widthPx,
      'displayWidthInches': build.displayMetrics.widthInches,
      'displayHeightPixels': build.displayMetrics.heightPx,
      'displayHeightInches': build.displayMetrics.heightInches,
      'displayXDpi': build.displayMetrics.xDpi,
      'displayYDpi': build.displayMetrics.yDpi,
      'serialNumber': build.serialNumber,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'deviceId': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': describeEnum(data.browserName),
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'kernelVersion': data.kernelVersion,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'patchVersion': data.patchVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
      'systemGUID': data.systemGUID,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
      'userName': data.userName,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'buildNumber': data.buildNumber,
      'platformId': data.platformId,
      'csdVersion': data.csdVersion,
      'servicePackMajor': data.servicePackMajor,
      'servicePackMinor': data.servicePackMinor,
      'suitMask': data.suitMask,
      'productType': data.productType,
      'reserved': data.reserved,
      'buildLab': data.buildLab,
      'buildLabEx': data.buildLabEx,
      'digitalProductId': data.digitalProductId,
      'displayVersion': data.displayVersion,
      'editionId': data.editionId,
      'installDate': data.installDate,
      'productId': data.productId,
      'productName': data.productName,
      'registeredOwner': data.registeredOwner,
      'releaseId': data.releaseId,
      'deviceId': data.deviceId,
    };
  }

  try {
    if (kIsWeb) {
      _deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
    } else {
      _deviceData = switch (defaultTargetPlatform) {
        TargetPlatform.android =>
          _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
        TargetPlatform.iOS =>
          _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
        TargetPlatform.linux =>
          _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo),
        TargetPlatform.windows =>
          _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo),
        TargetPlatform.macOS =>
          _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo),
        TargetPlatform.fuchsia => <String, dynamic>{
            'Error:': 'Fuchsia platform isn\'t supported'
          },
      };
    }
  } on PlatformException {
    _deviceData = <String, dynamic>{
      'Error:': 'Failed to get platform version.'
    };
  }
  return _deviceData;
}

Future<void> _loadUserLoggedIn() async {
  final preference = await SharedPreferences.getInstance();
  if (preference.containsKey("userLoggedIn")) {
    userLoggedInApps = UserModel.fromJson(
        json.decode(preference.getString("userLoggedIn").toString()));
  }
  // UserPreferences.getUserLoggedIn().then((value) => userLoggedInApps = value);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'NiCash',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Varela-Round',
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(75, 101, 131, 1)),
          // ColorScheme.fromSeed(seedColor: Color.fromRGBO(24, 31, 50, 1)),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class AppsColor {
  static const Color alternativeBlack = Color.fromRGBO(49, 54, 56, 1);
  static const Color alternativeWhite = Color.fromRGBO(253, 253, 253, 1);
}

class BaseTextStyle {
  final Color color = Colors.grey;

  static const lblDashboard = TextStyle(
      fontSize: 14,
      color: Color.fromARGB(255, 182, 217, 235),
      // fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const valDashboard = TextStyle(
      fontSize: 25,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: "Varela-Round");

  static const appBarTitle = TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: "Varela-Round");

  static const gridTextDivider = TextStyle(
      fontSize: 10,
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontFamily: "Poppins");

  static const gridItemText = TextStyle(
      fontSize: 12,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const gridTextButton = TextStyle(
      fontSize: 12,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const buttonTransaksiHome = TextStyle(
      fontSize: 12,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const labelTransaksiHome = TextStyle(
      fontSize: 10,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontFamily: "Poppins");

  static const ltJpTunai = TextStyle(
      fontSize: 10,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontFamily: "Poppins");

  static const ltTanggal = TextStyle(
      fontSize: 12,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const ltRpLunas = TextStyle(
      fontSize: 12,
      // color: Color.fromARGB(255, 0, 189, 69),
      color: Color.fromARGB(255, 67, 255, 58),
      fontWeight: FontWeight.w900,
      fontFamily: "Poppins");

  static const ltRpBelumLunas = TextStyle(
      fontSize: 12,
      // color: Color.fromARGB(255, 0, 189, 69),
      color: Color.fromARGB(255, 227, 252, 0),
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");

  static const ltListMenu = TextStyle(
      fontSize: 11,
      // color: Color.fromARGB(255, 0, 189, 69),
      color: Colors.white,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      fontFamily: "Poppins");

  static const ltItemCounts = TextStyle(
      fontSize: 11,
      // color: Color.fromARGB(255, 0, 189, 69),
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: "Poppins");
}

class LineDividerWidget extends StatelessWidget {
  final Color color;
  final double height;
  // final double padding;

  const LineDividerWidget({
    super.key,
    this.color = Colors.black,
    this.height = 1,
    // this.padding = EdgeInsets.all(10)
  });
  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);

    return SizedBox(
      height: height,
      child: Container(
        width: double.infinity,
        color: color,
      ),
    );
  }
}
