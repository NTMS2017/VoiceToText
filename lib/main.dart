import 'package:flutter/material.dart';
import 'package:fluttr_protorecorder/languages.dart';
import 'package:fluttr_protorecorder/transcriptor.dart';


// TODO: 1- MAIN
void main() {
  runApp(new MyApp());
}

// TODO 2- CREATE A STATEFUL CLASS
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MyAppState();
}

// TODO: 3- CLASS STATE
class MyAppState extends State<MyApp> {
  Language selectedLang = languages.first;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
              title: new Row(children: [
                new Icon(Icons.mic),
                new Text("MyApp",
                  style: new TextStyle(
                      color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ]),
              backgroundColor: Colors.green,
              actions: [

                // TODO: ACTIVATE VOICE-TO-TEXT PAGE
                new IconButton(
                  icon: new Icon(Icons.mic),
                  tooltip: 'Voice Command',
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new TranscriptorWidget(lang: selectedLang)));
                  },
                ),


                // TODO: GET LANGUAGE
                new PopupMenuButton<Language>(
                  onSelected: _selectLangHandler,
                  itemBuilder: (BuildContext context) => _buildLanguagesWidgets,
                ),


              ]),
          body: new Center(
            child: new Text("Main Body"),
          ),
        ));
  }

  List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets => languages
      .map((l) => new CheckedPopupMenuItem<Language>(
    value: l,
    checked: selectedLang == l,
    child: new Text(l.name),
  ))
      .toList();

  void _selectLangHandler(Language lang) {
    setState(() => selectedLang = lang);
  }
}