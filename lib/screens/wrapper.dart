import 'package:auth_database_cart/screens/authentication_screen.dart';
import 'package:auth_database_cart/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  //  goToHomePage(BuildContext context)
  // {
  //   setState(() {
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
  //   });
  // }
  //
  // goToAuthenticationPage(BuildContext context)
  // { setState(() {
  //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const AuthenticationPage()));
  // });
  //
  // }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return user != null ? const HomePage() : const AuthenticationPage() ;
  }
}
