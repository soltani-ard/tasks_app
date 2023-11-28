import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:tasks_app/app/core/utils/extentions.dart';
import 'package:tasks_app/app/core/values/colors.dart';
import 'package:tasks_app/app/modules/home/controller.dart';

class ReportPage extends StatelessWidget {
  ReportPage({super.key});

  final homeCtrl = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Obx(() {
      var totalTodos = homeCtrl.getTotalTodosNumber();
      var totalCompletedTodos = homeCtrl.getTotalDoneTaskNumber();
      var totalDoingTodos = totalTodos - totalCompletedTodos;
      var percent = (totalCompletedTodos / totalTodos * 100).toStringAsFixed(0);

      return ListView(
        children: [
          /// title
          Padding(
            padding: EdgeInsets.all(4.0.wp),
            child: Text(
              'My Report',
              style: TextStyle(fontSize: 24.0.sp, fontWeight: FontWeight.bold),
            ),
          ),

          /// time
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
            child: Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: TextStyle(fontSize: 14.0.sp, color: Colors.grey),
            ),
          ),

          /// Divider
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0.wp, horizontal: 5.0.wp),
            child: const Divider(
              thickness: 2,
            ),
          ),

          /// Report result
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.wp, vertical: 3.0.wp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatus(Colors.green, totalDoingTodos, 'Live Todos'),
                _buildStatus(Colors.orange, totalCompletedTodos, 'Completed'),
                _buildStatus(Colors.blue, totalTodos, 'All Todos'),
              ],
            ),
          ),
          SizedBox(
            height: 8.0.wp,
          ),

          /// percent circular
          UnconstrainedBox(
            child: SizedBox(
              height: 70.0.wp,
              width: 70.0.wp,
              child: CircularStepProgressIndicator(
                width: 150,
                height: 150,
                padding: 0,
                totalSteps: totalTodos == 0 ? 1 : totalTodos,
                currentStep: totalCompletedTodos,
                selectedStepSize: 22,
                stepSize: 20,
                selectedColor: green,
                unselectedColor: Colors.grey[200],
                roundedCap: (_, __) => true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${totalTodos == 0 ? 0 : percent} %',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0.sp),
                    ),
                    SizedBox(
                      height: 1.0.wp,
                    ),
                    Text(
                      'Efficiency',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 12.0.sp),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      );
    })));
  }

  _buildStatus(Color color, int number, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// result number
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// circular color
            Container(
              height: 3.0.wp,
              width: 3.0.wp,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 0.5.wp,
                    color: color,
                  )),
            ),
            SizedBox(
              width: 3.0.wp,
            ),

            /// title
            Text(
              number.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0.sp),
            )
          ],
        ),
        SizedBox(
          height: 2.0.wp,
        ),

        /// title
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0.sp),
        )
      ],
    );
  }
}
