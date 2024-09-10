import 'package:google_sign_in/google_sign_in.dart';
import 'package:firbaseapp/componets/custombuttomauth.dart';
import 'package:firbaseapp/componets/customcomponent.dart';
import 'package:firbaseapp/componets/customlogoauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool loading = false;
  void signInWithGoogle(BuildContext context) async {
    setState(() {
      loading = true; // Set loading state to true when starting sign-in process
    });

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // If user cancels the sign-in, googleUser will be null
      if (googleUser == null) {
        setState(() {
          loading =
              false; // Set loading state to false when sign-in is cancelled
        });
        return; // Exit the function if googleUser is null
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to the Home Page after successful sign-in
      Navigator.of(context)
          .pushNamedAndRemoveUntil("HomePage", (route) => false);
    } catch (e) {
      print("Error signing in with Google: $e");
      // Handle errors here
    } finally {
      setState(() {
        loading =
            false; // Set loading state to false when sign-in process is finished
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(15),
              child: ListView(
                children: [
                  Form(
                    key: formState,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        const CustomLogoAuth(),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "login to continue using the App",
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        CustomTextFormField(
                          validator: (val) {
                            if (val == "") {
                              return "cant be empty";
                            }
                            return null;
                          },
                          hint: "Enter Email",
                          mycontroller: email,
                        ),
                        const Text(
                          "Password",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        CustomTextFormField(
                          validator: (val) {
                            if (val == "") {
                              return "cant be empty";
                            }
                            return null;
                          },
                          hint: "Enter password",
                          mycontroller: password,
                        ),
                        InkWell(
                          onTap: () async {
                            Navigator.of(context).pushNamed("ForgetPassword");
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: const Text(
                              "Forgot Password ?",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButtonAuth(
                    titel: "LogIn",
                    onPressed: () async {
                      loading = true;
                      setState(() {});
                      if (formState.currentState!.validate()) {
                        try {
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email.text, password: password.text);
                          loading = false;
                          setState(() {});
                          if (credential.user!.emailVerified) {
                            Navigator.of(context).pushNamed("HomePage");
                          } else {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.info,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'Please verify your email',
                              btnCancelOnPress: () {
                                FirebaseAuth.instance.currentUser!
                                    .sendEmailVerification();
                              },
                              btnOkOnPress: () {},
                              btnCancelText: "Send again",
                            ).show();
                            setState(() {});
                          }
                        } on FirebaseAuthException catch (e) {
                          loading = false;
                          setState(() {});
                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'No user found for that email.',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {},
                            ).show();
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'Wrong password provided for that user',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {},
                            ).show();
                          }
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  MaterialButton(
                    height: 45,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.orangeAccent[400],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "Login With Google",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Image.asset(
                          "images/4.png",
                          width: 25,
                          height: 25,
                        )
                      ],
                    ),
                    onPressed: () {
                      signInWithGoogle(context);
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  if (loading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("SignUp");
                    },
                    child: const Center(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: "Don't Have An Account ? "),
                        TextSpan(
                            text: "Register ",
                            style: TextStyle(color: Colors.lightBlue))
                      ])),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
