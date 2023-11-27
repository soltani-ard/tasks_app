import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks_app/app/core/utils/extentions.dart';
import 'package:tasks_app/app/modules/home/controller.dart';

class DoingList extends StatelessWidget {
  DoingList({super.key});

  final homeCtrl = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return homeCtrl.doneTodos.isEmpty && homeCtrl.doingTodos.isEmpty
          ? Column(
              children: [
                Image.asset(
                  'assets/images/checklist.gif',
                  fit: BoxFit.cover,
                  width: 65.0.wp,
                ),
                Text(
                  'Add Task',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0.sp),
                )
              ],
            )
          : ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                ...homeCtrl.doingTodos
                    .map((element) => Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 9.0.wp, vertical: 3.0.wp),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  fillColor: MaterialStateProperty.resolveWith(
                                      (states) => Colors.grey[100]),
                                  value: element['done'],
                                  onChanged: (value) {
                                    homeCtrl.doneTodo(element['title']);
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 4.0.wp),
                                child: Text(
                                  element['title'],
                                  style: TextStyle(fontSize: 12.0.sp),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
                if (homeCtrl.doingTodos.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                    child: const Divider(
                      thickness: 2,
                    ),
                  ),
              ],
            );
    });
  }
}
