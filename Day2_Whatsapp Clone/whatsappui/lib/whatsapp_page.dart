import 'package:flutter/material.dart';
import 'package:whatsappui/theme.dart';
import 'package:whatsappui/widgets/call_view.dart';
import 'package:whatsappui/widgets/chat_view.dart';
import 'package:whatsappui/widgets/status_view.dart';

class WhatsappPage extends StatefulWidget {
  const WhatsappPage({Key? key}) : super(key: key);

  @override
  State<WhatsappPage> createState() => _WhatsappPageState();
}

class _WhatsappPageState extends State<WhatsappPage> with
SingleTickerProviderStateMixin {
  var tabs = const [
    Tab(
      icon: Icon(Icons.camera_alt),
    ),
    Tab(
      text: "CHATS",
    ),
    Tab(
      text: "STATUS",
    ),
    Tab(
      text: "CALLS",
    )
  ];

  TabController? tabController;

  IconData fabIcon = Icons.message;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: tabs.length,
        vsync: this);
    tabController?.addListener(() {
      setState(() {
        switch (tabController?.index) {
          case 0:
            fabIcon = Icons.camera_alt;
            break;
          case 1:
            fabIcon = Icons.message;
            break;
          case 2:
            fabIcon = Icons.add;
            break;
          case 3:
            fabIcon = Icons.call;
            break;
        }
      });
    });
    tabController?.index = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WhatsApp"),
        backgroundColor: whatsAppGreen,
        bottom: TabBar(
          tabs: tabs,
          controller: tabController,
          indicatorColor: Colors.white,
        ),
        actions: const [
          Icon(Icons.search),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.more_vert),
          )
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          //CAMERA
          Container(
            child: const Center(
              child: Icon(Icons.camera_alt),
            ),
          ),
          //CHATS
          ChatView(),
          //STATUS
          StatusView(),
          //CALLS
          CallView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: whatsAppLightGreen,
        child: Icon(fabIcon),
      ),
    );
  }
}

