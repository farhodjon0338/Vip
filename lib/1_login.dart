import 'package:flutter/material.dart';
import 'package:vip/login.dart';
import 'package:vip/royxat.dart';

class log_in extends StatefulWidget {
  const log_in({super.key});

  @override
  State<log_in> createState() => _log_inState();
}

class _log_inState extends State<log_in> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              height: 250,
              width: double.infinity,
              child: Image.asset(
                'rasm/1.jpg',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Royxat()),
                            );
                          });
                        },
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            height: 35,
                            child: Center(
                              child: Text(
                                "Ro'yhatdan o'tish",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[600],
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: Colors.teal.shade600,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          });
                        },
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            height: 35,
                            child: Center(
                              child: Text(
                                "Kirish",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.teal[600],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
