import 'package:flutter/material.dart';
import 'package:flutter_text_divider/flutter_text_divider.dart';
// import 'package:text_divider/text_divider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    // _passwordVisible = false;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF263238),
      appBar: AppBar(backgroundColor: Color(0xFF263238), toolbarHeight: 10),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 100),
                    child: Image.asset(
                      'assets/icons/bro.png',
                      width: 70,
                      height: 70,
                    ),
                  ),
                  Image.asset(
                    'assets/images/app_img.png',
                    width: 120,
                    height: 120,
                  ),
                ],
              ),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  // textAlign: TextAlign.left,
                  'Email Address',
                  style: TextStyle(fontSize: 19, color: Color(0xFF8CAAB9)),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF455A64),
                  border: OutlineInputBorder(),
                ),
                // onChanged: () {
                //   // ('Currenprintt text: $text');
                // },
              ),
              SizedBox(height: 20),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  // textAlign: TextAlign.left,
                  'Password',
                  style: TextStyle(fontSize: 19, color: Color(0xFF8CAAB9)),
                ),
              ),
              SizedBox(height: 8),
              // TextField(
              //   decoration: InputDecoration(
              //     filled: true,
              //     fillColor: Color(0xFF455A64),
              //     border: OutlineInputBorder(),
              //   ),
              //   onChanged: (text) {
              //     print('Current text: $text');
              //   },
              // ),
              TextField(
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(),
                  fillColor: Color(0xFF455A64),

                  hintText: 'Enter your password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentGeometry.centerRight,
                child: Text(
                  // textAlign: TextAlign.left,
                  'Forgot Password?',
                  style: TextStyle(fontSize: 16, color: Color(0xFF8CAAB9)),
                ),
              ),
              SizedBox(height: 38),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Login();
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFED36A),
                  minimumSize: Size(400, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 25),
              // Divider(color: Color(0xFF8CAAB9)),
              TextDivider(
                text: "Or continue with",
                color: Color(0xFF8CAAB9),
                // axis: Axis.vertical,
                // gap: 12,
                textStyle: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF8CAAB9),
                ),
              ),
              SizedBox(height: 40),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white, width: 1.5),
                  // backgroundColor: Color(0xFFFED36A),
                  minimumSize: Size(400, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 12,
                  children: [
                    Image.asset('assets/icons/google.png'),
                    Text(
                      "Google",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        // fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              RichText(
                text: TextSpan(
                  text: "Don't have an account?",
                  style: TextStyle(
                    color: Color(0xFF8CAAB9),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' Sign Up',
                      style: TextStyle(
                        color: Color(0xFFFED36A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
