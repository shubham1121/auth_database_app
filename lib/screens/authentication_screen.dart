import 'package:auth_database_cart/models/our_user.dart';
import 'package:auth_database_cart/screens/home_page.dart';
import 'package:auth_database_cart/utils/device_size.dart';
import 'package:auth_database_cart/utils/firebase_auth.dart';
import 'package:auth_database_cart/utils/loading.dart';
import 'package:flutter/material.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  TextEditingController userFullName = TextEditingController();
  TextEditingController userContactNumber = TextEditingController();
  TextEditingController userProfession = TextEditingController();
  final AuthService _authService = AuthService();

  final _loginFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();
  bool loginState = true;
  bool isLoading = false;
  @override
  void dispose() {
    userEmail.dispose();
    userPassword.dispose();
    userFullName.dispose();
    userContactNumber.dispose();
    userProfession.dispose();
    super.dispose();
  }

  validateAndRegister(context) async {
    if (_signUpFormKey.currentState!.validate()) {
      _authService.setDataforUser(
          userFullName.text, userContactNumber.text, userProfession.text);
      setState(() {
        isLoading = true;
      });
      dynamic result =
          await _authService.signUpUser(userEmail.text, userPassword.text);
      if (result == null) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('We got an error'),
            ),
          );
        });
      }
    }
  }

  authenticateAndLogin(context) async {
    setState(() {
      isLoading = true;
    });
    dynamic result =
        await _authService.loginUser(userEmail.text, userPassword.text);
    if (result != 'valid') {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.toString()),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: isLoading
            ? Loading(false)
            : Scaffold(
                appBar: AppBar(
                  title: loginState
                      ? const Text("LogIn Screen")
                      : const Text("Registration Screen"),
                  actions: [
                    IconButton(
                      onPressed: loginState
                          ? () {
                              setState(() {
                                loginState = false;
                              });
                            }
                          : () {
                              setState(() {
                                loginState = true;
                              });
                            },
                      icon: Icon(
                        loginState ? Icons.person_add : Icons.login_outlined,
                      ),
                    ),
                  ],
                ),
                body: loginState
                    ? ListView(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 25),
                                child: Form(
                                  key: _loginFormKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        style: TextStyle(
                                          fontSize: getOrientation(context) ==
                                                  Orientation.portrait
                                              ? displayWidth(context) * 0.045
                                              : displayHeight(context) * 0.045,
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        autofocus: false,
                                        controller: userEmail,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter Username',
                                          labelText: 'Email',
                                        ),
                                      ),
                                      TextFormField(
                                        obscureText: true,
                                        style: TextStyle(
                                          fontSize: getOrientation(context) ==
                                                  Orientation.portrait
                                              ? displayWidth(context) * 0.045
                                              : displayHeight(context) * 0.045,
                                        ),
                                        autofocus: false,
                                        controller: userPassword,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter Password',
                                          labelText: 'Password',
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: InkWell(
                                          onTap: () {
                                            print(userEmail.text);
                                            print(userPassword.text);
                                            authenticateAndLogin(context);
                                          },
                                          child: Container(
                                            height: getOrientation(context) ==
                                                    Orientation.portrait
                                                ? displayHeight(context) * 0.05
                                                : displayHeight(context) * 0.12,
                                            width: getOrientation(context) ==
                                                    Orientation.portrait
                                                ? displayWidth(context) * 0.2
                                                : displayWidth(context) * 0.09,
                                            child: Center(
                                              child: Text(
                                                'Login',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: getOrientation(
                                                              context) ==
                                                          Orientation.portrait
                                                      ? displayWidth(context) *
                                                          0.045
                                                      : displayHeight(context) *
                                                          0.045,
                                                ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.indigo,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : ListView(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 25),
                                child: Form(
                                  key: _signUpFormKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Full Name Can't be Empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        style: TextStyle(
                                          fontSize: getOrientation(context) ==
                                                  Orientation.portrait
                                              ? displayWidth(context) * 0.045
                                              : displayHeight(context) * 0.045,
                                        ),
                                        keyboardType: TextInputType.name,
                                        autofocus: false,
                                        controller: userFullName,
                                        decoration: const InputDecoration(
                                          hintText: 'Ram Teri Ganga',
                                          labelText: 'Full Name',
                                        ),
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Contact Number Can't be Empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        style: TextStyle(
                                          fontSize: getOrientation(context) ==
                                                  Orientation.portrait
                                              ? displayWidth(context) * 0.045
                                              : displayHeight(context) * 0.045,
                                        ),
                                        keyboardType: TextInputType.number,
                                        autofocus: false,
                                        controller: userContactNumber,
                                        decoration: const InputDecoration(
                                          hintText: '1234567890',
                                          labelText: 'Mobile Number',
                                        ),
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Profession Can't be Empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        style: TextStyle(
                                          fontSize: getOrientation(context) ==
                                                  Orientation.portrait
                                              ? displayWidth(context) * 0.045
                                              : displayHeight(context) * 0.045,
                                        ),
                                        keyboardType: TextInputType.text,
                                        autofocus: false,
                                        controller: userProfession,
                                        decoration: const InputDecoration(
                                          hintText: 'Student',
                                          labelText: 'Profession',
                                        ),
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Username Can't be Empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        style: TextStyle(
                                          fontSize: getOrientation(context) ==
                                                  Orientation.portrait
                                              ? displayWidth(context) * 0.045
                                              : displayHeight(context) * 0.045,
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        autofocus: false,
                                        controller: userEmail,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter Username',
                                          labelText: 'Email',
                                        ),
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Password Can't be Empty";
                                          } else if (value.length < 6) {
                                            return "Password should be of Atleast 6 characters";
                                          } else {
                                            return null;
                                          }
                                        },
                                        obscureText: true,
                                        style: TextStyle(
                                          fontSize: getOrientation(context) ==
                                                  Orientation.portrait
                                              ? displayWidth(context) * 0.045
                                              : displayHeight(context) * 0.045,
                                        ),
                                        autofocus: false,
                                        controller: userPassword,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter Password',
                                          labelText: 'Password',
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: InkWell(
                                          onTap: () {
                                            print(userEmail.text);
                                            print(userPassword.text);
                                            validateAndRegister(context);
                                          },
                                          child: Container(
                                            height: getOrientation(context) ==
                                                    Orientation.portrait
                                                ? displayHeight(context) * 0.05
                                                : displayHeight(context) * 0.12,
                                            width: getOrientation(context) ==
                                                    Orientation.portrait
                                                ? displayWidth(context) * 0.2
                                                : displayWidth(context) * 0.09,
                                            child: Center(
                                              child: Text(
                                                'Register',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: getOrientation(
                                                              context) ==
                                                          Orientation.portrait
                                                      ? displayWidth(context) *
                                                          0.045
                                                      : displayHeight(context) *
                                                          0.045,
                                                ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.indigo,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
      ),
    );
  }
}
