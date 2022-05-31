import 'package:flutter/material.dart';
import 'tBoxesWidget.dart';
import 'recogWidget.dart';
import 'translateWidget.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.black),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Icon(Icons.translate),
          title: Text("Translate"),
          centerTitle: true),
      body: Container(
          margin: EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
          child: mainWidget()),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "btn1",
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => ImgWidget())));
        },
        label: Text("OCR"),
        icon: Icon(Icons.camera_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class mainWidget extends StatefulWidget {
  @override
  State<mainWidget> createState() => _mainWidgetState();
}

class _mainWidgetState extends State<mainWidget> {
  @override
  String fromLang = "auto", toLang = "en";
  String msg = "", translatedText = "";
  final translator = GoogleTranslator();

  void updateMsg(value) {
    setState(() {
      msg = value;
      print("Msg: $msg");
      (msg.isNotEmpty)
          ? translate()
          : {translatedText = "", print("Translated text: $translatedText")};
    });
  }

  void updateLang(u, v) {
    setState(() {
      fromLang = u;
      toLang = v;
      print("From: $fromLang -> To: $toLang");
      (msg.isNotEmpty)
          ? translate()
          : {translatedText = "", print("Translated text: $translatedText")};
    });
  }

  void translate() async {
    var translation = await translator
        .translate(msg, from: fromLang, to: toLang)
        .then((value) => {
              print("Translated text: $value"),
              setState(() {
                translatedText = value.toString();
              })
            });
  }

  Widget build(BuildContext context) {
    return Column(children: [
      Flexible(
        flex: 2,
        child: Material(
          color: Color.fromRGBO(35, 31, 32, 1),
          child: TWidget(1, updateLang),
          elevation: 10,
          borderRadius: BorderRadius.all(Radius.circular(13)),
        ),
      ),
      SizedBox(height: 12),
      Flexible(
        flex: 4,
        child: Material(
          color: Color.fromRGBO(35, 31, 32, 1),
          child: TBox(fromLang, updateMsg),
          elevation: 10,
          borderRadius: BorderRadius.all(Radius.circular(13)),
        ),
      ),
      SizedBox(height: 12),
      Flexible(
        flex: 3,
        child: Material(
          color: Color.fromRGBO(35, 31, 32, 1),
          child: T2_Box(translatedText, toLang),
          elevation: 10,
          borderRadius: BorderRadius.all(Radius.circular(13)),
        ),
      ),
      /*SizedBox(height: 17),
      Flexible(
        flex: 1,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => ImgWidget())));
          },
          label: Text("Tesseract OCR"),
          icon: Icon(Icons.camera_rounded),
        ),
      )*/
    ]);
  }
}


//voice
//edge cases