import 'package:crud_application/provider/listing_screen_provider.dart';
import 'package:crud_application/screen/listing_screen/listing_screen.dart';
import 'package:crud_application/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ListingProvider(),
      child:  MaterialApp(
        theme: AppTheme.appTheme(),
        debugShowCheckedModeBanner:  false,
        title: "CRUD App",
        home: const ListingScreen(),
      ),
    );
  }
}

