import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class elonish extends StatefulWidget {
  const elonish({super.key});

  @override
  State<elonish> createState() => _elonishState();
}

class _elonishState extends State<elonish> {
  List<Map<String, dynamic>> Data = [];
  dynamic stafid = "";
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    fetchdata();
  }

  Future<void> fetchdata() async {
    stafid = await SessionManager().get("Ids");
    try {
      final response = await http.get(
          Uri.parse('https://dash.vips.uz/api/38/1980/29817?isholganid=$stafid'));

      if (response.statusCode == 200) {
        Data.clear();

        final List<dynamic> jsonData = json.decode(response.body);

        for (var item in jsonData) {
          Data.add(Map<String, dynamic>.from(item));
        }

        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load Data from the API');
      }
    } catch (error) {
      print('Error fetching Data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
      Data.clear();
    });
    await fetchdata();
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
            "E'londan olingan ishlarim",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: Data.length,
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
                                      'Ish nomi:${Data[index]['nomi']}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'Ish joyi:${Data[index]['joyi']}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'Kim tomonidan:${Data[index]['fulname']}',
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
                                "${Data[index]['malumoti']}",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
        ));
  }
}
