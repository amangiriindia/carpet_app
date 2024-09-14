import 'package:OACrugs/screens/home_screen.dart';
import 'package:OACrugs/screens/pageutill/search_home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen/custom_splash_screen.dart';
import 'screens/wishlist_screen.dart';
import 'components/color_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ColorPickerProvider()), // Add ColorPickerProvider
      ],
      child: MyApp(), // Pass login status to MyApp
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carpet App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home:  HomeScreen(),

      routes: {
         '/home': (context) => const HomeScreen(),
        '/search_screen': (context) => const SearchHomePage(),
        '/wishlist_screen': (context) => const WishListScreen(),
      },

    );
  }
}
