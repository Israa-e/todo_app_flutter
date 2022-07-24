import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController textEditingController = TextEditingController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  void clearKeyboard (){
    FocusScope.of(context).requestFocus(FocusNode());
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: GestureDetector(
        onTap: clearKeyboard,
        child: Container(
          padding: const EdgeInsets.all(13),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Center(
              child: Text('Add Task',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
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
                      child: Row(children: [
                        Expanded(
                            child: TextFormField(
                          controller: textEditingController,
                          autofocus: false,
                          decoration: const InputDecoration(
                              hintText: "Enter Category Name",
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none),
                        )),
                      ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: AddToFirebase,
                      child: const Text('Create Category'),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    ));
  }

  void AddToFirebase() async {
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All field should not be empty'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      var titleText = textEditingController.text.toString();
      var v = await firebaseFirestore.collection("category").add({
        "name": titleText,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add Successfully'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }
}
