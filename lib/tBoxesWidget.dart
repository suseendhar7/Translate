import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/services.dart';
import 'package:translation_app/recogWidget.dart';

Map<String, String> lang_codes = {
  "auto": "Auto",
  "en": "English",
  "zh-cn": "Chinese",
  "es": "Spanish",
  "hi": "Hindi",
  "ar": "Arabic",
  "pt": "Portuguese",
  "ru": "Russian",
  "ja": "Japanese",
  "fr": "French",
  "de": "German"
};

class TBox extends StatefulWidget {
  @override
  String fromLang = "en-US";
  final onMsgChange;

  TBox(this.fromLang, this.onMsgChange);
  State<TBox> createState() => _TBoxState();
}

class _TBoxState extends State<TBox> {
  @override
  final FlutterTts flutterTts = FlutterTts();
  stt.SpeechToText speech = stt.SpeechToText();
  String text = "";
  bool listening = false;

  void speak(value) async {
    await flutterTts.setLanguage(widget.fromLang);
    await flutterTts.speak(value);
  }

  void listen() async {
    if (!listening) {
      bool available = await speech.initialize(
          onStatus: (val) => print("Status: $val"),
          onError: (val) => print("Error: $val"));
      if (available) {
        print("Listening...");
        setState(() => listening = true);
        speech.listen(
            onResult: (val) =>
                {text = val.recognizedWords, print("Recognised Text: $text")});
      }
    } else {
      setState(() => {listening = false, speech.stop()});
    }
  }

  Widget build(BuildContext context) {
    //TextEditingController textEditingController = new TextEditingController();

    return Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child: TextField(
                onChanged: (value) => {text = value, widget.onMsgChange(value)},
                maxLines: null,
                style: TextStyle(color: Colors.white, fontSize: 22),
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 22),
                    hintText: "Enter text to translate",
                    labelText:
                        lang_codes[widget.fromLang]! + "-" + widget.fromLang,
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 22),
                    border: InputBorder.none)),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            InkWell(
              customBorder: CircleBorder(),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ImgWidget()));
              },
              child: Container(
                padding: EdgeInsets.all(3),
                child: Icon(
                  Icons.camera_enhance_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            InkWell(
                customBorder: CircleBorder(),
                child: Container(
                  padding: EdgeInsets.all(3),
                  child: Icon(
                    Icons.mic_off_rounded,
                    color: Colors.white,
                  ),
                ),
                onTap: () {} //listen,
                ),
            InkWell(
              customBorder: CircleBorder(),
              child: Container(
                padding: EdgeInsets.all(3),
                child: Icon(
                  Icons.volume_up_rounded,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                //String s = textEditingController.text;
                (text.isNotEmpty) ? speak(text) : null;
              },
            ),
          ])
        ]));
  }
}

class T2_Box extends StatefulWidget {
  @override
  String msg = "";
  String toLang = "en_US";
  T2_Box(this.msg, this.toLang);
  State<T2_Box> createState() => _T2_BoxState();
}

class _T2_BoxState extends State<T2_Box> {
  FlutterTts flutterTts = new FlutterTts();

  void speak() async {
    await flutterTts.setLanguage(widget.toLang);
    await flutterTts.speak(widget.msg);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController toController = new TextEditingController();

    setState(() {
      toController.text = widget.msg;
    });

    return Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child: TextField(
                controller: toController,
                maxLines: null,
                style: TextStyle(color: Colors.white, fontSize: 22),
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 22),
                    hintText: "Translated text",
                    labelText: lang_codes[widget.toLang]! + "-" + widget.toLang,
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 22),
                    border: InputBorder.none)),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            InkWell(
              customBorder: CircleBorder(),
              child: Container(
                padding: EdgeInsets.all(3),
                child: Icon(
                  Icons.copy_rounded,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Clipboard.setData(ClipboardData(text: toController.text));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Copied to Clipboard",
                        style: TextStyle(color: Colors.black)),
                    backgroundColor: Colors.white));
              },
            ),
            InkWell(
              customBorder: CircleBorder(),
              child: Container(
                padding: EdgeInsets.all(3),
                child: Icon(
                  Icons.volume_up_rounded,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                (widget.msg.isNotEmpty) ? speak() : null;
              },
            ),
          ])
        ]));
  }
}
