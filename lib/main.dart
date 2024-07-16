import 'package:fanshop/arguments/user_argument.dart';
import 'package:fanshop/pages/add_product_page.dart';
import 'package:fanshop/pages/artists_preferences_page.dart';
import 'package:fanshop/pages/home_page.dart';
import 'package:fanshop/pages/intro_page.dart';
import 'package:fanshop/pages/login_page.dart';
import 'package:fanshop/pages/register_page.dart';
import 'package:fanshop/pages/search_page.dart';
import 'package:fanshop/pages/shop_page.dart';
import 'package:fanshop/pages/splashscreen_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fanshop',
      theme: ThemeData(
        fontFamily: 'Quicksand',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/loginpage': (context) => const LoginPage(),
        '/registerpage': (context) => const RegisterPage(),
        '/intropage': (context) => const IntroPage(),
        '/homepage': (context) {
          final UserArgument args =
              ModalRoute.of(context)!.settings.arguments as UserArgument;
          final String username = args.username;
          final String uid = args.uid;
          final String name = args.name;
          return HomePage(uid: uid, username: username, name: name);
        },
        '/artistpreferences': (context) {
          final UserArgument args =
              ModalRoute.of(context)!.settings.arguments as UserArgument;
          final String username = args.username;
          final String uid = args.uid;
          final String name = args.name;
          return ArtistPreferencesPage(
              uid: uid, username: username, name: name);
        },
        '/searchpage': (context) => const SearchPage(),
        '/shoppage': (context) {
          UserArgument args =
              ModalRoute.of(context)!.settings.arguments as UserArgument;
          final String username = args.username;
          final String uid = args.uid;
          final String name = args.name;
          return ShopPage(uid: uid, username: username, name: name);
        },
        '/addproductpage': (context) {
          UserArgument args =
              ModalRoute.of(context)!.settings.arguments as UserArgument;
          final String username = args.username;
          final String uid = args.uid;
          final String name = args.name;
          return AddProductPage(uid: uid, username: username, name: name);
        },
      },
    );
  }
}
