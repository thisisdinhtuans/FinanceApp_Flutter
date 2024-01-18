import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:login/model.dart';

class StockScreen extends StatefulWidget {
  final int stockId; // Add a property to store the stockId

  const StockScreen({Key? key, required this.stockId}) : super(key: key);

  @override
  State<StockScreen> createState() => _StockScreenState();
}

Future<Stock> detailsStock(int id) async {
  var client = http.Client();
  try {
    var url = Uri.http('10.0.2.2:5296', 'api/stock/$id');
    var headers = {'Content-Type': 'application/json'};

    var response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      return Stock.fromJson(convert.jsonDecode(response.body));
    } else {
      throw Exception('Failed to load stock details');
    }
  } catch (error) {
    throw Exception('Error: $error');
  } finally {
    client.close();
  }
}

class _StockScreenState extends State<StockScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: detailsStock(widget.stockId), // Change the id as needed
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var stock = snapshot.data as Stock;
          return SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(
                    255, 255, 255, 1), // Set the background color to white
                image: DecorationImage(
                  image: NetworkImage(
                      'https://images.unsplash.com/photo-1547483238-2cbf881a559f?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8fA%3D%3D'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stock Details:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'ID: ${stock.id}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Symbol: ${stock.symbol}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Company Name: ${stock.companyName}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Purchase: ${stock.purchase}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Last Div: ${stock.lastDiv}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Industry: ${stock.industry}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Market Cap: ${stock.marketCap}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Comments:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: stock.comments?.length ?? 0,
                    itemBuilder: (context, index) {
                      var comment = stock.comments![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Title: ${comment.title}',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Content: ${comment.content}',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Created On: ${comment.createdOn}',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Divider(),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}


// class _StockScreenState extends State<StockScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Text("Hello");
//   }
// }
