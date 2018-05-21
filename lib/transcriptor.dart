import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttr_protorecorder/languages.dart';
import 'package:fluttr_protorecorder/recognizer.dart';

final String title = "Sesli Komut";

// TODO: (1) TRANSCRIPTOR STATEFUL WIDGET ++++++++++++++++++++++++++++++++++++++
class TranscriptorWidget extends StatefulWidget {
  final Language lang;

  TranscriptorWidget({this.lang});

  @override
  _TranscriptorAppState createState() => new _TranscriptorAppState();
}


// TODO: (2) TRANSCRIPTOR STATE ++++++++++++++++++++++++++++++++++++++++++++++++
class _TranscriptorAppState extends State<TranscriptorWidget> {

  String transcription = '';
  bool authorized = false;
  bool isListening = false;
  bool get isNotEmpty => transcription != '';

  @override
  void initState() {
    super.initState();
    SpeechRecognizer.setMethodCallHandler(_platformCallHandler);
    _activateRecognition();
  }

  @override
  void dispose() {
    super.dispose();
    if (isListening) _cancelRecognitionHandler();
  }

  // TODO: (4) build WIDGET ++++++++++++++++++++++++++++++++++++++++++++++++++++
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('$title'),
          backgroundColor: const Color(0xFF7CB342),
        ),

      body: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                  _buildTranscriptionBox(
                      text: transcription,
                      onCancel: _cancelRecognitionHandler,
                      width: size.width - 20.0
                  ),
                _buildButtonBar(),
              ],
              //children: //blocks
      ),

    );
  }



  // TODO: (5) ACTIVATE RECORDING
  Future _activateRecognition() async {
    final res = await SpeechRecognizer.activate();
    setState(() => authorized = res);
  }


  // TODO: (6) START RECORDING
  Future _startRecognition() async {
    final res = await SpeechRecognizer.start(widget.lang.code);
    if (!res)
      showDialog(
          context: context,
          child: new SimpleDialog(title: new Text("Error"), children: [
            new Padding(
                padding: new EdgeInsets.all(12.0),
                child: const Text('Recognition not started'))
          ]));
  }

  // TODO: (7) CANCEL RECORDING
  Future _cancelRecognitionHandler() async {
    final res = await SpeechRecognizer.cancel();

    setState(() {
      transcription = '';
      isListening = res;
    });
  }


  // TODO: (8) PLATFORM CALL HANDLER
  Future _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "onSpeechAvailability":
        setState(() => isListening = call.arguments);
        break;
      case "onSpeech":
        setState(() => transcription = call.arguments);
        break;
      case "onRecognitionStarted":
        setState(() => isListening = true);
        break;
      case "onRecognitionComplete":
        setState(() {
            transcription = call.arguments;
        });
        break;
      default:
        print('Unknowm method ${call.method} ');
    }
  }


  // TODO: (9) build Button Bar
  Widget _buildButtonBar() {

    List<Widget> buttons = [
      !isListening
          ? _buildIconButton(authorized ? Icons.mic : Icons.mic_off,
              authorized ? _startRecognition : null,
              color: Colors.white, fab: true)
          : _buildIconButton(Icons.add, isListening ? null : null,
              color: Colors.white,
              backgroundColor: Colors.greenAccent,
              fab: true),
    ];
    Row buttonBar = new Row(mainAxisSize: MainAxisSize.min, children: buttons);
    return buttonBar;
  }

  // TODO: (10) build Transcription
  Widget _buildTranscriptionBox(
          {String text, VoidCallback onCancel, double width}) =>
      new Container(
          width: width,
          color: Colors.grey.shade200,
          child: new Row(children: [
            new Expanded(
                child: new Padding(
                    padding: new EdgeInsets.all(8.0), child: new Text(text))),
            new IconButton(
                icon: new Icon(Icons.close, color: Colors.grey.shade600),
                onPressed: text != '' ? () => onCancel() : null),
          ]));


  // TODO: (11) MIC ICON & ADD SAVE ICON BUTTON
  Widget _buildIconButton(IconData icon, VoidCallback onPress,
      {Color color: Colors.grey,
      Color backgroundColor: Colors.red,
      bool fab = false}) {
    return new Padding(
      padding: new EdgeInsets.all(12.0),
      child: fab
          ? new FloatingActionButton(
              child: new Icon(icon),
              onPressed: onPress,
              backgroundColor: backgroundColor)
          : new IconButton(
              icon: new Icon(icon, size: 32.0),
              color: color,
              onPressed: onPress),
    );
  }

}
