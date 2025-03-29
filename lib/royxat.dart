import 'dart:io';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vip/login.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:imgur/imgur.dart';

class Royxat extends StatefulWidget {
  const Royxat({Key? key}) : super(key: key);

  @override
  State<Royxat> createState() => _RoyxatState();
}

class _RoyxatState extends State<Royxat> {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController mazilController = TextEditingController();
  TextEditingController rasmController = TextEditingController();
  TextEditingController lavozimController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showError = false;
  bool showPassword = false;
  bool isLoading = false;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        rasmController.text = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[600],
        title: Text(
          "Ro'yhatdan o'tish",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: fullnameController,
                decoration: InputDecoration(labelText: 'Isim Familya'),
              ),
              TextField(
                controller: telController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Telefon nomer'),
              ),
              TextField(
                controller: mazilController,
                decoration: InputDecoration(labelText: 'Manzil'),
              ),
              TextField(
                controller: lavozimController,
                decoration: InputDecoration(labelText: 'Lavozim'),
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Foydalanuvchi nom'),
              ),
              TextField(
                controller: passwordController,
                keyboardType: TextInputType.number,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  labelText: 'Parol',
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 90,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal[600]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: rasmController.text.isNotEmpty
                      ? Image.file(File(rasmController.text), fit: BoxFit.cover)
                      : Icon(Icons.add_photo_alternate,
                          color: Colors.teal[600], size: 50),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Visibility(
                visible: showError,
                child: Text(
                  "Iltimos, barcha maydonlarni to'ldiring",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SizedBox(
                height: 28,
              ),
              GestureDetector(
                onTap: () async {
                  if (isLoading) {
                    return;
                  }

                  setState(() {
                    isLoading = true;
                  });

                  try {
                    String fullname = fullnameController.text.trim();
                    String tel = telController.text.trim();
                    String manzil = mazilController.text.trim();
                    String rasm = rasmController.text.trim();
                    String lavozim = lavozimController.text.trim();
                    String username = usernameController.text.trim();
                    String password = passwordController.text.trim();

                    if (fullname.isNotEmpty &&
                        tel.isNotEmpty &&
                        manzil.isNotEmpty &&
                        username.isNotEmpty &&
                        password.isNotEmpty) {
                      showError = false;

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );

                      await postData(
                        context,
                        fullname,
                        tel,
                        manzil,
                        rasm,
                        lavozim,
                        username,
                        password,
                      );

                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    } else {
                      setState(() {
                        showError = true;
                      });
                    }
                  } catch (error) {
                    print('Error: $error');
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: Container(
                  width: 120,
                  height: 35,
                  child: Center(
                    child: Text(
                      "Tasdiqlash",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal[600],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> postData(
    BuildContext context,
    String fullname,
    String tel,
    String manzil,
    String rasm,
    String lavozim,
    String username,
    String password,
  ) async {
    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    final String apiUrl = "https://dash.vips.uz/api-in/38/1980/29815";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'apipassword': 'm2007',
          'fullname': fullname,
          'telnomer': tel,
          'manzili': manzil,
          'rasm': rasm,
          'lavozim': lavozim,
          'username': username,
          'passwordd': hashedPassword,
        },
      );

      if (response.statusCode == 200) {
        print('Data posted successfully');
      } else {
        print('Failed to post data');
      }
    } catch (error) {
      print('Error posting data: $error');
    }
  }
}
