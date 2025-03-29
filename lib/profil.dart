import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  TextEditingController usernameController = TextEditingController();
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
      final response = await http
          .get(Uri.parse('https://dash.vips.uz/api/38/1980/29815?id=$stafid'));

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

  Future<void> showEditDialog() async {
    usernameController.text = data[0]['username'];
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tahrirlash'),
          content: TextField(
            controller: usernameController,
            decoration:
                InputDecoration(labelText: 'Yangi foydalanuvchi nom kiriting'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Qaytish'),
            ),
            ElevatedButton(
              onPressed: () async {
                await postData();
                Navigator.of(context).pop();
              },
              child: Text('Belgilash'),
            ),
          ],
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
            "Mening profilim",
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    '${data[index]['rasm']}',
                                  ),
                                  radius: 110,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            "Id: ${data[index]['id']}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data[index]['fullname']}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Telefon nomer: ${data[index]['telnomer']}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Lavozim: ${data[index]['lavozim']}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              Text(
                                "Foydalanuvchi nom: ${data[index]['username']}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                    showEditDialog();
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.teal[600],
                                    size: 27,
                                  ))
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ));
  }

  Future<bool> postData() async {
    final String apiUrl = "https://dash.vips.uz/api-up/38/1980/29815";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'apipassword': 'm2007',
          'username': usernameController.text,
          'where': 'id:$stafid',
        },
      );

      if (response.statusCode == 200) {
        print('Username updated successfully');

        final snackBar = SnackBar(
          backgroundColor: Colors.teal[600],
          content: Text(
            "Foydalanuvchi nom o'zgartirildi !",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        return true;
      } else {
        print('Failed to update username');
        return false;
      }
    } catch (error) {
      print('Error updating username: $error');
      return false;
    }
  }
}
