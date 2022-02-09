// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe, avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
//import 'package:flutter_xlider/flutter_xlider.dart';

String port = "12344";
String ipAddr = "10.225.10.30";
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hürover Control App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Hürover Control App'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _leftValue = 0, _rightValue = 0, _bothValue = 0;
  Color connection = Colors.red;
  late TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          /*
          TextField(
            controller: controller,
            onSubmitted: () {
              ipAddr = controller.text;
            },
          ),*/

          IconButton(
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh),
            color: Colors.white,
          ),
          TextButton(
            child: Text(
              "IP",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => ChangeIpScreen(),
              );
            },
          ),
          TextButton(
            child: Text(
              "Port",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => ChangePortScreen(),
              );
            },
          ),
          Image.asset('assets/H-Mech.jpeg'),
          Container(
            //margin: EdgeInsets.all(10),
            width: 20,
            height: 20,
            decoration: BoxDecoration(color: connection),
          ),
        ],
        title: Text(widget.title),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Slider(
                        divisions: 100,
                        min: -250,
                        max: 250,
                        value: _leftValue,
                        onChanged: (value) {
                          setState(() {
                            _leftValue = value;
                          });
                        },
                      ),
                    ),
                    /*FlutterSlider(
                    rtl: true,
                    axis: Axis.vertical,
                    values: [330],
                    max: 500,
                    min: 0,
                    //lockHandlers: true,
                    //lockDistance: 10,
                    /*step: FlutterSliderStep(
                      step: 5,
                    ),*/
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      _leftValue = lowerValue;
                      sendToJetson(_leftValue, _rightValue);
                      setState(() {});
                    },
                  ),*/
                  ),
                  Text(
                    _leftValue.toString(),
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Slider(
                        divisions: 100,
                        min: -250,
                        max: 250,
                        value: _bothValue,
                        onChanged: (value) {
                          setState(() {
                            _leftValue = value;
                            _rightValue = value;
                            _bothValue = value;
                          });
                        },
                      ),
                    ),
                    /*FlutterSlider(
                    rtl: true,
                    axis: Axis.vertical,
                    values: const [50],
                    max: 250,
                    min: -250,
                    step: FlutterSliderStep(
                      step: 5,
                    ),
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      _rightValue = lowerValue;
                      _leftValue = lowerValue;
                      _bothValue = lowerValue;
                      sendToJetson(_leftValue, _rightValue);
                      setState(() {});
                    },
                  ),*/
                  ),
                  Text(
                    _bothValue.toString(),
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Slider(
                        divisions: 100,
                        min: -250,
                        max: 250,
                        value: _rightValue,
                        onChanged: (value) {
                          setState(() {
                            _rightValue = value;
                          });
                        },
                      ),
                    ),
                    /*FlutterSlider(
                    rtl: true,
                    axis: Axis.vertical,
                    values: const [50],
                    step: FlutterSliderStep(
                      step: 5,
                    ),
                    max: 250,
                    min: -250,
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      _rightValue = lowerValue;
                      sendToJetson(_leftValue, _rightValue);
                      setState(() {});
                    },
                  ),*/
                  ),
                  Text(
                    _rightValue.toString(),
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  sendToJetson(double leftValue, double rightValue) async {
    final socket = await Socket.connect(ipAddr, int.parse(port));
    print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
    socket.listen(
      // handle data from the server
      (Uint8List data) {
        final serverResponse = String.fromCharCodes(data);
        if (serverResponse == "OK") {
          connection = Colors.green;
        } else {
          connection = Colors.red;
        }
      },
      // handle errors
      onError: (error) {
        print(error);
        socket.destroy();
      },
      // handle server ending connection
      onDone: () {
        print('Message sended.');
        socket.destroy();
      },
    );
    int left = _leftValue.toInt(),
        right = _rightValue.toInt(),
        yonLeft = left > 0 ? 1 : 2,
        yonRight = right > 0 ? 1 : 2;
    left = left.abs();
    right = right.abs();
    socket.write('$yonLeft $left,$yonRight $right');
    await Future.delayed(Duration(seconds: 1));
  }
}

// ignore: must_be_immutable
class ChangePortScreen extends StatelessWidget {
  const ChangePortScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _symbolMeaningController = TextEditingController();
    return AlertDialog(
      scrollable: true,
      content: Center(
        child: Column(
          children: [
            Text(
              'Change Port',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 50,
              child: TextField(
                controller: _symbolMeaningController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: port,
                ),
              ),
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                port = _symbolMeaningController.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeIpScreen extends StatelessWidget {
  const ChangeIpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _symbolMeaningController = TextEditingController();
    return AlertDialog(
      scrollable: true,
      content: Center(
        child: Column(
          children: [
            Text(
              'Change IP Address',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 100,
              child: TextField(
                controller: _symbolMeaningController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: ipAddr,
                ),
              ),
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                ipAddr = _symbolMeaningController.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
