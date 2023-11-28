import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks_app/app/core/utils/extentions.dart';
import 'package:tasks_app/app/core/values/colors.dart';
import 'package:tasks_app/app/modules/home/controller.dart';

class DoneList extends StatelessWidget {
  DoneList({super.key});

  final homeCtrl = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return homeCtrl.doneTodos.isEmpty
          ? const Column(
              children: [
                // Image.asset(
                //   'assets/images/checklist.gif',
                //   fit: BoxFit.cover,
                //   width: 65.0.wp,
                // ),
                // Text(
                //   'Add Task',
                //   style:
                //       TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0.sp),
                // )
              ],
            )
          : ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 4.0.wp, left: 3.0.wp, bottom: 2.0.wp),
                  child: Text(
                    'Completed (${homeCtrl.doneTodos.length})',
                    style: TextStyle(fontSize: 12.0.sp, color: Colors.grey),
                  ),
                ),
                ...homeCtrl.doneTodos
                    .map((element) => Dismissible(
                  key: ObjectKey(element),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => homeCtrl.deleteDoneTodo(element),
                      background: Container(
                        color: Colors.red.withOpacity(0.8),
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                          child: const Icon(Icons.delete, color: Colors.white,),
                        ),
                      ),
                      child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 9.0.wp, vertical: 3.0.wp),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Icon(Icons.done, color: blue,),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.0.wp),
                                  child: Text(
                                    element['title'],
                                    style: TextStyle(fontSize: 12.0.sp, decoration: TextDecoration.lineThrough),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
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
