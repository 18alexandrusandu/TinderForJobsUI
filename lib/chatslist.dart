import 'package:flutter/material.dart';
import 'package:tinder_jobs/accountPage.dart';
import 'main.dart';
import 'chatroom.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  int miliseconds = 0;
  double angle = 0;
  var Rotation = Matrix4.identity();

  String? getLastMessage(String userTo, String userFrom) {
    Message? msg = messagePool.lastWhere(
        (element) =>
            (element.to == userTo && element.from == userFrom) ||
            (element.to == userFrom && element.from == userTo),
        orElse: () => Message());

    if (msg.content != "") return msg.content;

    return null;
  }

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
      body: Column(
        children: [
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                  height: 220,
                  child: Row(
                      children: likedUsers.map<Widget>((user) {
                    return Padding(
                        padding: EdgeInsets.all(10),
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => ChatPage(
                                          from: currentUser!.name,
                                          to: user.name))).then((_) {
                                setState(() {});
                              });
                            },
                            icon: Column(children: [
                              Container(
                                  height: 160,
                                  width: 100,
                                  child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: buildCard(user))),
                              Text(user.name)
                            ])));
                  }).toList()))),
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: likedUsers.map<Widget>((user) {
                  return getLastMessage(user.name, currentUser!.name) != null
                      ? IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => ChatPage(
                                        from: currentUser!.name,
                                        to: user.name))).then((_) {
                              setState(() {});
                            });
                          },
                          icon: Row(children: [
                            CircleAvatar(child: user.front, radius: 20),
                            Column(children: [
                              Text(user.name),
                              Text(
                                  getLastMessage(user.name, currentUser!.name)!)
                            ])
                          ]))
                      : SizedBox.shrink();
                }).toList(),
              ))
        ],
      ),
      bottomNavigationBar: ColoredBox(
          color: Colors.white,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(onPressed: () {}, child: Icon(Icons.home_filled)),
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
