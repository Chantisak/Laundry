import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../services/network_service.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
        ),
      ),
      body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 2, 93, 167),
            Color.fromARGB(255, 0, 3, 84),
          ])),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Image.asset(
                  'assets/images/luandry-logo.png',
                  height: 80,
                ),
                Text(
                  'สมัครสมาชิก',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Constant.WHITE_COLOR,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.all(16),
                          isDense: false,
                          hintText: 'ชื่อ',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      controller: nameController),
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
                      controller: usernameController),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Constant.WHITE_COLOR,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.all(16),
                          isDense: false,
                          hintText: 'รหัสผ่าน',
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
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      controller: passwordController),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        NetworkService()
                            .register(
                          nameController.text.trim(),
                          usernameController.text.trim(),
                          passwordController.text.trim(),
                        )
                            .then((value) async {
                          if (value.result == 'ok') {
                            Navigator.pop(context);
                            SnackBar snackBar = SnackBar(
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('สมัครสำเร็จ'),
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                ],
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            SnackBar snackBar = SnackBar(
                              content: Text(value.message ?? ''),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        });
                      },
                      child: const Text('สมัคร'),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
