import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:vip/sherk_ishbr.dart';

class Berganish extends StatefulWidget {
  const Berganish({Key? key}) : super(key: key);

  @override
  State<Berganish> createState() => _BerganishState();
}

class _BerganishState extends State<Berganish> {
  List<Map<String, dynamic>> data = [];
  dynamic stafid = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    stafid = await SessionManager().get("Ids");
    try {
      final response = await http.get(
          Uri.parse('https://dash.vips.uz/api/38/1980/29816?kimdanid=$stafid'));

      if (response.statusCode == 200) {
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

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
      data.clear();
    });
    await fetchData();
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
          "Men bergan ishlar",
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
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 135,
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
                                    'Ish nomi:${data[index]['ishnomi']}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    'Ish joyi:${data[index]['ishningjoyi']}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    'Kimga berganim:${data[index]['kimgafullname']}',
                                    style: TextStyle(fontSize: 18),
                                  ),
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
                              "${data[index]['ishmalumoti']}",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SherikIsh()),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
