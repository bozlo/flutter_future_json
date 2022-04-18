import 'package:flutter/material.dart';
import 'info.dart';
import 'package:http/http.dart' as http;
//import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Info> info;
  String result =  'no data found';

  @override
  void initState() {
    super.initState();
    info = fetchInfo();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fetch Data Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('계좌정보 확인하기'),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[
                ElevatedButton(child: Text('Future test'), onPressed: () {
                  futureTest();
                }),
                SizedBox(height: 20,),
                Text(result,
                  style: TextStyle(
                    color: Colors.brown,
                  ),),
                Divider(height: 40, thickness: 2, color: Colors.redAccent,),
                FutureBuilder(
                    future: myFuture(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Text(
                          snapshot.data.toString(),
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.red,
                          ),
                        );
                      }
                      return CircularProgressIndicator();
                    },
                ),
              ],
            ),
        ),
      ),
    );
  }

  Future<void> futureTest() async {
    await Future.delayed(Duration(seconds: 3))
        .then((_) {
        setState(() {
          this.result = "The data is fetched";
        });
        print("end of future test");
    });
  }

  Future<String> myFuture() async {
    await Future.delayed(Duration(seconds: 3));
    return "anther Future completed";
  }
}


Future<Info> fetchInfo() async {
  final response =
      await http.get(Uri.parse('https://my.api.mockaroo.com/bank.json?key=fea24270'));

  if (response.statusCode == 200) {
    return Info.fromJson(json.decode(response.body));
  } else {
    throw Exception('계좌정보를 불러오는데 실패했습니다');
  }
}
