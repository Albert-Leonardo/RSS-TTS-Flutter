import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rss_tts/ModifyRSS.dart';
import 'package:rss_tts/NavBar.dart';

class language extends StatefulWidget {
  const language({super.key});

  @override
  State<language> createState() => _MylanguageState();
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> writeFileLanguage(String s) async {
  final file = await _localFileLanguage;

  // Write the file
  return file.writeAsString(s);
}

Future<File> get _localFileLanguage async {
  final path = await _localPath;
  return File('$path/language.txt');
}

Future<String> readFileLanguage() async {
  File file = await _localFileLanguage;
  if (await file.exists()) {
    try {
      String contents = await file.readAsString();
      if (contents == "") {
        String s =
            "en-US,0.5;ms-MY,0.9;zh-TW,0.5;ko-KR,0.5;ja-JP,0.5;ru-RU,0.5;hu-HU,0.5;th-TH,0.5;nb-no,0.5;tr-TR,0.5;et-EE,0.5;sw,0.5;pt-PT,0.5;vi-VN,0.5;sv-VE,0.5;hi-IN,0.5;fr-FR,0.5;nl-NL,0.5;cs-CZ,0.5;pl-PL,0.5;fil-PH,0.5;it-IT,0.5;es-ES,0.5;";
        await writeFileLanguage(s);
        return s;
      }
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return '0';
    }
  } else {
    String s =
        "en-US,0.5;ms-MY,0.9;zh-TW,0.5;ko-KR,0.5;ja-JP,0.5;ru-RU,0.5;hu-HU,0.5;th-TH,0.5;nb-no,0.5;tr-TR,0.5;et-EE,0.5;sw,0.5;pt-PT,0.5;vi-VN,0.5;sv-VE,0.5;hi-IN,0.5;fr-FR,0.5;nl-NL,0.5;cs-CZ,0.5;pl-PL,0.5;fil-PH,0.5;it-IT,0.5;es-ES,0.5;";
    await writeFileLanguage(s);
    String contents = await file.readAsString();

    return s;
  }
}

late Map<String, double> languageSpeeds = {"Test": 0.5};

updateSpeed() async {
  String s2 = await readFileLanguage();
  final languages = s2.split(";");
  for (int i = 0; i < languages.length - 1; i++) {
    var mapData = languages[i].split(",");

    languageSpeeds[mapData[0]] = double.parse(mapData[1]);
  }
}

convertHashmapToString(Map<String, double> languageSpeeds) async {
  String s = "";
  languageSpeeds.forEach((key, value) {
    s = s + key + "," + value.toString() + ";";
  });
  await writeFileLanguage(s);
}

checkLanguage(String s) {
  if (s == 'English')
    return 'en-US';
  else if (s == 'Bahasa')
    return 'ms-MY';
  else if (s == 'Chinese')
    return 'zh-TW';
  else if (s == 'Korean')
    return 'ko-KR';
  else if (s == 'Japanese')
    return 'ja-JP';
  else if (s == 'Russian')
    return 'ru-RU';
  else if (s == 'Hungarian')
    return 'hu-HU';
  else if (s == 'Thai')
    return 'th-TH';
  else if (s == 'Norwegian Bokmal')
    return 'nb-no';
  else if (s == 'Turkish')
    return 'tr-TR';
  else if (s == 'Estonian')
    return 'et-EE';
  else if (s == 'Swahili')
    return 'sw';
  else if (s == 'Portuguese ')
    return 'pt-PT';
  else if (s == 'Vietnamese')
    return 'vi-VN';
  else if (s == 'Swedish')
    return 'sv-VE';
  else if (s == 'Hindi')
    return 'hi-IN';
  else if (s == 'French')
    return 'fr-FR';
  else if (s == 'Dutch')
    return 'nl-NL';
  else if (s == 'Czech')
    return 'cs-CZ';
  else if (s == 'Polish')
    return 'pl-PL';
  else if (s == 'Filipino')
    return 'fil-PH';
  else if (s == 'Italian')
    return 'it-IT';
  else if (s == 'Spanish') return 'es-ES';
}

checkLanguageBack(String s) {
  if (s == 'en-US')
    return 'English';
  else if (s == 'ms-MY')
    return 'Bahasa';
  else if (s == 'zh-TW')
    return 'Chinese';
  else if (s == 'ko-KR')
    return 'Korean';
  else if (s == 'ja-JP')
    return 'Japanese';
  else if (s == 'ru-RU')
    return 'Russian';
  else if (s == 'hu-HU')
    return 'Hungarian';
  else if (s == 'th-TH')
    return 'Thai';
  else if (s == 'nb-no')
    return 'Norwegian Bokmal';
  else if (s == 'tr-TR')
    return 'Turkish';
  else if (s == 'et-EE')
    return 'Estonian';
  else if (s == 'sw')
    return 'Swahili';
  else if (s == 'pt-PT')
    return 'Portuguese';
  else if (s == 'vi-VN')
    return 'Vietnamese';
  else if (s == 'sv-VE')
    return 'Swedish';
  else if (s == 'hi-IN')
    return 'Hindi';
  else if (s == 'fr-FR')
    return 'French';
  else if (s == 'nl-NL')
    return 'Dutch';
  else if (s == 'cs-CZ')
    return 'Czech';
  else if (s == 'pl-PL')
    return 'Polish';
  else if (s == 'fil-PH')
    return 'Filipino';
  else if (s == 'it-IT')
    return 'Italian';
  else if (s == 'es-ES') return 'Spanish';
}

class NumericalRangeFormatter extends TextInputFormatter {
  final int min;
  final int max;

  NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      return newValue;
    } else if (int.parse(newValue.text) < min) {
      return TextEditingValue().copyWith(text: min.toStringAsFixed(2));
    } else {
      return int.parse(newValue.text) > max ? oldValue : newValue;
    }
  }
}

class _MylanguageState extends State<language> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Language Speeds"),
      ),
      body: FutureBuilder(
        future: updateSpeed(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('An Unexpected Error has Occured'));
              } else {
                return Container(
                  padding: EdgeInsets.fromLTRB(24, 10, 24, 10),
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text('English'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("English")]
                                  as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("English")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Bahasa'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Bahasa")] as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("Bahasa")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Chinese'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Chinese")]
                                  as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("Chinese")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Korean'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Korean")] as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("Korean")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Japanese'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Japanese")]
                                  as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("Japanese")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Russian'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Russian")]
                                  as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("Russian")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Hungarian'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Hungarian")]
                                  as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("Hungarian")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Thai'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Thai")] as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("Thai")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Norwegian Bokmal'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Norwegian Bokmal")]
                                  as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[
                                            checkLanguage("Norwegian Bokmal")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Turkish'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Turkish")]
                                  as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("Turkish")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Estonian'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Estonian")]
                                  as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("Estonian")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Swahili'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Swahili")]
                                  as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("Swahili")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Portuguese'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Portuguese")]
                                  as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[
                                            checkLanguage("Portuguese")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Vietnamese'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Vietnamese")]
                                  as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[
                                            checkLanguage("Vietnamese")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Swedish'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Swedish")]
                                  as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("Swedish")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Hindi'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Hindi")] as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("Hindi")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('French'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("French")] as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("French")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Dutch'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Dutch")] as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("Dutch")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Czech'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Czech")] as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("Czech")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Polish'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Polish")] as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("Polish")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Filipino'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Filipino")]
                                  as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("Filipino")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Italian'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Italian")]
                                  as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("Italian")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Spanish'),
                        contentPadding: EdgeInsets.all(5.0),
                        onTap: () async {
                          double speed =
                              languageSpeeds[checkLanguage("Spanish")]
                                  as double;
                          speed = speed * 100;
                          int intSpeed = speed.toInt();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Adjust speed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Speed from 1-99 (50 is normal speed)'),
                                  TextFormField(
                                    initialValue: intSpeed.toString(),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(2),
                                      NumericalRangeFormatter(min: 1, max: 99),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        icon: Icon(Icons.speed),
                                        hintText: "0-99",
                                        border: InputBorder.none),
                                    onChanged: (String str) {
                                      speed = double.parse(str);
                                    },
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    print("test");
                                    Navigator.pop(context, 'OK');
                                    languageSpeeds[checkLanguage("Spanish")] =
                                        speed / 100;
                                    await convertHashmapToString(
                                        languageSpeeds);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
