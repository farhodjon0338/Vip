import 'package:flutter/material.dart';
import 'package:vip/1_login.dart';
import 'package:vip/bergan_ish.dart';
import 'package:vip/elondanish.dart';
import 'package:vip/ishberishim.dart';
import 'package:vip/ishlarim.dart';
import 'package:vip/profil.dart';
import 'package:vip/yangi_ish.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: log_in(),
  ));
}

class vip extends StatefulWidget {
  const vip({Key? key}) : super(key: key);

  @override
  State<vip> createState() => _vipState();
}

class _vipState extends State<vip> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> dat = [];
  dynamic stafid = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchdat();
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

  Future<void> fetchdat() async {
    // stafid = await SessionManager().get("Ids");
    try {
      final response =
          await http.get(Uri.parse('https://dash.vips.uz/api/38/1980/29815'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        for (var item in jsonData) {
          dat.add(Map<String, dynamic>.from(item));
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

  Future<void> _refreshdata() async {
    data.clear();
    await fetchdat();
  }

  void _showUserDetails(
    String fullname,
    String ishchining_yoshi,
    String rasmi,
    String manzili,
    String nomeri,
    String lavozimi,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 370,
          child: AlertDialog(
            title: Text(
              "Hodim Ma\'lumotlari",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$fullname',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal)),
                  Text('Yili: $ishchining_yoshi',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal)),
                  Text('Lavozimi: $lavozimi',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal)),
                  Container(
                    width: double.infinity,
                    height: 150,
                    child: Image.network(
                      rasmi,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text('Manzili: $manzili',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal)),
                  Text('Tel: $nomeri',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal)),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Yopish'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Ogohlantirish'),
            content: Text('Rostdan ham ilovadan chiqmoqchimisz?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Yo\'q'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(0),
                child: Text('Ha'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.teal[600],
          title: Text(
            'Vip',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 23),
          ),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal[600],
                ),
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 42,
                            backgroundImage: NetworkImage(
                              '${data[index]['rasm']}',
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "${data[index]['fullname']}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      );
                    }),
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.handyman),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Mening ishlarim"),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ishlarim()),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.announcement),
                    SizedBox(
                      width: 5,
                    ),
                    Text("E'londan olingan ishlar"),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => elonish()),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.handshake),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Men bergan ishlar"),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Berganish()),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(
                      width: 5,
                    ),
                    Text("E'londagi ishlar"),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Yangish()),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.create_new_folder),
                    SizedBox(
                      width: 5,
                    ),
                    Text("E'lon joylash"),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IshJoylash()),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Profil"),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profil()),
                  );
                },
              ),
              SizedBox(
                height: 90,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Designed by",
                        style: TextStyle(fontSize: 15),
                      ),
                      TextButton(
                          onPressed: () {
                             launch("https://t.me/muradov_F/");
                          },
                          child: Tooltip(
                            message: "Telegram",
                            child: Text(
                              "Vip",
                              style: TextStyle(
                                  color: Colors.teal[600],
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15),
                            ),
                          ))
                    ],
                  ),
                  Text(
                    "2024.01 - versiya",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: dat.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          _showUserDetails(
                            dat[index]['fullname'],
                            dat[index]['yoshi'],
                            dat[index]['rasm'],
                            dat[index]['manzili'],
                            dat[index]['telnomer'],
                            dat[index]['lavozim'],
                          );
                        },
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage('${dat[index]['rasm']}'),
                        ),
                        title: Row(
                          children: [
                            Text('${dat[index]['fullname']}'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
