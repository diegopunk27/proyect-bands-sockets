import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:proyectos_banda/providers/socket-service.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Server Status: ${socketService.serverStatus}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: () {
          socketService.socket.emit(
            'emitir-mensaje',
            {
              'nombre': 'Flutter',
              'mensaje': 'Hola desde Flutter',
            },
          );
        },
      ),
    );
  }
}
