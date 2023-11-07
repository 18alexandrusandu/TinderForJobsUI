import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tinder_jobs/accountPage.dart';
import 'package:tinder_jobs/chatslist.dart';
import 'login.dart';
import 'package:screenshot/screenshot.dart';

void main() {
  runApp(MyApp());
}

enum Roles { Person, Job }

enum LikeStatus { like, dislike, superlike }

enum ButtonsStatus {
  likePushed,
  dislikePushed,
  superlikePushed,
  redoPushed,
  lightPushed,
  none
}

class Message {
  String to = "";
  String from = "";
  String content = "";

  bool liked = false;

  late DateTime timeStamp;
  Message() {
    timeStamp = DateTime.now();
  }
  Message.withSD(this.to, this.from) {
    timeStamp = DateTime.now();
  }
  Message.withContent(this.to, this.from, this.content) {
    timeStamp = DateTime.now();
  }
  Message.withContentAndTime(this.to, this.from, this.content, this.timeStamp);

  static List<Message> findByTo(List<Message> msg, String toTest) {
    return msg.where((element) => element.to == toTest).toList();
  }

  static List<Message> findByFrom(List<Message> msg, String fromTest) {
    return msg.where((element) => element.from == fromTest).toList();
  }

  static List<Message> findByContent(
      List<Message> msg, String contentToSearch) {
    return msg
        .where((element) => element.content.contains(contentToSearch))
        .toList();
  }
}

List<Message> messagePool = <Message>[];

class User {
  late String name = "Andercou Alexandru";
  late String description = "Progrmator junior fara experienta";
  late String phone = "";
  double minimalSalary = 0;
  double maximalSalary = 0;
  List<String> places = <String>[];
  List<String> experience = <String>[];
  late int type;

  String email = "@gmail.com";
  User.named(this.name);
  Roles role = Roles.Person;

  Widget? front;
  Widget? CvFront;
  late Offset position;
  int duration = 0;
}

class Person extends User {
  String email = "@gmail.com";
  List<String> education = <String>[];
  List<String> skills = <String>[];
  List<Job> savedJobs = <Job>[];
  File? CV;

  Person.named(super.name) : super.named();
}

class Job extends User {
  List<String> domains = <String>[];
  List<String> positions = <String>[];
  List<Person> applications = <Person>[];
  Job.named(super.name) : super.named();
}

List<User> users = <User>[
  Person.named("Andercou Alexandru Stefan"),
  Job.named("Ambo"),
  Person.named("Andercou Lucian"),
  Person.named("Andercou Adrian"),
  Job.named("Arobs"),
  Person.named("Pop Alex")
];
List<User> likedUsers = <User>[];
List<User> dislikedUsers = <User>[];
// Column isList<Person>  also a layout widget. It takes a list of children and
// arranges them vertically. By default, it sizes itself to fit its
// children horizontally, and tries to be as tall as its parent.
//
// Column has various properties to control how it sizes itself and
// how it positions its children. Here we use mainAxisAlignment to
// center the children vertically; the main axis here is the vertical
// axis because Columns are vertical (the cross axis would be
// horizontal).
//
// TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
// action in the IDE, or press "p" in the console), to see the
// wireframe for each widget.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.title,
      required this.email,
      required this.name});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String email;
  final String name;
  @override
  State<MyHomePage> createState() => _MyHomePageState(email, name);
}

User? currentUser = null;
User? lastUserEvaluated = null;
Widget buildOneStamp(String text, Color color,
    {double angle = 0, double opacity = 0}) {
  return Opacity(
      opacity: opacity,
      child: Transform.rotate(
          angle: angle,
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: color, width: 4),
                  borderRadius: BorderRadius.circular(12)),
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: color, fontSize: 48)))));
}

Widget buildStamp(BuildContext context, Function setState, User e) {
  LikeStatus? status = getStatus(e);
  double opacity = getOpacity(e);

  if (status != null) {
    switch (status) {
      case LikeStatus.like:
        {
          return Positioned(
              top: 64,
              left: 50,
              child: buildOneStamp("Maybe", Colors.green,
                  angle: -0.5, opacity: opacity));
        }
      case LikeStatus.dislike:
        {
          return Positioned(
              top: 64,
              right: 50,
              child: buildOneStamp("NO", Colors.red,
                  angle: 0.5, opacity: opacity));
        }
      case LikeStatus.superlike:
        {
          return Positioned(
              top: 150,
              right: 10,
              left: 10,
              child: buildOneStamp(
                  angle: 0.45, "SUPER\nLIKE", Colors.blue, opacity: opacity));
        }

      default:
        {}
        break;
    }
    ;

    return Text("");
  } else
    return Text("");
}

double getOpacity(User e) {
  double delta = 100;
  double pos = max(e.position.dx.abs(), e.position.dy.abs());
  return min(pos / delta, 1);
}

LikeStatus? getStatus(User e, {bool force = false}) {
  int trashHold = 20;
  if (force) {
    trashHold = 100;
  }
  if (e.position.dx > trashHold) {
    return LikeStatus.like;
  } else if (e.position.dx < -trashHold) {
    return LikeStatus.dislike;
  } else if (e.position.dy < -trashHold) {
    return LikeStatus.superlike;
  }
  return null;
}

Widget buildCard(User e) {
  return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 3, color: Colors.black),
          borderRadius: BorderRadius.circular(18),
          color: Colors.white),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  e.front != null
                      ? CircleAvatar(radius: 30, child: e.front)
                      : CircleAvatar(
                          radius: 60, child: Icon(Icons.person, size: 120)),
                  Text("${e.name}",
                      softWrap: true, style: TextStyle(fontSize: 28)),
                ],
              ),
              Container(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Description",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("${e.description}"),
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Contacts",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("${e.email} , tel:${e.phone}")
              ]),
              e.places.isNotEmpty
                  ? Text(
                      "Places: ${e.places.reduce((value, element) => value = value + "," + element)}")
                  : SizedBox.shrink(),
              e.experience.isNotEmpty
                  ? e is Person
                      ? Text(
                          "My experience: ${e.experience.reduce((value, element) => value = value + "\n" + element)}")
                      : Text(
                          "Requested experience: ${e.experience.reduce((value, element) => value = value + "\n" + element)}")
                  : SizedBox.shrink(),
              e is Person && (e as Person).education.isNotEmpty
                  ? Text(
                      "My education: ${(e as Person).education.reduce((value, element) => value = value + "\n" + element)}")
                  : e is Job && (e as Job).domains.isNotEmpty
                      ? Text(
                          "Positions: ${(e as Job).domains.reduce((value, element) => value = value + "\n" + element)}")
                      : SizedBox.shrink(),
              e is Person && (e as Person).skills.isNotEmpty
                  ? Text(
                      "My skills: ${(e as Person).skills.reduce((value, element) => value = value + "\n" + element)}")
                  : const SizedBox.shrink(),
            ]),
      ));
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(String email, String name) {
    if (users.indexWhere((element) => element.email == email) >= 0) {
      currentUser = users.elementAtOrNull(
          users.indexWhere((element) => element.email == email));
    } else {
      User user = User.named(name);
      user.email = email;
      currentUser = user;
      users.add(user);
    }
    for (var user in users) {
      users[users.indexOf(user)].position = Offset(0, 0);
    }
  }

  int miliseconds = 0;
  double angle = 0;
  var Rotation = Matrix4.identity();
  ButtonsStatus pushStatus = ButtonsStatus.none;

  ButtonStyle styleFromColor(Color color, {bool activated = false}) {
    return ElevatedButton.styleFrom(
        backgroundColor: activated ? color : null,
        shape: CircleBorder(side: BorderSide(width: 3, color: color)));
  }

  Widget buildButtonBar(Function applyStatus, double width,
      {ButtonsStatus pushstatus = ButtonsStatus.none}) {
    var recoverButtonState = () {
      Future.delayed(Duration(milliseconds: 500), () {
        print("redo button color");
        setState(() {
          pushStatus = ButtonsStatus.none;
        });
      });
    };

    return Positioned(
        bottom: 0,
        left: 0,
        child: Container(
            color: Colors.black12.withOpacity(0.5),
            height: 60,
            width: width,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: styleFromColor(Colors.yellow),
                      onPressed: () {
                        if (lastUserEvaluated != null)
                          users.add(lastUserEvaluated!);
                        setState(() {
                          pushStatus = ButtonsStatus.redoPushed;
                          ;
                        });
                        recoverButtonState();
                      },
                      child:
                          Icon(Icons.cached, color: Colors.yellow, size: 30)),
                  ElevatedButton(
                      style: styleFromColor(Colors.red,
                          activated:
                              getStatus(users.last) == LikeStatus.dislike ||
                                  pushstatus == ButtonsStatus.dislikePushed),
                      onPressed: () {
                        setState(() {
                          pushStatus = ButtonsStatus.dislikePushed;
                        });

                        print("dislike before ${DateTime.now()}");
                        applyStatus(LikeStatus.dislike, users.last);
                        print("dislike after ${DateTime.now()}");
                        recoverButtonState();
                      },
                      child: Icon(Icons.close,
                          color: getStatus(users.last) == LikeStatus.dislike ||
                                  pushstatus == ButtonsStatus.dislikePushed
                              ? Colors.white
                              : Colors.red,
                          size: 30)),
                  ElevatedButton(
                      style: styleFromColor(Colors.green,
                          activated: getStatus(users.last) == LikeStatus.like ||
                              pushstatus == ButtonsStatus.likePushed),
                      onPressed: () {
                        setState(() {
                          pushStatus = ButtonsStatus.likePushed;
                        });
                        applyStatus(LikeStatus.like, users.last);
                        recoverButtonState();
                      },
                      child: Icon(Icons.favorite,
                          color: getStatus(users.last) == LikeStatus.like ||
                                  pushstatus == ButtonsStatus.likePushed
                              ? Colors.white
                              : Colors.green,
                          size: 30)),
                  ElevatedButton(
                      style: styleFromColor(Colors.blue,
                          activated:
                              getStatus(users.last) == LikeStatus.superlike ||
                                  pushstatus == ButtonsStatus.superlikePushed),
                      onPressed: () {
                        applyStatus(LikeStatus.superlike, users.last);
                        setState(() {
                          pushStatus = ButtonsStatus.superlikePushed;
                        });
                        recoverButtonState();
                      },
                      child: Icon(Icons.star,
                          color: getStatus(users.last) ==
                                      LikeStatus.superlike ||
                                  pushstatus == ButtonsStatus.superlikePushed
                              ? Colors.white
                              : Colors.blue,
                          size: 20)),
                  ElevatedButton(
                      style: styleFromColor(Colors.purple),
                      onPressed: () {
                        setState(() {
                          pushStatus = ButtonsStatus.lightPushed;
                        });
                        recoverButtonState();
                        print("up the stakes");
                      },
                      child:
                          Icon(Icons.flash_on, color: Colors.purple, size: 20)),
                ])));
  }

  void applyStatus(LikeStatus? status, User e) async {
    var comonsideEfeect = () {
      Future.delayed(Duration(milliseconds: 200), () {
        print("in delayed");
        print(users.last.name);
        setState(() {
          users.removeLast();
          print(users.last.name);
          users[users.indexOf(users.last)].position = const Offset(0, 0);
          users[users.indexOf(users.last)].duration = 0;
          Rotation = Matrix4.identity();
        });

        // setState(() {});
      });
    };

    print(" Apply status for: ${e.name}");
    setState(() {
      lastUserEvaluated = users[users.indexOf(e)];

      lastUserEvaluated?.position = Offset.zero;
      users[users.indexOf(e)].duration = 800;
      e.duration = 800;
      Rotation = Matrix4.identity();
    });

    switch (status) {
      case LikeStatus.like:
        {
          users[users.indexOf(e)].position =
              Offset(2 * MediaQuery.of(context).size.width, 0);
          likedUsers.add(e);

          e.position = Offset(2 * MediaQuery.of(context).size.width, 0);
          comonsideEfeect();

          setState(() {});
        }
        break;
      case LikeStatus.dislike:
        {
          users[users.indexOf(e)].position =
              Offset(-2 * MediaQuery.of(context).size.width, 0);

          e.position = Offset(-2 * MediaQuery.of(context).size.width, 0);

          setState(() {});
          comonsideEfeect();

          dislikedUsers.add(e);
        }
        break;
      case LikeStatus.superlike:
        {
          users[users.indexOf(e)].position =
              Offset(0, -2 * MediaQuery.of(context).size.height);
          e.position = Offset(0, -2 * MediaQuery.of(context).size.height);

          setState(() {});

          comonsideEfeect();

          likedUsers.add(e);
          setState(() {});
        }
        break;
      default:
        {
          users[users.indexOf(e)].position = Offset(0, 0);
          e.position = Offset(0, 0);

          Rotation = Matrix4.identity();
        }
        break;
    }
  }

  Future<void> captureAllImages(BuildContext? context) async {
    ScreenshotController screenC = ScreenshotController();
    for (User e in likedUsers) {
      Uint8List listU = await screenC.captureFromWidget(
          context: context,
          Container(
              width: MediaQuery.of(context!).size.width,
              height: 3.5 / 4 * MediaQuery.of(context).size.height,
              child: buildCard(e)));

      likedUsers[likedUsers.indexOf(e)].CvFront = Image.memory(
        scale: 0.3,
        listU,
        semanticLabel: e.name,
      );
    }
    ;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //WidgetsBinding.instance.waitUntilFirstFrameRasterized
  }

  @override
  Widget build(BuildContext context) {
    print("build");

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHom milisecondsePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),

      body: BackgroudWrapper(
          time: IntegerWrapper(),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(children: [
                Stack(
                    children: users.map((e) {
                  print("${e.name}, ${e.position.toString()}");
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 3.5 / 4 * MediaQuery.of(context).size.height,
                      child: users.last == e
                          ? GestureDetector(
                              onPanEnd: (det) {
                                LikeStatus? status = getStatus(e);

                                applyStatus(status, e);
                              },
                              onPanUpdate: (details) {
                                print("update by pan");
                                setState(() {
                                  users[users.indexOf(e)].position +=
                                      details.delta;
                                  e.position += details.delta;
                                  e.duration = 0;

                                  angle = 45 *
                                      e.position.dx /
                                      MediaQuery.of(context).size.width *
                                      pi /
                                      180;
                                  Rotation = Matrix4.identity()
                                    ..translate(
                                        MediaQuery.of(context).size.width / 2,
                                        MediaQuery.of(context).size.height / 2)
                                    ..rotateZ(angle)
                                    ..translate(
                                        -MediaQuery.of(context).size.width / 2,
                                        -MediaQuery.of(context).size.height /
                                            2);
                                });
                              },
                              child: AnimatedContainer(
                                  duration: Duration(milliseconds: e.duration),
                                  curve: Curves.easeInOut,
                                  transform: Rotation
                                    ..translate(e.position.dx, e.position.dy),
                                  child: Stack(children: [
                                    buildCard(e),
                                    buildStamp(context, setState, e),
                                  ])))
                          : buildCard(e));
                }).toList()),
                users.length > 0
                    ? buildButtonBar(
                        applyStatus, MediaQuery.of(context).size.width,
                        pushstatus: pushStatus)
                    : SizedBox.shrink()
              ]))),

      // This trailing comma makes auto-formatting nicer for build methods.

      bottomNavigationBar: ColoredBox(
          color: Colors.white,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) {
                    return MyHomePage(
                        title: "T for Jobs",
                        email: currentUser!.email,
                        name: currentUser!.name);
                  }));
                },
                child: Icon(Icons.home_filled)),
            ElevatedButton(onPressed: () {}, child: Icon(Icons.explore)),
            ElevatedButton(
                onPressed: () async {
                  //  await captureAllImages(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChatList(title: "Job chats"))).then((_) {
                    setState(() {});
                  });
                },
                child: Icon(Icons.chat)),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountPage(title: "")));
                },
                child: Icon(Icons.account_circle)),
          ])),
    );
  }
}
