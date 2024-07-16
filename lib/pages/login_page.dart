import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanshop/arguments/user_argument.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String errorMessage = "";
  bool _isObscure = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    print("Requesting login...");
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        User? user = userCredential.user;

        if (user != null) {
          QuerySnapshot querySnapshot = await _firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            DocumentSnapshot userDoc = querySnapshot.docs.first;
            String uid = userDoc['uid'];
            String username = userDoc['username'];
            String name = userDoc['name'];

            Navigator.of(context).pushNamed("/artistpreferences",
                arguments: UserArgument(uid, username, name));
          } else {}
        }
      } on FirebaseAuthException catch (e) {
        print("Error: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF202020),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 120.0, bottom: 40.0, left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hey fan,",
                      style: TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 28.0,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w600),
                    ),
                    const Text(
                      "welcome back!",
                      style: TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 28.0,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed("/registerpage");
                      },
                      child: const Text(
                        "New to fanshop? Register here.",
                        style: TextStyle(
                          fontFamily: "DM Sans",
                          fontSize: 16.0,
                          color: Color(0xFFFFE0B0),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFFFFE0B0),
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30.0),
                          const Text("Email",
                              style: TextStyle(
                                  fontFamily: "DM Sans",
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 15.0),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            controller: _emailController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              hintText: "youremail@email.com",
                              hintStyle: const TextStyle(
                                  fontFamily: "DM Sans",
                                  color: Color(0xFFA2A2A2),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500),
                              fillColor: const Color(0xFF303030),
                              filled: true,
                              prefixIcon: const Icon(Icons.email,
                                  color: Color(0xFFA2A2A2)),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(color: Color(0xFFA2A2A2))),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          const Text("Password",
                              style: TextStyle(
                                  fontFamily: "DM Sans",
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 15.0),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            controller: _passwordController,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              hintText: "******",
                              hintStyle: const TextStyle(
                                  fontFamily: "DM Sans",
                                  color: Color(0xFFA2A2A2),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500),
                              fillColor: const Color(0xFF303030),
                              filled: true,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xFFA2A2A2),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                              prefixIcon: const Icon(Icons.lock,
                                  color: Color(0xFFA2A2A2)),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(color: Color(0xFFA2A2A2))),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 40.0),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _login();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFFE0B0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32.0,
                                        vertical: 12.0,
                                      ),
                                    ),
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                        fontFamily: "Quicksand",
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
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
            ],
          ),
        ));
  }
}
