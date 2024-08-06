import 'package:carpet_app/screens/login_screen.dart';
import 'package:carpet_app/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/collection_screen.dart';
import 'screens/enquiry_form.dart';
import 'screens/enquiry_screen.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/wishlist_screen.dart';
import 'splash_screen/custom_splash_screen.dart';
import 'widgets/color_picker.dart';
import 'wish_list_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized

  // Check login status
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WishListProvider()),
        ChangeNotifierProvider(create: (_) => ColorPickerProvider()), // Add ColorPickerProvider
      ],
      child: MyApp(isLoggedIn: isLoggedIn), // Pass login status to MyApp
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carpet App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home:LoginScreen(), // Use SplashScreenHandler
      routes: {
        '/home': (context) => const HomeScreen(),
        '/collection_screen': (context) => const CollectionScreen(),
        '/search_screen': (context) => const SearchScreen(),
        '/wishlist_screen': (context) => const WishListScreen(),
        '/enquiry_form': (context) => const EnquiryFormScreen(),
        '/enquiry_screen': (context) => const EnquiryScreen(), // Add EnquiryScreen to routes
      },
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/collection_screen') {
          final int? initialIndex = settings.arguments as int?;
          return MaterialPageRoute(
            builder: (context) => CollectionScreen(initialIndex: initialIndex ?? 0),
          );
        }
        return null;
      },
    );
  }
}
//
// class SplashScreenHandler extends StatelessWidget {
//   final bool isLoggedIn;
//
//   SplashScreenHandler({required this.isLoggedIn});
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: Future.delayed(Duration(seconds: 0)), // Simulate splash screen delay
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return isLoggedIn ? const HomeScreen() : CustomSplashScreen();
//         }
//         return CustomSplashScreen(); // Show splash screen while loading
//       },
//     );
//   }
// }
