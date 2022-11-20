import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:imgur/imgur.dart' as imgur;
import 'package:path/path.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vibration/vibration.dart';

class imgCap {
  late File capImage;
  late Context context;

  static final FlutterTts flutterTts = FlutterTts();

  static uploadImg(BuildContext context, File image) async {
    print("stage 1");
    final client = imgur.Imgur(
        imgur.Authentication.fromToken('INSERT YOUR IMGUR TOKEN HERE'));
    print("stage 2");

    /// Upload an image from path
    String imgLink = await client.image
        .uploadImage(
          imagePath: image.path,
        )
        .then((image) => image.link);
    print("stage 3");
    String caption = await extractCaption(imgLink);
    print("stage 5");
    _speak(caption);
    showCaptionDialog(context, caption, image);
  }

  static _speak(String output) async {
    if ((await Vibration.hasVibrator())!) {
      Vibration.vibrate(amplitude: 500, duration: 200);
    }
    await flutterTts.speak(output);
  }

  static Future extractCaption(String imgLink) async {
    print("stage 4 ");
    var caption = await http.post('https://bow-flannel-food.glitch.me/caption',
        body: {"image_url": imgLink});
    print("stage a");
    var parsed = json.decode(caption.body);
    print("stage b");
    return parsed.toString();
  }

  static Future<void> showCaptionDialog(
      BuildContext context, String text, File picture) async {
    final ButtonStyle elevatedButtonStyle1 = ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(10.0),
      backgroundColor: HexColor('6d597a'),
      elevation: 5.0,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(16.0)),
    );
    final ButtonStyle elevatedButtonstyle2 = ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(10.0),
      backgroundColor: HexColor('6d597a'),
      elevation: 5.0,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(16.0)),
    );
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
              title: Text('Image Caption'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    new Container(
                      width: 300.0,
                      height: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          _speak(text);
                        },
                        style: elevatedButtonStyle1,
                        child: const Text(
                          'Replay',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    new Container(
                      width: 300.0,
                      height: 20,
                    ),
                    new Container(
                        width: 300.0,
                        height: 250,
                        child: ElevatedButton(
                          onPressed: _stopTts,
                          style: elevatedButtonstyle2,
                          child: const Text(
                            'Stop',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    new Container(
                      width: 300.0,
                      height: 20,
                    ),
                    new Image.file(picture),
                    SizedBox(width: 20),
                    new Text("$text"),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
    );
  }

  static Future _stopTts() async {
    if ((await Vibration.hasVibrator())!) {
      Vibration.vibrate(amplitude: 100, duration: 200);
    }
    flutterTts.stop();
  }
}
