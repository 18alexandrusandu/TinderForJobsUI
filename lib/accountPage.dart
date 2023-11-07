import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'main.dart';
import 'chatslist.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<AccountPage> createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  String email = "";
  String phone = "";
  String description = "";

  TextEditingController emailController =
      TextEditingController(text: currentUser!.email);
  TextEditingController phoneController =
      TextEditingController(text: currentUser!.phone);
  TextEditingController descriptionController =
      TextEditingController(text: currentUser!.description);
  List<TextEditingController> otherControllers = <TextEditingController>[
    TextEditingController(text: currentUser!.experience.toString()),
    TextEditingController(text: currentUser!.maximalSalary.toString()),
    TextEditingController(text: currentUser!.minimalSalary.toString()),
    TextEditingController(text: currentUser!.position.toString()),
    TextEditingController(text: currentUser!.places.toString())
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHom milisecondsePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(children: [
        CircleAvatar(
          radius: 80,
          child: currentUser!.front,
        ),
        Text(currentUser!.name),
        Text("Email"),
        TextField(
          controller: emailController,
          onChanged: (value) {
            email = value;
          },
          onEditingComplete: () {
            currentUser!.email = email;
          },
        ),
        Text("Phone"),
        TextField(
          controller: phoneController,
          onChanged: (value) {
            phone = value;
          },
          onEditingComplete: () {
            currentUser!.phone = phone;
          },
        ),
        Text("Description"),
        TextField(
          controller: descriptionController,
          onChanged: (value) {
            description = value;
          },
          onEditingComplete: () {
            currentUser!.description = description;
          },
        ),
        Column(
            children: otherControllers.map((controller) {
          return Column(
            children: [TextField(controller: controller)],
          );
        }).toList())
      ]),
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
                          builder: (context) => ChatList(title: "Job chats")));
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

  // This trailing comma makes auto-formatting nicer for build methods.
}
