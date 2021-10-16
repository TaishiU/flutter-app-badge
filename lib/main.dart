import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _appBadgeSupported = 'Unknown';
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _refreshCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _addBadge({required int count}) {
    FlutterAppBadger.updateBadgeCount(count);
  }

  void _removeBadge() {
    FlutterAppBadger.removeBadge();
  }

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    String appBadgeSupported;
    try {
      bool res = await FlutterAppBadger.isAppBadgeSupported();
      print('res: $res');
      if (res) {
        appBadgeSupported = 'Supported';
      } else {
        appBadgeSupported = 'Not supported';
      }
    } on PlatformException {
      appBadgeSupported = 'Failed to get badge support.';
    }

    if (!mounted) return;

    setState(() {
      _appBadgeSupported = appBadgeSupported;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new SizedBox.expand(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Badge数: $_counter',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Badge supported: '),
                  Text(
                    _appBadgeSupported,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    child: Icon(Icons.refresh),
                    onPressed: () {
                      _refreshCounter();
                      _removeBadge();
                    },
                  ),
                  SizedBox(width: 20),
                  FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      _incrementCounter();
                      _addBadge(count: _counter);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
