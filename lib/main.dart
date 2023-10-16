import 'package:flutter/material.dart';
import 'package:kacang_mete/common/page/base_page.dart';
import 'package:kacang_mete/common/providers/db_provider.dart';
import 'package:provider/provider.dart';

Future main() async {
  await DBProvider().initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DBProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Inter',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const BasePage(),
      ),
    );
  }
}
