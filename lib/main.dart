import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:penjualan_mobile/component/scroll_behavior.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:penjualan_mobile/constants/public_const.dart';
import 'package:penjualan_mobile/pages/authentication/authentication.dart';
import 'package:penjualan_mobile/pages/home.dart';
import 'package:flutter/services.dart';
import 'package:penjualan_mobile/pages/splash/splash_screen.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:penjualan_mobile/pages/barang/barang_page.dart';
// import 'package:penjualan_mobile/pages/pelanggan/pelanggan_page.dart';
// import 'package:penjualan_mobile/pages/penjualan/penjualan_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: GetMaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Gilroy',
          primarySwatch: myBlack,
        ),
        home: const SplashScreen(),
        getPages: [
          GetPage(name: '/home', page: () => const Homepage()),
        ],
      ),
    );
  }
}
