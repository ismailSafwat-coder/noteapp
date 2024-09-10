import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firbaseapp/chat.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  getToken() async {
    String? mytoken = await FirebaseMessaging.instance.getToken();
    print("=========== $mytoken");
  }

  permessssionnn() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.data['type'] == "chat") {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Chat()));
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            '==========================Message also contained a notification: ${message.notification!.title}');
        print(
            '==========================Message also contained a notification: ${message.notification!.body}');
        AwesomeDialog(
                context: context,
                title: message.notification!.title,
                body: Text("${message.notification!.body}"))
            .show();
      }
    });
    getToken();
    permessssionnn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("message"),
      ),
      body: Container(
        child: MaterialButton(
          color: Colors.red,
          child: const Text("send messsage"),
          onPressed: () {
            sendmessage("flutter demo", "test message");
          },
        ),
      ),
    );
  }
}

sendmessage(title, messsage) async {
  var headersList = {
    'Accept': '*/*',
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAAbGAX62M:APA91bH7siXhaAotjWcLdTGRKekUgxyCJ4GmUPKQ24FABApV8catiWbJf0cp4RhQQMfyXtdfjRruocg3Ww9PVF1DOZaM9Ji_A5fVt30mXgr5q6eWQQk90pBuE5SR5S5aNCMU2YU3xdx-'
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  var body = {
    "to":
        "cpTaq7TQSZ6V5FGR6IOMFU:APA91bEBBbj2plUa4zkzmgnjdVJpA8YzdIj00qOhM2drRCkZuZhwV6MyyusgcBnK24A53_XTV3GkEi0MFOoZoNVg_XyqkZ_1auMLPSxCr_s45p_5OvLcp16CTH6b2qgObKdsS-DS5zR4",
    "notification": {"title": title, "body": messsage}
  };

  var req = http.Request('POST', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    print(resBody);
  } else {
    print(res.reasonPhrase);
  }
}
