import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ramen_app/detail_page.dart';
import 'package:ramen_app/ramen_data.dart';
import 'package:ramen_app/ramen_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const RamenPage(),
        ),
        GoRoute(
          path: '/detail',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final ramen = extra['ramen'] as RamenData;
            final width = extra['width'] as double;

            return MaterialPage(
              child: DetailPage(ramen: ramen, width: width),
            );
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Ramen App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
