import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../size_config.dart';

class EditTask extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  const EditTask({
    Key? key,
    required this.documentSnapshot,
  }) : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

final CollectionReference _task = FirebaseFirestore.instance.collection('task');

class _EditTaskState extends State<EditTask> {

  @override
  Widget build(BuildContext context) {
    DateTime? _date =DateTime.tryParse(widget.documentSnapshot['date']);
    late TimeOfDay? time1=DateTime.tryParse(widget.documentSnapshot['start_time']) as TimeOfDay;
    late TimeOfDay? time2 =DateTime.tryParse(widget.documentSnapshot['end_time']) as TimeOfDay;

    String titleText = widget.documentSnapshot['title'].toString();
    String dateText = widget.documentSnapshot['date'].toString();
    String descriptionText = widget.documentSnapshot['description'].toString();
    String startText = widget.documentSnapshot['start_time'].toString();
    String endText = widget.documentSnapshot['end_time'].toString();
    final TextEditingController _title = TextEditingController(text: titleText );
    final TextEditingController _description = TextEditingController(text: descriptionText);
    void clearKeyboard (){
      FocusScope.of(context).requestFocus(FocusNode());
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: GestureDetector(
          onTap: clearKeyboard,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(13),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text('Edit Task',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  InputField(title: "Title", textEditingController: _title),
                  const SizedBox(
                    height: 15,
                  ),
                  InputField(
                      title: "Description",
                      textEditingController: _description),
                  const SizedBox(
                    height: 15,
                  ),
                  InputField(
                    title: "Date",
                    hintText: dateText,
                    widget: IconButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(dateText),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2024),
                        ).then((date) {
                          setState(() {
                            dateText = date!.toString();
                          });
                        });
                      },
                      icon: const Icon(Icons.calendar_today_rounded),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InputField(
                              title: "Start Time",
                              hintText: startText,
                              widget: IconButton(
                                onPressed: () async {
                                  TimeOfDay? timePicker = await showTimePicker(
                                    initialTime: DateTime.parse(startText) as TimeOfDay,
                                    context: context,
                                  );
                                  if (timePicker != null) {
                                    setState(() {
                                      startText = timePicker.toString();
                                    });
                                  } else {
                                    return;
                                  }
                                },
                                icon: const Icon(Icons.timer_outlined),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InputField(
                              title: "End Time",
                              hintText: endText,
                              widget: IconButton(
                                onPressed: () async {
                                  TimeOfDay? timePicker = await showTimePicker(
                                    initialTime: DateTime.parse(endText) as TimeOfDay,
                                    context: context,
                                  );
                                  // ignore: unnecessary_null_comparison
                                  if (timePicker != null) {
                                    setState(() {
                                      endText = timePicker.toString();
                                    });
                                  } else {
                                    return;
                                  }
                                },
                                icon: const Icon(Icons.timer_outlined),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final String title = _title.text;
                          final String date = dateText;
                          final String description = _description.text;
                          final String start_Text =startText;
                          final String end_Text = endText;
                          _task.doc(widget.documentSnapshot.id).update({
                            "title":title,
                            "date":date,
                            "description":description,
                            "start_time":start_Text,
                            "end_time":end_Text,
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text('Update Task'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget InputField(
        {required String title,
        Widget? widget,
        TextEditingController? textEditingController,
        String? hintText}) =>
    Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
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
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  readOnly: widget != null ? true : false,
                  controller: textEditingController,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                  ),
                )),
                widget ?? Container(),
              ],
            ),
          ),
        ],
      ),
    );
