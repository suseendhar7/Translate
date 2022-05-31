import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ImgWidget extends StatefulWidget {
  @override
  State<ImgWidget> createState() => _ImgWidgetState();
}

class _ImgWidgetState extends State<ImgWidget> {
  @override
  String scannedText = "";
  String htext = "Select Image or Take photo to \nExtract text";
  bool scanning = false;
  XFile? imgFile;
  TextEditingController textEditingController = new TextEditingController();

  void getImage(ImageSource imgSource) async {
    try {
      final imagePicked = await ImagePicker().pickImage(source: imgSource);
      if (imagePicked != null) {
        scanning = true;
        imgFile = imagePicked;
        setState(() {
          htext = "Extracting text...";
        });
        scanText(imagePicked);
      }
    } catch (e) {
      print("Error: $e");
      scanning = false;
      imgFile = null;
      setState(() {
        htext = "Unable to load Image";
      });
    }
  }

  void scanText(XFile xfile) async {
    final img = InputImage.fromFilePath(xfile.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(img);
    await textDetector.close();

    scannedText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText += "${line.text}\n";
      }
    }

    scanning = false;
    setState(() {
      (scannedText.isNotEmpty)
          ? textEditingController.text = scannedText
          : htext = "No text detected";
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: Icon(Icons.document_scanner_rounded),
            title: Text("Text Recognition"),
            centerTitle: true),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 7),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Flexible(
                  flex: 2,
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                    color: Color.fromRGBO(35, 31, 32, 1),
                    child: Container(
                        child: (!scanning && imgFile == null)
                            ? BlankImgWidget()
                            : ((imgFile != null)
                                ? Image.file(File(imgFile!.path))
                                : BlankImgWidget())),
                  )),
              SizedBox(height: 15),
              Flexible(
                  flex: 1,
                  child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.all(Radius.circular(13)),
                      color: Color.fromRGBO(35, 31, 32, 1),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 17, vertical: 7),
                        child: Column(
                          children: [
                            Expanded(
                                child: TextField(
                                    controller: textEditingController,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            htext /*(!scanning)
                                            ? "Select Image or Take photo to \nExtract text"
                                            : "Extracting Text...",*/
                                        ,
                                        hintStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey)))),
                            InkWell(
                              customBorder: CircleBorder(),
                              child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.copy_rounded,
                                      color: Colors.white)),
                              onTap: () {
                                String s = textEditingController.text;
                                Clipboard.setData(ClipboardData(text: s));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Copied to Clipboard",
                                      style: TextStyle(color: Colors.black)),
                                  backgroundColor: Colors.white,
                                ));
                              },
                            )
                          ],
                        ),
                      )))
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              child: Icon(Icons.image_rounded),
            ),
            FloatingActionButton(
              heroTag: "btn3",
              onPressed: () {
                getImage(ImageSource.camera);
              },
              child: Icon(Icons.camera_enhance_rounded),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}

class BlankImgWidget extends StatelessWidget {
  const BlankImgWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
        color: Colors.grey,
        colorBlendMode: BlendMode.darken,
        image: AssetImage('assets/blank.jpg'));
  }
}
