
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_flutter/screens/addCategory.dart';
import 'package:todo_app_flutter/size_config.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController _title = TextEditingController();
  DateTime _date = DateTime.now();
  final TextEditingController _description = TextEditingController();
  TimeOfDay time1 =
      TimeOfDay(hour: DateTime.now().hour, minute: TimeOfDay.now().minute);
  TimeOfDay time2 = TimeOfDay(
      hour: DateTime.now().hour,
      minute: DateTime.now().add(const Duration(minutes: 10)).minute);
  var selectedCurrency;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late DocumentSnapshot doc;
  void clearKeyboard (){
    FocusScope.of(context).requestFocus(FocusNode());
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            DropdownButton(
                items: [
                  DropdownMenuItem(
                    value: 'add category',
                    child: Row(
                      children: const [
                        Icon(Icons.add),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Add Category'),
                      ],
                    ),
                  )
                ],
                elevation: 0,
                underline: Container(),
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).primaryIconTheme.color,
                ),
                onChanged: (itemIdntefier) {

                  if (itemIdntefier == 'add category') {
                    print("add category");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const AddCategory()));
                  }
                })
          ],
        ),
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
                    child: Text('Add Task',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  InputField(
                      title: "Title",
                      hintText: "Enter title her...",
                      textEditingController: _title),
                  const SizedBox(
                    height: 15,
                  ),
                  InputField(
                      title: "Description",
                      hintText: "Enter description",
                      textEditingController: _description),
                  const SizedBox(
                    height: 15,
                  ),
                  InputField(
                    title: "Date",
                    hintText: DateFormat.yMd().format(_date).toString(),
                    widget: IconButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2024),
                        ).then((date) {
                          setState(() {
                            _date = date!;
                          });
                        });
                      },
                      icon: const Icon(Icons.calendar_today_rounded),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('category')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          List<DropdownMenuItem> currencyItem = [];
                          for (int i = 0;
                          i < streamSnapshot.data!.docs.length;
                          i++) {
                           doc =
                            streamSnapshot.data!.docs[i];
                            currencyItem.add(
                              DropdownMenuItem(
                                value: doc.id,
                                child: Text(doc['name']),
                              ),
                            );
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.category,
                                size: 25.0,
                                color: Colors.pinkAccent,
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              DropdownButton<dynamic>(
                                items: currencyItem,
                                onChanged: (currencyValue) {
                                  setState((){
                                    selectedCurrency=currencyValue;
                                  });

                                 print(selectedCurrency) ;
                                },
                                value: selectedCurrency,
                                isExpanded: false,
                                hint: const Text(
                                  "Choose Currency Type",
                                  style: TextStyle(color: Colors.pink),
                                ),
                              )
                            ],
                          );
                        } else {
                          return Container();
                        }
                      }),
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
                              hintText:
                                  "${time1.hour.toString()} : ${time1.minute.toString()} ${time1.period.toString().split('.')[1]}",
                              widget: IconButton(
                                onPressed: () async {
                                  TimeOfDay? timePicker = await showTimePicker(
                                    initialTime: time1,
                                    context: context,
                                  );
                                  // ignore: unnecessary_null_comparison
                                  if (timePicker != null) {
                                    setState(() {
                                      time1 = timePicker;
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
                              hintText:
                                  "${time2.hour.toString()} : ${time2.minute.toString()} ${time2.period.toString().split('.')[1]}",
                              widget: IconButton(
                                onPressed: () async {
                                  TimeOfDay? timePicker = await showTimePicker(
                                    initialTime: time2,
                                    context: context,
                                  );
                                  // ignore: unnecessary_null_comparison
                                  if (timePicker != null) {
                                    setState(() {
                                      time2 = timePicker;
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
                        width: 18,
                        height: 23,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton (
                        onPressed: AddToFirebase,
                        child: const Text('Create Task'),
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

  // ignore: non_constant_identifier_names
  void AddToFirebase() async {
    print('pressed ');
    if (_title.text.isEmpty && _description.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All field should not be empty'),
          duration: Duration(seconds: 2),
        ),
      );
      print('false');
    } else {
      var titleText = _title.text;
      var descriptionText = _description.text;
      var dateText = _date.toString();
      var startText =
          "${time1.hour.toString()} : ${time1.minute.toString()} ${time1.period.toString().split('.')[1]}";
      var endText =
          "${time2.hour.toString()} : ${time2.minute.toString()} ${time2.period.toString().split('.')[1]}";
      var category_id = selectedCurrency;
      var v = await firebaseFirestore.collection("task").add({
        "title": titleText,
        "description": descriptionText,
        "date": dateText,
        "start_time": startText,
        "end_time": endText,
        "timestamp": Timestamp.now(),
        // "searchKey":{titleText[0].toUpperCase(),descriptionText[0].toUpperCase()},
        "isCompleted": 0,
        "category_id":category_id,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add Successfully'),
          duration: Duration(seconds: 2),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      print(v);
    }
  }

  // ignore: non_constant_identifier_names
  Widget InputField(
          {required String title,
          Widget? widget,
          TextEditingController? textEditingController,
          required String hintText}) =>
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
}
