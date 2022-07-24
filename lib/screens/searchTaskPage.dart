
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';
import 'homePage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection('task');
  TextEditingController textEditingController = TextEditingController();

  void clearText() {
    textEditingController.clear();
    FocusScope.of(context).requestFocus(FocusNode());

  }
  void clearKeyboard (){
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: clearKeyboard,
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 14),
                margin: const EdgeInsets.only(top: 8),
                height: 52,
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 2,
                      color: Colors.pink.shade300,
                    )),
                child: TextFormField(
                  controller: textEditingController,
                 onChanged: (vale){
                    setState((){
                      if (kDebugMode) {
                        print(textEditingController.text);
                      }

                    });
                 },
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: clearText,
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              buildStreamBuilder(),

            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
        stream: _firebaseFirestore.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else
          {
            if (kDebugMode) {
              print("${textEditingController.text.toString()} search text");
            }
            if ((snapshot.data!.docs
                .where((QueryDocumentSnapshot<Object?> element) =>
                    element['title']
                        .toString()
                        .toLowerCase()
                        .contains(textEditingController.text.toString().toLowerCase())))
                .isEmpty) {
              return const Center(
                child: Text("No Search query found "),
              );
            } else {
              return Expanded(
                child: ListView(
                  children: [
                    ...snapshot.data!.docs
                        .where((QueryDocumentSnapshot<Object?> element) =>
                            element['title'].toString().toLowerCase().contains(
                                textEditingController.text.toString().toLowerCase()))
                        .map((QueryDocumentSnapshot<Object?> data) {
                      final String title = data.get('title');
                      final String description = data.get('description');
                      final String isCompleted =
                          data.get('isCompleted').toString();
                      final String startTime = data.get('start_time');
                      final String endTime = data.get('end_time');
                      if (kDebugMode) {
                        print(title);
                      }

                      return GestureDetector(
                        child: taskCard(
                            title: title,
                            description: description,
                            isCompleted: isCompleted,
                            start: startTime,
                            end: endTime),
                      );
                    }),
                  ],
                ),
              );
            }
          }
        });
  }
}
