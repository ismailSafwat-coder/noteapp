import 'package:firbaseapp/componets/custombuttomauth.dart';
import 'package:firbaseapp/componets/customcomponent.dart';
import 'package:firbaseapp/componets/customlogoauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
    username.dispose();
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        Navigator.of(context).pushNamed("Home");
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Failed to sign in with Google',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const CustomLogoAuth(),
                  const SizedBox(height: 10),
                  const Text(
                    "SignUp",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "SignUp to continue using the App",
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Username",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  CustomTextFormField(
                    validator: (val) {
                      if (val == "") {
                        return "Can't be empty";
                      }
                      return null;
                    },
                    hint: "Enter User Name",
                    mycontroller: username,
                  ),
                  const Text(
                    "Email",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  CustomTextFormField(
                    validator: (val) {
                      if (val == "") {
                        return "Can't be empty";
                      }
                      return null;
                    },
                    hint: "Enter Email",
                    mycontroller: email,
                  ),
                  const Text(
                    "Password",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  CustomTextFormField(
                    validator: (val) {
                      if (val == "") {
                        return "Can't be empty";
                      }
                      return null;
                    },
                    hint: "Enter Password",
                    mycontroller: password,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomButtonAuth(
              titel: "Sign Up",
              onPressed: () async {
                if (formState.currentState!.validate()) {
                  try {
                    final credential =
                        await _auth.createUserWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();
                    Navigator.of(context).pushNamed("Login");
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: 'Weak Password',
                        desc: 'The password provided is too weak.',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      ).show();
                    } else if (e.code == 'email-already-in-use') {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: 'Email Already In Use',
                        desc: 'The account already exists for that email.',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      ).show();
                    }
                  } catch (e) {
                    print(e);
                  }
                } else {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    title: 'Error',
                    desc: 'Please fill all fields',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {},
                  ).show();
                }
              },
            ),
            const SizedBox(height: 25),
            MaterialButton(
              height: 45,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.orangeAccent[400],
              onPressed: _signInWithGoogle,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Sign Up With Google",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Image.asset(
                    "images/4.png",
                    width: 25,
                    height: 25,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed("Login");
              },
              child: const Center(
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: "Already Have An Account  "),
                  TextSpan(
                    text: "Login ",
                    style: TextStyle(color: Colors.lightBlue),
                  ),
                ])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
