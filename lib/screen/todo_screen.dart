import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_sqflite_getx/DB/db_helper.dart';
import 'package:todo_app_sqflite_getx/main.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final bdHelper = DbHelper();
    bdHelper.init();
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController todoController = TextEditingController();
  TextEditingController titleControllerEdit = TextEditingController();
  TextEditingController todoControllerEdit = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: dbHelper.quaryAllRows(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> data = snapshot.data ?? [];
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 75,
                backgroundColor: Colors.cyan.withOpacity(.6),
                title: const Text("To-do List"),
              ),
              floatingActionButton: WidgetAnimator(
                  incomingEffect: WidgetTransitionEffects.incomingSlideInFromLeft(delay: const Duration(seconds: 1), opacity: .5),
                  atRestEffect: WidgetRestingEffects.size(),
                  child: FloatingActionButton(
                    isExtended: true,
                    focusColor: Colors.black,
                    focusElevation: 50,
                    backgroundColor: Colors.cyan.withOpacity(.6),
                    onPressed: () {
                      Get.dialog(
                          barrierDismissible: true,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.8),
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Material(
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          const Text(
                                            "Today's Todo",
                                            textAlign: TextAlign.center,
                                          ),
                                          Column(
                                            children: [
                                              TextFormField(
                                                controller: titleController,
                                                maxLines: 1,
                                                decoration: const InputDecoration(
                                                  labelText: "Todo",
                                                ),
                                              ),
                                              TextFormField(
                                                controller: todoController,
                                                maxLines: 1,
                                                decoration: const InputDecoration(
                                                  labelText: "Title",
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 25,
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(foregroundColor: const Color(0xFFFFFFFF), backgroundColor: Colors.cyan.withOpacity(.7), minimumSize: const Size(0, 45), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: const Text('Cancle'))),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(foregroundColor: const Color(0xFFFFFFFF), backgroundColor: Colors.cyan.withOpacity(.7), minimumSize: const Size(0, 45), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                                      onPressed: () {
                                                        setState(() {
                                                          dbHelper.insert(titleController.text, todoController.text);
                                                          titleController.clear();
                                                          todoController.clear();
                                                          Get.back();
                                                        });
                                                      },
                                                      child: const Text('Add'))),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ));
                    },
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: const Icon(Icons.add),
                      ),
                    ),
                  )),
              floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              body: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = data[index];
                    // todoControllerEdit.text = item['todo'];
                    // titleControllerEdit.text = item['todoTitle'];
                    return Row(
                      children: [
                        Container(
                          height: 120,
                          width: MediaQuery.of(context).size.width - 100,
                          margin: const EdgeInsets.only(left: 10, top: 10, right: 5),
                          decoration: BoxDecoration(color: Colors.cyan.withOpacity(.40), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black, width: 2)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("item-$index"),
                              ),
                              const Divider(
                                height: 0,
                                thickness: 2,
                                color: Colors.black,
                                endIndent: 10,
                                indent: 10,
                              ),
                              ListTile(
                                title: Text(
                                  item['todoTitle'].toString(),
                                  maxLines: 1,
                                ),
                                subtitle: Text(
                                  item['todo'].toString(),
                                  maxLines: 2,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 105,
                          width: 70,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            color: Colors.amber.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(
                            right: 8,
                            top: 10,
                            bottom: 5,
                          ),
                          child: Column(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Get.dialog(
                                        barrierDismissible: true,
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 40),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(.8),
                                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(20),
                                                  child: Material(
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        const Text(
                                                          "Edit Todo",
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        Column(
                                                          children: [
                                                            TextFormField(
                                                              controller: titleControllerEdit,
                                                              validator: (v) {
                                                                if (v!.isEmpty) {
                                                                  return "Empty Field";
                                                                }
                                                                return null;
                                                              },
                                                              maxLines: 1,
                                                              decoration: const InputDecoration(
                                                                labelText: "Todo",
                                                              ),
                                                            ),
                                                            TextFormField(
                                                              controller: todoControllerEdit,
                                                              validator: (v) {
                                                                if (v!.isEmpty) {
                                                                  return "Empty Field";
                                                                }
                                                                return null;
                                                              },
                                                              maxLines: 1,
                                                              decoration: const InputDecoration(
                                                                labelText: "Title",
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 25,
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(foregroundColor: const Color(0xFFFFFFFF), backgroundColor: Colors.cyan.withOpacity(.7), minimumSize: const Size(0, 45), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                                                    onPressed: () {
                                                                      Get.back();
                                                                    },
                                                                    child: const Text('Cancle'))),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                                child: ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(foregroundColor: const Color(0xFFFFFFFF), backgroundColor: Colors.cyan.withOpacity(.7), minimumSize: const Size(0, 45), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                                                    onPressed: () {
                                                                      setState(() {
                                                                        dbHelper.updated(item['todoId'], titleControllerEdit.text, todoControllerEdit.text);
                                                                        Get.back();
                                                                      });
                                                                    },
                                                                    child: const Text('Update'))),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ));
                                  },
                                  child: const Text("Edit")),
                              TextButton(
                                  onPressed: () {
                                    Get.dialog(
                                        barrierDismissible: true,
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 40),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(.8),
                                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(20),
                                                  child: Material(
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        const Text(
                                                          "Delete This itme",
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(foregroundColor: const Color(0xFFFFFFFF), backgroundColor: Colors.cyan.withOpacity(.7), minimumSize: const Size(0, 45), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                                                    onPressed: () {
                                                                      Get.back();
                                                                    },
                                                                    child: const Text('Cancle'))),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                                child: ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(foregroundColor: const Color(0xFFFFFFFF), backgroundColor: Colors.cyan.withOpacity(.7), minimumSize: const Size(0, 45), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                                                    onPressed: () {
                                                                      setState(() {
                                                                        dbHelper.delete(item['todoId']);
                                                                        Get.back();
                                                                      });
                                                                    },
                                                                    child: const Text('Confirm'))),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ));
                                  },
                                  child: const Text("Delete")),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
            );
          }
        });
  }
}
