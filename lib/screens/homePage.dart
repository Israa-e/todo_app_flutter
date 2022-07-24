import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_flutter/screens/addTask.dart';
import 'package:todo_app_flutter/screens/editTask.dart';
import 'package:todo_app_flutter/size_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String categoryKey = "";
  final CollectionReference _category =
      FirebaseFirestore.instance.collection('category');
  DateTime dateTime = DateTime.now();

  CollectionReference _task = FirebaseFirestore.instance.collection('task');

  Future<void> _delete(String taskId) async {
    await _task.doc(taskId).delete();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully deleted a task')));
  }
  Stream<QuerySnapshot> taskCategory(BuildContext context) async*{
     FirebaseFirestore.instance
        .collection('userData')
        .where("category_id", isEqualTo: categoryKey)
        .snapshots();
  }
  var task;

  @override
  Widget build(BuildContext context) {
    task = FirebaseFirestore.instance
        .collection('task')
        .where('category_id', isEqualTo: categoryKey)
        .get();
    SizeConfig().init(context);
    if (kDebugMode) {
      print("israa dm $_task");
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(
                      SizeConfig.orientation == Orientation.landscape
                          ? 16
                          : 4)),
              height: SizeConfig.orientation == Orientation.landscape
                  ? SizeConfig.screenHeight / 4
                  : SizeConfig.screenHeight / 10,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                   GestureDetector(child:  card(text: "All"),onTap: (){
                     setState((){
                       categoryKey="";
                       print(categoryKey);
                     });
                   },),
                    buildStreamBuilderCategory(),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildStreamBuilder(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTask()),
          );
        },
        label: const Text('Create Task'),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilder() {
    if (categoryKey == "") {
      return StreamBuilder(
        stream: _task.snapshots(), //build connection
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          var x = streamSnapshot.hasData;
          if (kDebugMode) {
            print("israa  jg  $x");
          }
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              //number of rows
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return GestureDetector(
                    onDoubleTap: () {},
                    onTap: () {
                      String isTrue =
                          documentSnapshot['isCompleted'].toString();
                      showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        context: context,
                        builder: (context) => Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              isTrue == "0"
                                  ? bottomSheetButtons(() {
                                      _task.doc(documentSnapshot.id).update({
                                        "isCompleted": 1,
                                      });
                                      Navigator.pop(context);
                                    }, "Completed The Task")
                                  : Container(),
                              bottomSheetButtons(() {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditTask(
                                              documentSnapshot:
                                                  documentSnapshot,
                                            )));
                              }, "Edit Task"),
                              bottomSheetButtons(() {
                                _delete(documentSnapshot.id);
                                Navigator.pop(context);
                              }, "Delete Task"),
                              bottomSheetButtons(() {
                                Navigator.pop(context);
                              }, "Cancel"),
                            ],
                          ),
                        ),
                      );
                    },
                    child: taskCard(
                        title: documentSnapshot['title'].toString(),
                        date: documentSnapshot['date'].toString(),
                        description: documentSnapshot['description'].toString(),
                        isCompleted: documentSnapshot['isCompleted'].toString(),
                        start: documentSnapshot['start_time'].toString(),
                        end: documentSnapshot['end_time'].toString()));
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    } else {
      return StreamBuilder(
        stream:   FirebaseFirestore.instance
            .collection('task')
            .where("category_id", isEqualTo: categoryKey)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final DocumentSnapshot documentSnapshot =
                  snapshot.data!.docs[index];
                  return GestureDetector(
                      onDoubleTap: () {},
                      onTap: () {
                        String isTrue =
                        documentSnapshot['isCompleted'].toString();
                        showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20)),
                          ),
                          context: context,
                          builder: (context) => Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                isTrue == "0"
                                    ? bottomSheetButtons(() {
                                        _task
                                            .doc(documentSnapshot.id)
                                            .update({
                                          "isCompleted": 1,
                                        });
                                        Navigator.pop(context);
                                      }, "Completed The Task")
                                    : Container(),
                                bottomSheetButtons(() {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditTask(
                                                documentSnapshot:
                                                    documentSnapshot,
                                              )));
                                }, "Edit Task"),
                                bottomSheetButtons(() {
                                  _delete(documentSnapshot.id);
                                  Navigator.pop(context);
                                }, "Delete Task"),
                                bottomSheetButtons(() {
                                  Navigator.pop(context);
                                }, "Cancel"),
                              ],
                            ),
                          ),
                        );
                      },
                      child: taskCard(
                          title: documentSnapshot['title'].toString(),
                          date: documentSnapshot['date'].toString(),
                          description:
                          documentSnapshot['description'].toString(),
                          isCompleted:
                          documentSnapshot['isCompleted'].toString(),
                          start: documentSnapshot['start_time'].toString(),
                          end: documentSnapshot['end_time'].toString()));
                },
              );
            } else {
              return  Center(
                child: Container(
                  color: Colors.red,
                ),
              );
            }
          }
        },
        );
    }
  }

  StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilderCategory() {
    return StreamBuilder(
      stream: _category.snapshots(), //build connection
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: streamSnapshot.data!.docs.length,
            //number of rows
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              // print("${documentSnapshot.id} category ${documentSnapshot["name"].toString()}");
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      categoryKey = documentSnapshot.id.toString();
                      print("categoryKey $categoryKey");
                    });
                  },
                  child: Row(
                    children: [card(text: documentSnapshot['name'].toString())],
                  ));
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  card({required String text}) {
    return Container(
      // padding: EdgeInsets.only(
      //     left: getProportionateScreenWidth(
      //         SizeConfig.orientation == Orientation.landscape ? 4 : 20  )),
      width: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenWidth / 4
          : SizeConfig.screenWidth / 2,
      height: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenHeight / 4
          : SizeConfig.screenHeight / 10,
      margin: EdgeInsets.only(
          bottom: getProportionateScreenHeight(12),
          left: getProportionateScreenHeight(20)),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.pink,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

bottomSheetButtons(function, text) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
    width: double.infinity,
    child: ElevatedButton(
      onPressed: function,
      child: Text(text),
    ),
  );
}

Widget taskCard({title, description, date, isCompleted, start, end}) {
  return Container(
    padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(
            SizeConfig.orientation == Orientation.landscape ? 4 : 20)),
    width: SizeConfig.orientation == Orientation.landscape
        ? SizeConfig.screenWidth / 2
        : SizeConfig.screenWidth,
    margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: Colors.pinkAccent),
      child: Row(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$title",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      "$start - $end",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "$description",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              isCompleted == "0" ? "TODO" : "COMPLETED",
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget x() {
  return DatePicker(
    DateTime.now(),
    height: 100,
    initialSelectedDate: DateTime.now(),
    width: 70,
    dateTextStyle: const TextStyle(
        fontWeight: FontWeight.w600, fontSize: 20, color: Colors.grey),
    dayTextStyle: const TextStyle(
        fontWeight: FontWeight.w600, fontSize: 16, color: Colors.grey),
    monthTextStyle: const TextStyle(
        fontWeight: FontWeight.w600, fontSize: 12, color: Colors.grey),
    selectedTextColor: Colors.white,
    selectionColor: Colors.pink,
    onDateChange: (newDate) {
      // setState(() {
      //   dateTime = newDate;
      // });
    },
  );
}
