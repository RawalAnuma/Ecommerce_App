import 'package:flutter/material.dart';
import 'package:my_app/provider/category_provider.dart';
import 'package:my_app/provider/new_product_provider.dart';
import 'package:my_app/provider/user_provider.dart';
import 'package:provider/provider.dart';

import 'app/aura_app.dart';
import 'provider/product_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()), 
        ChangeNotifierProvider(create: (_) => NewProductProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
      child: const AuraApp(),
    ),
  );
}
