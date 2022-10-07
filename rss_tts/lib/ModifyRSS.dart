import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class ModifyRSS extends StatelessWidget {
  const ModifyRSS({super.key});

  modRSS() {
    return ListView.builder(itemBuilder: (BuildContext context, int index) {
      return ListTile();
    });
  }

  _SaveAndBack() {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _SaveAndBack(),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Edit RSS"),
          ),
          body: modRSS(),
        ));
  }
}
