import 'package:flutter/material.dart';

class TWidget extends StatefulWidget {
  @override
  int y;
  final onLangChange;

  TWidget(this.y, this.onLangChange);

  State<TWidget> createState() => _TWidgetState();
}

class _TWidgetState extends State<TWidget> {
  @override
  String? _fromLanguage = "auto";
  String? _toLanguage = "en";

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DropdownButton(
              dropdownColor: Color.fromRGBO(35, 31, 32, 1),
              style: TextStyle(color: Colors.white),
              hint: Text("Select a Language",
                  style: TextStyle(color: Colors.grey)),
              value: _fromLanguage,
              items: [
                DropdownMenuItem(child: Text("Auto"), value: "auto"),
                DropdownMenuItem(child: Text("English"), value: "en"),
                DropdownMenuItem(child: Text("Chinese"), value: "zh-cn"),
                DropdownMenuItem(child: Text("Spanish"), value: "es"),
                DropdownMenuItem(child: Text("Hindi"), value: "hi"),
                DropdownMenuItem(child: Text("Arabic"), value: "ar"),
                DropdownMenuItem(child: Text("Portuguese"), value: "pt"),
                DropdownMenuItem(child: Text("Russian"), value: "ru"),
                DropdownMenuItem(child: Text("Japanese"), value: "ja"),
                DropdownMenuItem(child: Text("French"), value: "fr"),
                DropdownMenuItem(child: Text("German"), value: "de"),
              ],
              onChanged: (String? value) {
                setState(() {
                  _fromLanguage = value;
                  widget.onLangChange(_fromLanguage, _toLanguage);
                });
              }),
          IconButton(
              onPressed: () {
                setState(() {
                  if (_fromLanguage != "auto") {
                    setState(() {
                      var temp = _fromLanguage;
                      _fromLanguage = _toLanguage;
                      _toLanguage = temp;
                      widget.onLangChange(_fromLanguage, _toLanguage);
                    });
                  }
                });
              },
              icon: Icon(Icons.swap_horiz_rounded, color: Colors.white)),
          DropdownButton(
              dropdownColor: Color.fromRGBO(35, 31, 32, 1),
              style: TextStyle(color: Colors.white),
              hint:
                  Text("Select Language", style: TextStyle(color: Colors.grey)),
              value: _toLanguage,
              items: [
                DropdownMenuItem(child: Text("English"), value: "en"),
                DropdownMenuItem(child: Text("Chinese"), value: "zh-cn"),
                DropdownMenuItem(child: Text("Spanish"), value: "es"),
                DropdownMenuItem(child: Text("Hindi"), value: "hi"),
                DropdownMenuItem(child: Text("Arabic"), value: "ar"),
                DropdownMenuItem(child: Text("Portuguese"), value: "pt"),
                DropdownMenuItem(child: Text("Russian"), value: "ru"),
                DropdownMenuItem(child: Text("Japanese"), value: "ja"),
                DropdownMenuItem(child: Text("French"), value: "fr"),
                DropdownMenuItem(child: Text("German"), value: "de"),
              ],
              onChanged: (String? value) {
                setState(() {
                  _toLanguage = value;
                  widget.onLangChange(_fromLanguage, _toLanguage);
                });
              })
        ],
      ),
    );
  }
}
