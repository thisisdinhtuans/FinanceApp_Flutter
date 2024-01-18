import 'package:flutter/material.dart';
import 'package:login/StockScreen.dart';
import 'package:login/model.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

late Future<void> _initStockData;
List<Stock> lstStock = [];

Future<void> _initGetAllStocks() async {
  try {
    var url = Uri.https('10.0.2.2:5296', '/api/stock/All');
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

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    super.initState();
    _initStockData = _initGetAllStocks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: FutureBuilder(
          future: _initStockData,
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                itemCount: lstStock.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shadowColor: Colors.blueAccent,
                      child: ListTile(
                        title: Text(
                            "${lstStock[index].symbol}-${lstStock[index].companyName}"),
                        subtitle: Text(
                            "${lstStock[index].industry} ${lstStock[index].marketCap}"),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const StockScreen()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:login/StockScreen.dart';
// import 'package:login/model.dart';
// import 'dart:convert' as convert;
// import 'package:http/http.dart' as http;

// class FirstPage extends StatefulWidget {
//   const FirstPage({super.key});

//   @override
//   State<FirstPage> createState() => _FirstPageState();
// }

// late Future<void> _initStockData;
// List<Stock> lstStock = [];
// Future<void> _initGetAllStocks() async {
//   try {
//     var url = Uri.https('10.0.2.2:5296', '/api/stock/All');
//     var response = await http.get(url);

//     if (response.statusCode == 200) {
//       var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
//       lstStock = jsonResponse.map((e) => Stock.fromJson(e)).toList();
//     } else {
//       print('Request failed with status: ${response.statusCode}.');
//     }
//   } catch (error) {
//     print('Error: $error');
//   }
// }

// class _FirstPageState extends State<FirstPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: FutureBuilder(
//           future: _initStockData,
//           builder: (BuildContext context, snapshot) {
//             return ListView.builder(
//               itemCount: lstStock.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Card(
//                     shadowColor: Colors.blueAccent,
//                     child: ListTile(
//                       title: Text(
//                           "${lstStock[index].symbol}-${lstStock[index].companyName}"),
//                       subtitle: Text(
//                           "${lstStock[index].industry} ${lstStock[index].marketCap}"),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) => const StockScreen()));
//         },
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
