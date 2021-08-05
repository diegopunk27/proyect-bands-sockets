import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:proyectos_banda/models/band.dart';
import 'package:proyectos_banda/providers/socket-service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    /*Band(id: '1', name: "Metallica", votes: 5),
    Band(id: '2', name: "Nirvana", votes: 7),
    Band(id: '3', name: "Pearl Jam", votes: 3),
    Band(id: '4', name: "Alice in Chain", votes: 4),
    Band(id: '5', name: "Pantera", votes: 5),*/
  ];

  @override
  void initState() {
    SocketService socketService =
        Provider.of<SocketService>(context, listen: false);
    /* Escucha el evento active-bands, castea el objeto entrante como lista y mapea cada elemento 
       en un objeto Band con el constructor fromMap
    */
    socketService.socket.on('active-bands', _handlerOn);
    super.initState();
  }

  _handlerOn(dynamic payload) {
    setState(() {
      bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    });
  }

  @override
  void dispose() {
    SocketService socketService = Provider.of<SocketService>(context);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SocketService socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Bands Name",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online)
                ? Icon((Icons.check_circle), color: Colors.green)
                : Icon((Icons.offline_bolt), color: Colors.red),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _showGraphic(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, index) => bandTile(bands[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addBand,
        child: Icon(Icons.add),
        elevation: 1,
      ),
    );
  }

  Widget bandTile(Band band) {
    SocketService socketService =
        Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) {
        /* Eliminar Banda */
        socketService.socket.emit('delete-band', {'id': band.id});
      },
      background: Container(
        padding: EdgeInsets.only(left: 8),
        color: Colors.red,
        child: Row(
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Container(
              width: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Delete band",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text(
          band.votes.toString(),
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {
          /* Votar por una banda */
          socketService.socket.emit('new-vote', {'id': band.id});
        },
      ),
    );
  }

  addBand() {
    final controller = new TextEditingController();

    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add new band"),
            content: TextField(
              controller: controller,
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () => addBandList(controller.text),
                elevation: 4,
                child: Text(
                  "Add",
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          );
        },
      );
    }
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Add new band"),
            content: CupertinoTextField(
              controller: controller,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("Add"),
                isDefaultAction: true,
                onPressed: () => addBandList(controller.text),
              ),
              CupertinoDialogAction(
                child: Text("Dismiss"),
                isDestructiveAction: true,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  addBandList(String text) {
    SocketService socketService =
        Provider.of<SocketService>(context, listen: false);
    if (text.length > 1) {
      /* Agregar Banda */
      socketService.socket.emit('new-band', {'name': text});
      /* LOCAL
      this.bands.add(Band(
            id: DateTime.now().toString(),
            name: text,
            votes: 0,
          ));
      setState(() {});*/
    }
    Navigator.of(context).pop();
  }

  Widget _showGraphic() {
    Map<String, double> dataMap = new Map();

    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });

    return Container(
      child: PieChart(dataMap: dataMap),
      width: double.infinity,
      height: 200,
    );
  }
}
