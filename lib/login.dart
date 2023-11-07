import 'package:flutter/material.dart';
import "package:google_sign_in/google_sign_in.dart";
import "main.dart";

GoogleSignIn signIn = GoogleSignIn();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class IntegerWrapper {
  int p = 0;
}

class BackgroudWrapper extends StatefulBuilder {
  final Widget child;

  BackgroudWrapper({
    required IntegerWrapper time,
    required this.child,
    super.key,
    double? width,
    double? height,
  }) : super(builder: (context, setState) {
          Future.delayed(const Duration(), () {
            setState(() {
              if (time.p < 1) time.p = 1;
            });
          });

          return AnimatedContainer(
              duration: Duration(seconds: 2),
              width: width,
              height: height,
              onEnd: () {
                // print("Time :${time.p}");

                setState(() {
                  time.p = (time.p + 1) % Backgroud.limitColors;
                });
              },
              decoration: Backgroud(time.p),
              child: child);
        });
}

class Backgroud extends BoxDecoration {
  static int limitColors = 16777216;

  Backgroud(int index,
      {List<Color> colorsB = const <Color>[
        Colors.blue,
        Colors.green,
        Colors.indigo,
        Colors.orange
      ]})
      : super(
            gradient: LinearGradient(
          colors: [
            colorsB[(index % colorsB.length)],
            colorsB[((index + 1) % colorsB.length)],
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )) {}
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignInAccount? signInAccount;
  @override
  void initState() {
    super.initState();
    init = true;

    Future.delayed(const Duration(seconds: 8), () {
      setState(() {
        init = false;
      });
    });
  }

  Color bcolor = Colors.blue;
  Color tcolor = Colors.green;
  int index = 0;
  bool init = true;
  IntegerWrapper time = IntegerWrapper();
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: BackgroudWrapper(
      time: IntegerWrapper(),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          !init ? Text("Log in") : SizedBox.shrink(),
          !init
              ? IconButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: () async {
                    if (await signIn.isSignedIn()) await signIn.disconnect();
                    signInAccount = await signIn.signIn();

                    if (signInAccount != null) {
                      print("Name: ${signInAccount!.displayName}");
                      print("email: ${signInAccount!.email}");
                      print("photo: ${signInAccount!.photoUrl}");
                      print("id: ${signInAccount!.id}");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) {
                        return MyHomePage(
                            title: "T for Jobs",
                            email: signInAccount!.email,
                            name: signInAccount!.displayName!);
                      }));
                    } else
                      print("eror null data");
                  },
                  icon: Image.asset("lib/google.png", width: 100, height: 100))
              : Image.asset("lib/logo.jpg", width: 100, height: 100),
          Text("Tinder for jobs")
        ],
      ),
    ));
  }
}
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
      