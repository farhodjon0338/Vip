import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:vip/yangi_ish.dart';

class IshJoylash extends StatefulWidget {
  const IshJoylash({Key? key}) : super(key: key);

  @override
  State<IshJoylash> createState() => _IshJoylashState();
}

class _IshJoylashState extends State<IshJoylash> {
  TextEditingController ishNomController = TextEditingController();
  TextEditingController ishMalController = TextEditingController();
  TextEditingController ishJoyController = TextEditingController();
  dynamic stafid = "";
  var name = "";
  bool isLoading = false;
  String status = "1";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.teal[600],
        title: Text(
          "E'lon joylash",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: ishNomController,
              decoration: InputDecoration(labelText: 'Ishning nomi'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: ishJoyController,
              decoration: InputDecoration(labelText: 'Ishning joyi'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: ishMalController,
              decoration: InputDecoration(labelText: 'Ishning malumoti'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () async {
          setState(() {
            isLoading = true;
          });

          print("Button Pressed");
          stafid = await SessionManager().get("Ids");
          if (stafid != null) {
            if (ishNomController.text.isNotEmpty &&
                ishMalController.text.isNotEmpty &&
                ishJoyController.text.isNotEmpty) {
              await postData(name, ishNomController.text, ishMalController.text,
                  ishJoyController.text, stafid, status);

              setState(() {
                isLoading = false;
              });
            } else {
              setState(() {
                isLoading = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.teal[600],
                  content: Text(
                    "Iltimos, barcha maydonlarni to'ldiring",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
          } else {
            setState(() {
              isLoading = false;
            });

            print('Error getting stafid. Session might not have "Ids" key.');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.teal[600],
                content: Text(
                  "Ish joylashda xatolik qayta uruning",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Yangish()),
          );
        },
        child: isLoading
            ? CircularProgressIndicator(
                color: Colors.deepPurple,
              )
            : Icon(Icons.send),
      ),
    );
  }

  Future<void> postData(
    String name,
    String ishNom,
    String ishMal,
    String ishJoy,
    dynamic stafid,
    String status,
  ) async {
    name = (await SessionManager().get("Ism")).toString();
    try {
      final String apiUrl = "https://dash.vips.uz/api-in/38/1980/29817";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'apipassword': 'm2007',
          'fulname': name,
          'nomi': ishNom,
          'malumoti': ishMal,
          'joyi': ishJoy,
          'kimdanid': stafid.toString(),
          'status': status,
        },
      );

      if (response.statusCode == 200) {
        print('Data posted successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.teal[600],
            content: Text(
              "Siznig ishingiz joylandi",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      } else {
        print('Failed to post data. Status Code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.teal[600],
            content: Text(
              "Ish joylashda xatolik qayta uruning",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } catch (error) {
      print('Error posting data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.teal[600],
          content: Text(
            "Ish joylashda xatolik qayta uruning: $error",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}
