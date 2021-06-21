import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    // Dart client
    this._socket = IO.io('ws://10.0.2.2:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

// Dart client
    this._socket.on('connect', (_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.on('event', (data) => print(data));
    this._socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    //socket.on('nuevo-mensaje', (payload) {
    //  print("nuevo-mensaje: $payload");
    //  print('nombre: ' + payload['nombre']);
    //  print('mensaje: ' + payload['mensaje']);
    //  print(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'no hay');
    //});

    this._socket.on('fromServer', (_) => print(_));

// add this line
    this._socket.connect();
  }
}
