import 'package:firbaseapp/componets/customcomponent.dart';
import 'package:firbaseapp/componets/customlogoauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController email = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    email.dispose();
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
                  const SizedBox(
                    height: 50,
                  ),
                  const CustomLogoAuth(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "ForgetPassword",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "ForgetPassword to continue using the App",
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Email",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  CustomTextFormField(
                    validator: (val) {
                      if (val == "") {
                        return "cant be empety";
                      }
                      return null;
                    },
                    hint: "Enter Email",
                    mycontroller: email,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            MaterialButton(
              height: 45,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.orangeAccent[400],
              child: const Text(
                "Send Rest To Email",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: email.text);
                  email.clear();
                  Navigator.of(context).pushNamed("Login");
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.rightSlide,
                    title: 'Error',
                    desc:
                        'the email is send rest your password and sign in with the new password',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {},
                  ).show();
                } catch (e) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    title: 'Error',
                    desc: 'please enter your email',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {},
                  ).show();
                }
              },
            ),
            const SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed("Login");
              },
              child: Center(
                child: Text.rich(TextSpan(children: [
                  const TextSpan(text: "Already Have Account  "),
                  TextSpan(
                      onEnter: (event) {},
                      text: "Login ",
                      style: const TextStyle(color: Colors.lightBlue))
                ])),
              ),
            )
          ],
        ),
      ),
    );
  }
}
