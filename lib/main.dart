import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Detect INGREDIENTS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String text = "";
  final StreamController<String> controller = StreamController<String>();
  String extractIngredients(String paragraph) {
    const startText = "INGREDIENTS:";
    const endChar = ".";

    final startIndex = paragraph.indexOf(startText);
    if (startIndex == -1) {
      return "Ingredients not found.";
    }

    final endIndex = paragraph.indexOf(endChar, startIndex + startText.length);
    if (endIndex == -1) {
      return paragraph.substring(startIndex);
    }

    return paragraph.substring(startIndex, endIndex + 1);
  }

  void setText(value) {
    controller.add(value);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ScalableOCR(
              paintboxCustom: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4.0
                ..color = const Color.fromARGB(153, 102, 160, 241),
              boxLeftOff: 10,
              boxBottomOff: 5,
              boxRightOff: 10,
              boxTopOff: 5,
              boxHeight: MediaQuery.of(context).size.height / 1.9,
              getRawData: (value) {
                // You can inspect the raw OCR result if needed
                // inspect(value);
              },
              getScannedText: (value) {
                if (value.toLowerCase().contains('ingredients')) {

                  print(value);
                  setText(extractIngredients(value));
                }
              },
            ),
            StreamBuilder<String>(
              stream: controller.stream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Result(text: snapshot.data != null ? snapshot.data! : "");
              },

            ),
          ],
        ),
      ),
    );
  }
}

class Result extends StatelessWidget {
  const Result({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        const Text("= = = Result = = =",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
        SizedBox(height: 10,),
        Card(child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: text=='Ingredients not found.'?Text(text,style: const TextStyle(color: Colors.red,fontSize: 16,fontWeight: FontWeight.w500),):Text(text),
        )),
      ],
    );

  }
}



