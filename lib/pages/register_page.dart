import 'package:fanshop/models/user_model.dart';
import 'package:fanshop/services/firebase_service.dart';
import 'package:fanshop/widgets/navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  bool _isObscure = true;
  bool _errorVisible = false;
  late String errorMessage = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _register() async {
    if (_usernameController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() {
        _errorVisible = true;
        errorMessage = "Please fill in all fields";
      });
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);
        print("User Registered: ${userCredential.user?.email}");

        UserModel user = UserModel(
            uid: userCredential.user?.uid ?? '',
            username: _usernameController.text,
            name: _nameController.text,
            email: _emailController.text);
        _firebaseService.addUser(user);
        print(
            "User Registered to firebase cloud: ${userCredential.user?.email}");
        Navigator.of(context).pushNamed("/loginpage");
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'An error occured')));
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
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome to your next",
                      style: TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 28.0,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w600),
                    ),
                    const Text(
                      "favorite marketplace.",
                      style: TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 28.0,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed("/loginpage");
                      },
                      child: const Text(
                        "Already have an account? Login here.",
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
                          const Text("Username",
                              style: TextStyle(
                                  fontFamily: "DM Sans",
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 15.0),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              hintText: "jondoe",
                              hintStyle: TextStyle(
                                  fontFamily: "DM Sans",
                                  color: Color(0xFFA2A2A2),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500),
                              fillColor: Color(0xFF303030),
                              filled: true,
                              prefixIcon:
                                  Icon(Icons.person, color: Color(0xFFA2A2A2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(color: Color(0xFFA2A2A2))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          const Text("Name",
                              style: TextStyle(
                                  fontFamily: "DM Sans",
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 15.0),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            controller: _nameController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              hintText: "Jon Doe",
                              hintStyle: TextStyle(
                                  fontFamily: "DM Sans",
                                  color: Color(0xFFA2A2A2),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500),
                              fillColor: Color(0xFF303030),
                              filled: true,
                              prefixIcon: Icon(Icons.contact_emergency,
                                  color: Color(0xFFA2A2A2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(color: Color(0xFFA2A2A2))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 20.0),
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
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              hintText: "youremail@email.com",
                              hintStyle: TextStyle(
                                  fontFamily: "DM Sans",
                                  color: Color(0xFFA2A2A2),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500),
                              fillColor: Color(0xFF303030),
                              filled: true,
                              prefixIcon:
                                  Icon(Icons.email, color: Color(0xFFA2A2A2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(color: Color(0xFFA2A2A2))),
                              focusedBorder: OutlineInputBorder(
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
                                      _register();
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
                                      "Register Account",
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
                    SizedBox(height: 20.0),
                    AnimatedOpacity(
                      duration: const Duration(seconds: 1),
                      opacity: _errorVisible ? 1.0 : 0.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          padding:
                              const EdgeInsets.only(top: 16.0, bottom: 16.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 243, 243),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          width: double.infinity,
                          child: Text(
                            errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: "DM Sans",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
