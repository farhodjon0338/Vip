import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:vip/main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final stil = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Color.fromARGB(255, 10, 25, 103));
  final still = TextStyle(fontSize: 12, color: Colors.teal[600]);
  List<Map<String, dynamic>> data = [];
  dynamic parol = '';
  dynamic stafid = "";
  String rasm = "";
  String lavozim = "";
  String yili = "";
  String teli = "";
  var user = "";
  var name = "";
  var fullname = "";
  void login(user) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http
          .get(Uri.parse('https://dash.vips.uz/api/38/1980/29815?username=$user'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        for (var item in jsonData) {
          parol = (item["passwordd"]);
          print(parol);
          name = (item["username"]);
          print(name);
          await SessionManager().set("Ids", (item["id"]));
          await SessionManager().set("Ism", (item["fullname"]));
          await SessionManager().set("Rasmi", (item["rasm"]));
          await SessionManager().set("Lavozimi", (item["lavozim"]));
          await SessionManager().set("yili", (item["yoshi"]));
          await SessionManager().set("teli", (item["telnomer"]));
          await SessionManager().set("user", (item["username"]));
        }

        user = _usernameController.text;
        bool correctPassword = BCrypt.checkpw(_passwordController.text, parol);

        setState(() {
          if (correctPassword) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => vip()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Foydalanuvchi nom yoki parol hato!"),
              backgroundColor: Colors.teal,
            ));
          }
        });
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Foydalanuvchi nom yoki parol hato!"),
          ));
        });
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isChecked = false;
  bool showPassword = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kirish",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal[600],
        elevation: 5,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Column(
                  children: [
                    Text(
                      "Profilingizga kiring",
                      style: stil,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Profilga kirish uchun foydalanuvchi nom va parol kiriting!",
                      style: still,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Foydalanuvchi nomi"),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 50,
                            child: TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Parol"),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 50,
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                TextField(
                                  controller: _passwordController,
                                  style: TextStyle(fontSize: 15),
                                  obscureText: !showPassword,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  activeColor: Colors.teal[600],
                                  value: isChecked,
                                  onChanged: (newBool) {
                                    setState(() {
                                      isChecked = !isChecked;
                                    });
                                  }),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Eslab qolish")
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: FittedBox(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal[600],
                                ),
                                onPressed: isLoading
                                    ? null
                                    : () => login(_usernameController.text),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(75, 12, 75, 12),
                                  child: isLoading
                                      ? CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.deepPurple))
                                      : Text(
                                          "Kirish",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
