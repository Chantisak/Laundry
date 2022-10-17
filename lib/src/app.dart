import 'package:flutter/material.dart';
import 'package:laundry/src/services/local_storage_service.dart';
import 'package:laundry/src/views/home.dart';
import 'package:laundry/src/views/login.dart';

import 'configs/theme/theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme(context),
      home: _buildPage(),
    );
  }

  FutureBuilder<String> _buildPage() => FutureBuilder<String>(
      future: LocalStorageService().getToken(),
      builder: (context, snapshot) {
        final token = snapshot.data;

        if (token == null || token.isEmpty) {
          return const Login();
        }
        return const Home();
      });
}
