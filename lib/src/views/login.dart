import 'package:flutter/material.dart';
import 'package:laundry/src/views/home.dart';
import 'package:laundry/src/views/register.dart';

import '../constants/constants.dart';
import '../services/local_storage_service.dart';
import '../services/network_service.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 2, 93, 167),
          Color.fromARGB(255, 0, 3, 84),
        ])),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Image.asset(
                    'assets/images/luandry-logo.png',
                    height: 150,
                  ),
                ),
                _buildCardLogin(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Register()),
                    );
                  },
                  child: const Text('สมัครสมาชิก'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildCardLogin() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Constant.WHITE_COLOR,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'เข้าสู่ระบบ',
                  style: TextStyle(fontSize: 25, color: (Constant.BLUE_COLOR)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Constant.WHITE_COLOR,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(16),
                        isDense: false,
                        hintText: 'ชื่อผู้ใช้',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    controller: usernameController,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: !_passwordVisible, //ซ่อนรหัสผ่าน
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Constant.WHITE_COLOR,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.all(16),
                      isDense: false,
                      hintText: 'รหัสผ่าน',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
                          color: Colors.black,
                        ),
                      ),
                    ),
                    controller: passwordController,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      NetworkService()
                          .login(
                        usernameController.text.trim(),
                        passwordController.text.trim(),
                      )
                          .then((value) async {
                        if (value.status == 'Ok') {
                          await LocalStorageService()
                              .setUserInfo(value.name ?? '', value.token ?? '');
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const Home()),
                              (Route<dynamic> route) => false);
                        } else {
                          const snackBar = SnackBar(
                            content: Text('รหัสผ่านไม่ถูกต้อง'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    },
                    child: const Text('เข้าสู่ระบบ'),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
