import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alipush/commons/index.dart';
import 'package:flutter_alipush/ui/home_page.dart';
import 'package:flutter_alipush/ui/setting_page.dart';
import 'package:rammus/rammus.dart' as rammus; //导包

void main() {
  //沉浸式
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter alipush Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  String _deviceId = 'Unknown';

  @override
  void initState() {
    super.initState();
    //获取device id
    initPlatformState();

    //推送通知的处理 (注意，这里的id:针对Android8.0以上的设备来设置通知通道,客户端的id跟阿里云的通知通道要一致，否则收不到通知)
    rammus.setupNotificationManager(id: "alipush notification",name: "rammus",description: "rammus test",);
    rammus.onNotification.listen((data){
      print("----------->notification here ${data.summary}");
    });
    rammus.onNotificationOpened.listen((data){//这里是点击通知栏回调的方法
      print("-----------> ${data.summary} 被点了");
      //点击通知后跳转的页面
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (ctx) => new SettingPage()));
    });

    rammus.onNotificationRemoved.listen((data){
      print("-----------> $data 被删除了");
    });

    rammus.onNotificationReceivedInApp.listen((data){
      print("-----------> ${data.summary} In app");
    });

    rammus.onNotificationClickedWithNoAction.listen((data){
      print("${data.summary} no action");
    });

    rammus.onMessageArrived.listen((data){
      print("received data -> ${data.content}");
    });
  }

  //获取device id的方法
  Future<void> initPlatformState() async {
    String deviceId;
    try {
      deviceId = await rammus.deviceId;
    } on PlatformException {
      deviceId = 'Failed to get device id.';
    }
    if (!mounted) return;
    setState(() {
      _deviceId = deviceId;
      //接下来你要做的事情
      //1.将device id通过接口post给后台，然后进行指定设备的推送
      //2.推送的时候，在Android8.0以上的设备都要设置通知通道
    });
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = List.generate(pages.length, (i) {
      final nav = pages[i];
      return BottomNavigationBarItem(
          icon: i == index ? nav['icon2'] : nav['icon'],
          title: i == index ? nav['title2'] : nav['title']);
    }).toList();
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildTabContent(),
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: index,
        onTap: _change,
        type: BottomNavigationBarType.fixed,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _change(int i) {
    setState(() {
      index = i;
    });
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: new Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
        child: new Text(tabTitle[index]),
      ),
    );
  }


  Widget _buildTabContent() {
    return index == 0 ? HomePage() : SettingPage();
  }

}
