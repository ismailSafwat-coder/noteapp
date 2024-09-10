import 'package:firbaseapp/catagories/add.dart';

import 'package:firbaseapp/fillter.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firbaseapp/auth/loginpage.dart';
import 'package:firbaseapp/auth/forgetpassword.dart';
import 'package:firbaseapp/auth/signuppage.dart';
import 'package:firbaseapp/firebase_options.dart';
import 'package:firbaseapp/homepage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("the message is =================== ");
  print(message.notification!.title);
  print("the body of message is =================== ");
  print(message.notification!.body);
  print(message.data);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('======== User is currently signed out!');
      } else {
        print('======== User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "SignUp": (context) => const SignUp(),
        "Login": (context) => const Login(),
        "HomePage": (context) => const MyHomePage(),
        "AddPage": (context) => const AddPage(),
        "FillterPage": (context) => const FillterPage(),
        "ForgetPassword": (context) => const ForgetPassword(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            iconTheme: const IconThemeData(color: Colors.white),
            color: Colors.orange[300],
            titleTextStyle: const TextStyle(
                fontSize: 27, fontWeight: FontWeight.w600, color: Colors.white),
            centerTitle: true),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified
          ? const MyHomePage()
          : const Login(),
    );
  }
}
