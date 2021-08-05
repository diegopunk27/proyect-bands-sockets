import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  //Atributos
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  //Getters
  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  SocketService() {
    this._initConfig();
    //notifyListeners();
  }

  void _initConfig() {
    // Dart client
    /*try {
      print("hola Diego");
      IO.Socket socket = IO.io('http://192.168.0.16:3000', {
        'transports': ['websocket'],
        'autoConnect': true
      });
      //IO.Socket socket = IO.io('http://localhost:3000/');
      // socket.connect();
      socket.onConnect((_) {
        print('connect');
        this._serverStatus = ServerStatus.Online;
        notifyListeners();
        //socket.emit('mensaje', {'contenido': 'Hola server desde dart'});
      });
      socket.onDisconnect((_) {
        print('disconnect');
        this._serverStatus = ServerStatus.Offline;
        notifyListeners();
      });
    } catch (e) {
      print(e.toString());
    }*/

    _socket = IO.io('http://192.168.0.16:3000/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      _socket.emit('mensaje', {'contenido': 'Hola server desde dart'});
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    /*_socket.on('nuevo-mensaje', (payload) {
      var nombre =
          payload.containsKey('nombre') ? payload['nombre'] : 'Anonimo';
      var mensaje =
          payload.containsKey('mensaje') ? payload['mensaje'] : 'Sin mensaje';
      print('Nuevo mensaje de $nombre : $mensaje');
    });*/
  }
}
