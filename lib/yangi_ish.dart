import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:vip/elondanish.dart';

class Yangish extends StatefulWidget {
  const Yangish({Key? key}) : super(key: key);

  @override
  _YangishState createState() => _YangishState();
}

class _YangishState extends State<Yangish> {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController ishidController = TextEditingController();
  List<Map<String, dynamic>> data = [];
  bool isLoading = true;
  dynamic stafid = "";
  var name = "";
  String status = "0";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    stafid = await SessionManager().get("Ids");
    try {
      final response = await http
          .get(Uri.parse('https://dash.vips.uz/api/38/1980/29817?status=1'));

      if (response.statusCode == 200) {
        data.clear();

        final List<dynamic> jsonData = json.decode(response.body);

        for (var item in jsonData) {
          data.add(Map<String, dynamic>.from(item));
        }

        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data from the API');
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> postData(
    String id,
    var name,
    String status,
  ) async {
    name = (await SessionManager().get("Ism")).toString();
    final String apiUrl = "https://dash.vips.uz/api-up/38/1980/29817";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'apipassword': 'm2007',
          'where': 'id:$id',
          'olganfullname': name,
          'isholganid': stafid.toString(),
          'status': status,
        },
      );

      if (response.statusCode == 200) {
        print('Data added successfully');

        final snackBar = SnackBar(
          backgroundColor: Colors.teal[600],
          content: Text(
            "Muofaqiyatlik qo'shildi",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        fetchData();
      } else {
        print('Failed to add data');
      }
    } catch (error) {
      print('Error adding data: $error');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
      data.clear();
    });
    await fetchData();
  }

  Future<void> _showDialog(String id) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tasdiqlash"),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: 300.0,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      "Rostdan ham bu ishni olmoqchimsiz!",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  ButtonBar(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Yo'q"),
                      ),
                      TextButton(
                        onPressed: () {
                          postData(id, name, status);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => elonish()),
                          );
                        },
                        child: Text("Ha"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
            "E'londagi ishlar",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 190,
                            width: double.infinity,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Ish nomi:${data[index]['nomi']}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'Ish joy:${data[index]['joyi']}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'Kimdan:${data[index]['fulname']}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _showDialog(
                                            data[index]['id'].toString());
                                      },
                                      child: SizedBox(
                                        width: 150,
                                        height: 45,
                                        child: Card(
                                          color: Colors.teal[600],
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "Qo'shib olish",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ExpansionTile(
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Qisqacha malumot",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            ),
                            children: <Widget>[
                              Text(
                                "${data[index]['malumoti']}",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ));
  }
}
