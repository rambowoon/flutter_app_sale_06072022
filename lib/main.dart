import 'package:flutter/material.dart';
import 'package:flutter_app_sale_06072022/common/constants/variable_constant.dart';
import 'package:flutter_app_sale_06072022/data/datasources/local/cache/app_cache.dart';
import 'package:flutter_app_sale_06072022/presentation/features/home/home_page.dart';
import 'package:flutter_app_sale_06072022/presentation/features/sign_in/sign_in_page.dart';
import 'package:flutter_app_sale_06072022/presentation/features/sign_up/sign_up_page.dart';
import 'package:flutter_app_sale_06072022/presentation/features/splash/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
  AppCache.init();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "QuickSan",
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        VariableConstant.SIGN_IN_ROUTE: (context) => SignInPage(),
        VariableConstant.SIGN_UP_ROUTE: (context) => SignUpPage(),
        VariableConstant.HOME_ROUTE: (context) => HomePage(),
        VariableConstant.SPLASH_ROUTE: (context) => SplashPage(),
      },
      initialRoute: VariableConstant.SPLASH_ROUTE,
    );
  }
}

