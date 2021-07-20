import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:proyectos_banda/models/band.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: "Metallica", votes: 5),
    Band(id: '2', name: "Nirvana", votes: 7),
    Band(id: '3', name: "Pearl Jam", votes: 3),
    Band(id: '4', name: "Alice in Chain", votes: 4),
    Band(id: '5', name: "Pantera", votes: 5),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Bands Name",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) => bandTile(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addBand,
        child: Icon(Icons.add),
        elevation: 1,
      ),
    );
  }

  Widget bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection dis) {
        //TODO: implementar llamada api
        print(dis);
        print(band.id);
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
        onTap: () => print(band.name),
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
    if (text.length > 1) {
      this.bands.add(Band(
            id: DateTime.now().toString(),
            name: text,
            votes: 0,
          ));
      setState(() {});
    }
    Navigator.of(context).pop();
  }
}
