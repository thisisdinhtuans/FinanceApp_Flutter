import 'package:flutter/material.dart';
import 'package:login/StockScreen.dart';
import 'package:login/model.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class FirstPage extends StatefulWidget {
  final int stockId;
  const FirstPage({Key? key, required this.stockId}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

final TextEditingController _titleCtlr = TextEditingController();
final TextEditingController _contentCtlr = TextEditingController();

Future<bool> saveComment(int stockId, String? title, String? content) async {
  var client = http.Client();
  try {
    var url = Uri.http('10.0.2.2:5296', '/api/comment/$stockId');
    var headers = {'Content-Type': 'application/json'};
    var body = convert.jsonEncode({
      'title': title,
      'content': content,
    });

    var response = await client.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  } catch (error) {
    print('Error: $error');
    return false;
  } finally {
    client.close();
  }
}

resetInputFields() {
  _titleCtlr.clear();
  _contentCtlr.clear();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Comment')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    TextFormField(
                      controller: _titleCtlr,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Title",
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _contentCtlr,
                      maxLines:
                          null, // Đặt maxLines thành null để cho phép đa dòng
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Content",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                child: const Text("Save Comment"),
                onPressed: () async {
                  var title = _titleCtlr.text;
                  var content = _contentCtlr.text;
                  if (title.isNotEmpty && content.isNotEmpty) {
                    bool isSuccess =
                        await saveComment(widget.stockId, title, content);
                    if (isSuccess) {
                      resetInputFields();
                      Navigator.pop(context, true); // Thêm comment thành công
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to add comment'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 5),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all the fields'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 5),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
