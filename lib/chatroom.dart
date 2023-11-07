import 'package:flutter/material.dart';
import 'package:tinder_jobs/login.dart';
import 'main.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.from, required this.to});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String to;
  final String from;

  @override
  State<ChatPage> createState() => _ChatPageState(to, from);
}

class _ChatPageState extends State<ChatPage> {
  _ChatPageState(this.to, this.from) {
    myChat = Message.findByFrom(Message.findByTo(messagePool, to), from);
    myChat.addAll(Message.findByFrom(Message.findByTo(messagePool, from), to));
    myChat.sort((m1, m2) {
      if (m1.timeStamp.isAfter(m2.timeStamp)) return 1;
      return -1;
    });
  }

  String to = "";
  String from = "";
  String content = "";
  String urlToSend = "";
  String urlToRead = "";
  List<Message> myChat = <Message>[];

  TextSpan emojiTextSpans(String s) {
    var children = <InlineSpan>[];

    List<int> chunk = <int>[];
    int state = 0;

    for (var rune in s.runes) {
      if (state == 0) {
        if (rune < 255) {
          state = 1;
          chunk.add(rune);
        } else {
          state = 2;
          chunk.add(rune);
        }
      } else if (state == 1) {
        if (rune < 255) {
          chunk.add(rune);
        } else {
          String text = String.fromCharCodes(chunk);
          TextSpan span =
              TextSpan(text: text, style: TextStyle(fontFamily: null));
          children.add(span);
          chunk.clear();
          chunk.add(rune);
          state = 2;
        }
      } else {
        if (rune > 255) {
          chunk.add(rune);
        } else {
          String text = String.fromCharCodes(chunk);
          TextSpan span =
              TextSpan(text: text, style: TextStyle(fontFamily: "EmojiOne"));
          children.add(span);
          chunk.clear();
          chunk.add(rune);
          state = 1;
        }
      }
    }
    if (state == 2) {
      String text = String.fromCharCodes(chunk);
      TextSpan span =
          TextSpan(text: text, style: TextStyle(fontFamily: "EmojiOne"));
      children.add(span);
      chunk.clear();
    } else if (state == 1) {
      String text = String.fromCharCodes(chunk);
      TextSpan span = TextSpan(text: text, style: TextStyle(fontFamily: null));
      children.add(span);
      chunk.clear();
    }

    return TextSpan(children: children);
  }

  TextEditingController _controller = TextEditingController();

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

          title: Text(to),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHom milisecondsePage object that was created by
          // the App.build method, and use it to set our appbar title.
        ),
        body: BackgroudWrapper(
            time: IntegerWrapper(),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(children: [
              Container(
                  height: 3.5 / 4 * MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                        children: myChat.map((e) {
                      return e.to == to
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 0, 135, 202),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Wrap(children: [
                                          Padding(
                                              padding: EdgeInsets.all(20),
                                              child: RichText(
                                                  text: emojiTextSpans(
                                                      e.content)))
                                        ]))
                                  ]))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.greenAccent,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                          padding: EdgeInsets.all(20),
                                          child: RichText(
                                              text:
                                                  emojiTextSpans(e.content)))),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          myChat[myChat.indexOf(e)].liked =
                                              !myChat[myChat.indexOf(e)].liked;
                                          messagePool[messagePool.indexOf(e)]
                                              .liked = !messagePool[
                                                  messagePool.indexOf(e)]
                                              .liked;
                                          e.liked = !e.liked;
                                        });
                                      },
                                      color: e.liked ? Colors.red : Colors.grey,
                                      icon: e.liked
                                          ? Icon(Icons.favorite)
                                          : Icon(Icons.favorite_outline))
                                ]);
                    }).toList()),
                  )),
              Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                      color: Colors.indigo,
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                          controller: _controller,
                          onChanged: (value) {
                            setState(() {
                              content = value;
                            });
                          },
                          onEditingComplete: () {
                            _controller.clear();
                            setState(() {
                              Message newMessage =
                                  Message.withContent(to, from, content);
                              messagePool.add(newMessage);
                              myChat.add(newMessage);

                              newMessage =
                                  Message.withContent(from, to, content);
                              messagePool.add(newMessage);
                              myChat.add(newMessage);
                            });
                          }))),
            ])));
  }
}
