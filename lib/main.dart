import 'package:flutter/material.dart';
import 'package:flutter_app_sale_06072022/common/constants/variable_constant.dart';
import 'package:flutter_app_sale_06072022/data/datasources/local/cache/app_cache.dart';
import 'package:flutter_app_sale_06072022/presentation/features/cart/cart_page.dart';
import 'package:flutter_app_sale_06072022/presentation/features/home/home_page.dart';
import 'package:flutter_app_sale_06072022/presentation/features/order/order_detail_page.dart';
import 'package:flutter_app_sale_06072022/presentation/features/order/order_page.dart';
import 'package:flutter_app_sale_06072022/presentation/features/product/product_page.dart';
import 'package:flutter_app_sale_06072022/presentation/features/sign_in/sign_in_page.dart';
import 'package:flutter_app_sale_06072022/presentation/features/sign_up/sign_up_page.dart';
import 'package:flutter_app_sale_06072022/presentation/features/splash/splash_page.dart';

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
        VariableConstant.CART_ROUTE: (context) => CartPage(),
        VariableConstant.PRODUCT_ROUTE: (context) => ProductPage(),
        VariableConstant.ORDER_HISTORY_ROUTE: (context) => OrderPage(),
        VariableConstant.ORDER_HISTORY_DETAIL_ROUTE: (context) => OrderDetailPage(),
        VariableConstant.SPLASH_ROUTE: (context) => SplashPage(),
      },
      initialRoute: VariableConstant.SPLASH_ROUTE,
    );
  }
}

