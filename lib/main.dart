import 'dart:io';

import 'package:flutter/material.dart';
import 'package:login/FirstPage.dart';
import 'package:login/LoginSignup.dart';
import 'package:login/StockScreen.dart';
import 'package:login/model.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginSignup(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  late Future<void> _initStockData;
  List<Stock> lstStock = [];
  @override
  void initState() {
    super.initState();
    _initStockData = _initGetAllStocks();
  }

  Future<void> _initGetAllStocks() async {
    try {
      var url = Uri.http('10.0.2.2:5296', '/api/stock/All');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
        lstStock = jsonResponse.map((e) => Stock.fromJson(e)).toList();
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: FutureBuilder(
          future: _initStockData,
          builder: (BuildContext context, snapshot) {
            return ListView.builder(
              itemCount: lstStock.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StockScreen(stockId: lstStock[index].id),
                          ));
                    },
                    child: Card(
                      shadowColor: Colors.blueAccent,
                      child: ListTile(
                        title: Text(
                            "${lstStock[index].symbol}-${lstStock[index].companyName}"),
                        subtitle: Text(
                            "${lstStock[index].industry} ${lstStock[index].marketCap}"),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Text("I Love you")));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
