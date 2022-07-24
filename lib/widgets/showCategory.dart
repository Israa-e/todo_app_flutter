import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../screens/editTask.dart';
import '../size_config.dart';

class ShowCategory extends StatefulWidget {
  const ShowCategory({Key? key}) : super(key: key);

  @override
  State<ShowCategory> createState() => _ShowCategoryState();
}

class _ShowCategoryState extends State<ShowCategory> {
  late String categoryKey="";

  final CollectionReference _category =
      FirebaseFirestore.instance.collection('category');
  final CollectionReference _task =
      FirebaseFirestore.instance.collection('task');
  late double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(
              SizeConfig.orientation == Orientation.landscape ? 16 : 4)),
      height: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenHeight / 4
          : SizeConfig.screenHeight / 10,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                card(text: "All"),
                buildStreamBuilderCategory(),
              ],
            ),
          ),
          Expanded(
            child: buildStreamBuilders(),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> taskCategory(BuildContext context) async* {
    yield* FirebaseFirestore.instance
        .collection('userData')
        .where("category_id", isEqualTo: categoryKey)
        .snapshots();
  }

  StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilderCategory() {
    return StreamBuilder(
      stream: _category.snapshots(), //build connection
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        var x = streamSnapshot.hasData;
        print("israa  category  $x");
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
              print(
                  "${documentSnapshot.id} category ${documentSnapshot["name"].toString()}");
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      categoryKey = documentSnapshot.id.toString()==""?documentSnapshot.id.toString():"";
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
        // } else {
        //   return Center(
        //     child: ImageImpty(),
        //   );
        // }
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

  Widget buildStreamBuilders() {
    if (categoryKey == "") {
      return Container(
        color: Colors.greenAccent,
      );
    } else {
      return StreamBuilder(
          stream: taskCategory(context), //build connection
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (!streamSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                    return GestureDetector(
                        onDoubleTap: () {},
                        onTap: () {
                          String isTrue =
                              documentSnapshot['isCompleted'].toString();
                          // showModalBottomSheet(
                          //   shape: const RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.vertical(
                          //         top: Radius.circular(20)),
                          //   ),
                          //   context: context,
                          //   builder: (context) => Container(
                          //     padding: const EdgeInsets.only(
                          //         left: 10, right: 10, top: 10),
                          //     child: Column(
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: [
                          //         isTrue == "0"
                          //             ? bottomSheetButtons(() {
                          //                 _task
                          //                     .doc(documentSnapshot.id)
                          //                     .update({
                          //                   "isCompleted": 1,
                          //                 });
                          //                 Navigator.pop(context);
                          //               }, "Completed The Task")
                          //             : Container(),
                          //         bottomSheetButtons(() {
                          //           Navigator.pop(context);
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) => EditTask(
                          //                         documentSnapshot:
                          //                             documentSnapshot,
                          //                       )));
                          //         }, "Edit Task"),
                          //         bottomSheetButtons(() {
                          //           // _delete(documentSnapshot.id);
                          //           Navigator.pop(context);
                          //         }, "Delete Task"),
                          //         bottomSheetButtons(() {
                          //           Navigator.pop(context);
                          //         }, "Cancel"),
                          //       ],
                          //     ),
                          //   ),
                          // );
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
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          });
    }
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

}
