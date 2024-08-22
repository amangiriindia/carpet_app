import 'package:OACrugs/screens/address_screen.dart';
import 'package:OACrugs/screens/collection_screen.dart';
import 'package:OACrugs/screens/pageutill/add_address.dart';
import 'package:OACrugs/screens/pageutill/carpet_pattern_choose.dart';
import 'package:OACrugs/screens/pageutill/home_product_horigontal_list.dart';
import 'package:OACrugs/screens/pending_query.dart';
import 'package:OACrugs/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/enquiry_form.dart';
import 'screens/enquiry_screen.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/wishlist_screen.dart';
import 'widgets/color_picker.dart';
import 'wish_list_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WishListProvider()),
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
        // '/collection_screen': (context) => const CollectionScreen(collectionId: '', collectionName: '',),
        '/search_screen': (context) => const SearchScreen(),
        '/wishlist_screen': (context) => const WishListScreen(),
        '/enquiry_form': (context) => const EnquiryFormScreen(),

      },

    );
  }
}
