import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:proyectos_banda/pages/home.dart';
import 'package:proyectos_banda/pages/status.dart';
import 'package:proyectos_banda/providers/socket-service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SocketService>(
          create: (_) => SocketService(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: "/home",
        routes: {
          "/home": (_) => HomePage(),
          "/status": (_) => StatusPage(),
        },
      ),
    );
  }
}
