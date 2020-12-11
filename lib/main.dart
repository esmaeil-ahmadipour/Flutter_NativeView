import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter-Native Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Channel demo app'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  static const platform = const MethodChannel(
      'ir.ea2.flutter_app_sample3');
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  List<dynamic> phoneNumbersList = [];
  String apiToken;


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    MyHomePage.platform.setMethodCallHandler(_handleMethod);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("{{    {${state}}    }");
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              child: new Text('Show native view'),
              onPressed: ()async{
                showNativeView();
              },
            ),
          ],
        ),
      ),
    );
  }


  Future setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user.token','${phoneNumbersList==[]?'null':phoneNumbersList.length}');
    debugPrint(">>>>>>>>>>> getData");
    getData2();
  }
  Future getData2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiToken = 'token ${prefs.getString('user.token')}';
    debugPrint('apiToken : $apiToken');
    debugPrint(">>>>>>>>>>> getData2");

  }

  Future<dynamic> _getNativeDataList() async {
    String allData='';
    phoneNumbersList = await MyHomePage.platform.invokeMethod('ABC');
    for (var i = 0; i < phoneNumbersList.length; ++i) {
      allData =allData+'/'+ phoneNumbersList[i];
    }
    debugPrint(">>>>>>>>>>> $allData");
    return phoneNumbersList;
  }

  Future<Null> showNativeView() async {
    await MyHomePage.platform.invokeMethod('showNativeView');
  }


  Future<dynamic> _handleMethod(MethodCall call) async {
    switch(call.method) {
      case "message":{
        debugPrint('Flutter: ${call.arguments}');
        _getNativeDataList();
        setData();
      }
      return new Future.value("");
    }
  }
}