import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const batteryPlatform = MethodChannel('samples.flutter.dev/battery');
  static const sumPlatform = MethodChannel('samples.flutter.dev/sum');
  static const imgPlatform = MethodChannel('samples.flutter.dev/img');

  String txt = '';
  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();

  Future<String?> _getBatteryLevel() async {
    try {
      final result = await batteryPlatform.invokeMethod<int>('getBatteryLevel');
      return '$result % .';
    } on PlatformException catch (e) {
      return e.message;
    }
  }

  Future<int> _calculateSum(int a, int b) async {
    try {
      final int result =
          await sumPlatform.invokeMethod('calculateSum', {'a': a, 'b': b});
      return result;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to calculate sum: ${e.message}');
      }
      return -1;
    }
  }

  Future<String> _getImg() async {
    try {
      String? result = await imgPlatform.invokeMethod<String>('img');
      setState(() {
        txt = result!;
      });
      return result!;
    } on PlatformException catch (e) {
      return e.message.toString();
    }
  }

  @override
  void initState() {
    _getImg().then((value) => txt = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              txt.isEmpty
                  ? const CircularProgressIndicator()
                  : Image.network(txt),
              const SizedBox(height: 100),
              const Divider(),
              ElevatedButton(
                child: const Text('Get Battery Level'),
                onPressed: () {
                  _getBatteryLevel().then((result) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Battery Level'),
                          content: Text('The Battery Level is: $result'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  });
                },
              ),
              const Divider(),
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: textEditingController1,
                      textAlign: TextAlign.center,
                      autofocus: false,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: textEditingController2,
                      textAlign: TextAlign.center,
                      autofocus: false,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Calculate Sum'),
                onPressed: () {
                  _calculateSum(int.parse(textEditingController1.text),
                          int.parse(textEditingController2.text))
                      .then((result) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Sum Result'),
                          content: Text('The sum is: $result'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
