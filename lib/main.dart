import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo - Shesha Prasad',
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
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }


  void completeTask() {

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
        leading: Container(
          padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/profile.jpeg')
            )
        ),
        backgroundColor: Colors.indigo,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Container(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello!, Shesha Prasad", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),),
                SizedBox(height: 5,),
                Text("Sheshaprasad007@gmail.com", style: TextStyle(color: Colors.white, fontSize: 12, fontStyle: FontStyle.italic),),
              ],
            )
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFCDE53D),
              border: Border.all(color: Color(0xFF9EB031), width: 2.5)
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset('assets/champion.png', height: 50, width: 50,),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Go Pro (No Ads)", style: TextStyle(fontSize: 18, color: Color(0xFF071D55), fontWeight: FontWeight.w700, ),),
                            Text("No fuss, no ads, for only \$1 a month", style: TextStyle(fontSize: 12, color: Color(0xFF071D55), fontWeight: FontWeight.w400, ),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  padding: EdgeInsets.all(15),
                  color: Color(0xFF071D55),
                  child: Text("\$1", style: TextStyle(fontSize: 18, color: Color(0xFFF2C94C)),
                  ),
                ),
                SizedBox(width: 20,),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: centralRepo.length,
                  itemBuilder: (_, index){
                    return InkWell(
                      onTap: ()async{
                        log("Wh");
                        try {
                          final prefs = await SharedPreferences.getInstance();
                          List<String>? exisitingTasks = prefs.getStringList(
                              'tasks');
                          exisitingTasks![index] = jsonEncode({
                            "name": centralRepo[index]['name'],
                            "done": !centralRepo[index]['done']
                          });
                          await prefs.setStringList('tasks', exisitingTasks);
                          await loadData();
                        }catch(e){
                          log("$e");
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Icon(((centralRepo[index]['done'])??false) ? Icons.check_circle : Icons.check_circle_outline, color: Colors.green,),
                            SizedBox(width: 10,),
                            Expanded(
                                child: Container(
                                  child: Text(
                                    "${centralRepo[index]['name']}",
                                    style: TextStyle(
                                      color: ((centralRepo[index]['done'])??false) ? Color(0xFF8D8D8D)
                                          : Colors.black, fontSize: 16,
                                      decoration: ((centralRepo[index]['done'])??false)
                                          ? TextDecoration.lineThrough : null
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(width: 10,),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_)=> AddOrEditTaskPage(add: false, initialValue: centralRepo[index]['name'],)));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF071D55)),
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                padding: EdgeInsets.all(10),
                                child: Text('Edit', style: TextStyle(fontSize: 16, color: Color(0xFF071D55)),),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
              ),
            ),
          ),
          SizedBox(height: kBottomNavigationBarHeight,)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=> AddOrEditTaskPage()));
        },
        backgroundColor: Color(0xFF123EB1),
        tooltip: 'Add Task',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        child: const Icon(Icons.add, color: Colors.white,),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  loadData()async {

    final prefs = await SharedPreferences.getInstance();
    final List<String>? encodedOrders = prefs.getStringList('tasks');
    if (encodedOrders != null) {
      // Cast the decoded list to the desired type
      centralRepo = encodedOrders.map((order) => jsonDecode(order) as Map<String, dynamic>).toList();
    } else {
      centralRepo = []; // Initialize empty list if no orders exist
    }
    setState(() {});

  }
}


class AddOrEditTaskPage extends StatefulWidget {
  bool add;
  String? initialValue;
  AddOrEditTaskPage({this.add = true, this.initialValue});

  @override
  State<AddOrEditTaskPage> createState() => _AddOrEditTaskPageState();
}

class _AddOrEditTaskPageState extends State<AddOrEditTaskPage> {

  String value = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.indigo,
        title: Container(
            child: Text(widget.add ? "Add New Task" : "Edit Task", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Task Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
            SizedBox(height: 5,),
            TextFormField(
              initialValue: widget.initialValue,
              decoration: InputDecoration(
                hintText: "Ex: Take out Trash",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCBCBCB))
                )
              ),
              onChanged: (val){
                value = val;
              },
            ),
            Spacer(),
            SizedBox(height: 20,),
            Card(
              borderOnForeground: true,
              color: Color(0xFF0D2972),
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () async{

                  if(value.isNotEmpty) {
                    final prefs = await SharedPreferences.getInstance();
                    List<String>? exisitingTasks = prefs.getStringList('tasks');
                    if (exisitingTasks == null) {
                      exisitingTasks = [];
                    }

                    final taskData = {
                      "name": value,
                      "done": false
                    };
                    if(exisitingTasks.contains(
                        jsonEncode({
                          "name" : value,
                          "done" : false
                        })
                    ) || exisitingTasks.contains(
                        jsonEncode({
                          "name" : value,
                          "done" : true
                        })
                    )) {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.scale,
                        headerAnimationLoop: false,
                        title: 'Already Exists!',
                        desc: "$value already Exists",
                        btnOkOnPress: () {},
                        btnOkIcon: Icons.cancel,
                        btnOkColor: Colors.red,
                      ).show();
                    }else{
                      if(widget.add){
                        exisitingTasks.add(jsonEncode(taskData));
                      }else{
                        var res = exisitingTasks.indexWhere((element) => element == jsonEncode({
                          "name" : widget.initialValue,
                          "done" : false
                        }) || element == jsonEncode({
                          "name" : widget.initialValue,
                          "done" : true
                        }));
                        exisitingTasks[res] = jsonEncode(taskData);
                      }
                    }

                    await prefs.setStringList('tasks', exisitingTasks);

                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (builder) => Dashboard()), (
                            route) => false);
                  }else {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.scale,
                      headerAnimationLoop: false,
                      title: 'Error!',
                      desc: "Missing Task name!",
                      btnOkOnPress: () {},
                      btnOkIcon: Icons.cancel,
                      btnOkColor: Colors.red,
                    ).show();
                  }
                },
                child: Container(
                  width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(widget.add ? 'Add Task' : "Update Task", style: TextStyle(color: Colors.white),)
                ),
              )
            ),
            SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }
}


List<Map<String, dynamic>> centralRepo = [];
