import 'package:flutter/material.dart';
import 'package:kacang_mete/common/page/base_page.dart';
import 'package:kacang_mete/modules/transaction/providers/temp_filter_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TempFilterProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(accessibleNavigation: false),
          child: child!,
        ),
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
