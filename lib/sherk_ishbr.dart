import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'dart:convert';

class SherikIsh extends StatefulWidget {
  const SherikIsh({Key? key}) : super(key: key);

  @override
  _SherikIshState createState() => _SherikIshState();
}

class _SherikIshState extends State<SherikIsh> {
  TextEditingController ishnomiController = TextEditingController();
  TextEditingController ishmalumotController = TextEditingController();
  TextEditingController ishjoyiController = TextEditingController();
  bool isLoading = true;
  String stafid = "";
  var name = "";
  bool isSubmitting = false;
  List<Map<String, dynamic>> data = [];
  List<String> selectedPeopleIds = [];
  List<String> selectedPeopleFullnames = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('hhttps://dash.vips.uz/api/38/1980/29815'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          data = jsonData.cast<Map<String, dynamic>>();
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
          "Ish berish",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: ishnomiController,
                decoration: InputDecoration(labelText: 'Ishning nomi'),
              ),
              TextField(
                controller: ishmalumotController,
                decoration: InputDecoration(labelText: 'Ishning malumoti'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: ishjoyiController,
                decoration: InputDecoration(labelText: 'Ishning joyi'),
              ),
              ExpansionTile(
                title: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    selectedPeopleFullnames.isNotEmpty
                        ? "Kimga: ${selectedPeopleFullnames.join(', ')}"
                        : "Kimga",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                  } else {}
                },
                children: <Widget>[
                  SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  String id = data[index]['id'].toString();
                                  String fullname = data[index]['fullname'];

                                  if (selectedPeopleIds.contains(id)) {
                                    selectedPeopleIds.remove(id);
                                    selectedPeopleFullnames.remove(fullname);
                                  } else {
                                    selectedPeopleIds.add(id);
                                    selectedPeopleFullnames.add(fullname);
                                  }
                                });

                                if (selectedPeopleIds.isNotEmpty) {
                                  Future.delayed(Duration(milliseconds: 300),
                                      () {
                                    setState(() {});
                                  });
                                }
                              },
                              child: SizedBox(
                                height: 48,
                                width: double.infinity,
                                child: Card(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Text(
                                            "${data[index]['fullname']}",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Checkbox(
                                          activeColor: Colors.teal,
                                          value: selectedPeopleIds.contains(
                                              data[index]['id'].toString()),
                                          onChanged: (bool? value) {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () async {
          setState(() {
            isSubmitting = true;
          });

          if (_validateInputs()) {
            await postData(
              ishnomiController.text,
              ishmalumotController.text,
              ishjoyiController.text,
              name,
              selectedPeopleIds,
              selectedPeopleFullnames,
            );
            Navigator.of(context).pop();
          } else {
            setState(() {
              isSubmitting = false;
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
        },
        child: isSubmitting
            ? CircularProgressIndicator(
                color: Colors.deepPurple,
              )
            : Icon(Icons.send),
      ),
    );
  }

  bool _validateInputs() {
    return ishnomiController.text.isNotEmpty &&
        ishmalumotController.text.isNotEmpty &&
        ishjoyiController.text.isNotEmpty;
  }

  Future<void> postData(
    var ishnomi,
    var ishmalumot,
    var ishjoyi,
    var name,
    List<String> selectedPeopleIds,
    List<String> selectedPeopleFullnames,
  ) async {
    stafid = (await SessionManager().get("Ids")).toString();
    name = (await SessionManager().get("Ism")).toString();
    final String apiUrl = "https://dash.vips.uz/api-in/38/1980/29816";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'apipassword': 'm2007',
          'ishnomi': ishnomi,
          'ishmalumoti': ishmalumot,
          'ishningjoyi': ishjoyi,
          'kimdanfulname': name,
          'kimdanid': stafid,
          'kimgaid': selectedPeopleIds.join(','),
          'kimgafullname': selectedPeopleFullnames.join(','),
        },
      );

      if (response.statusCode == 200) {
        print('Data posted successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.teal[600],
            content: Text(
              "Jo'natildi",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      } else {
        print('Failed to post data');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.teal[600],
            content: Text(
              "Jo'natishda xatolik bor!",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } catch (error) {
      print('Error posting data: $error');
    }
  }
}
