import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/screens/login.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF263238),
      appBar: AppBar(backgroundColor: Color(0xFF263238), toolbarHeight: -10),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 90),
                    child: Image.asset(
                      'assets/icons/bro.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                  Image.asset(
                    'assets/images/app_img.png',
                    width: 120,
                    height: 120,
                  ),
                ],
              ),
              // SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(right: 20, left: 20),
                color: Colors.white,
                child: Image.asset('assets/images/pana.png'),
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(15),
                child: Image.asset('assets/images/homepage1.png'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => Login());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFED36A),
                  minimumSize: Size(400, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text(
                  "Let's Start",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              // SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
