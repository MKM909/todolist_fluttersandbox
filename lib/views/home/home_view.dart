import 'package:flutter/material.dart';
import 'package:flutter_sandbox/extensions/space_exs.dart';
import 'package:flutter_sandbox/main.dart';
import 'package:flutter_sandbox/models/tasks.dart';
import 'package:flutter_sandbox/utils/app_colors.dart';
import 'package:flutter_sandbox/utils/constants.dart';
import 'package:flutter_sandbox/views/home/widget/task_widget.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

import '../../utils/app_str.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

  // Check value of circle indicator
  dynamic valueOfIndicator(List<Task> tasks){
    if(tasks.isNotEmpty){
      return tasks.length;
    } else{

      return 3;

    }
  }

  // Check Done Tasks
  int checkDoneTask(List<Task> tasks){
    int i = 0;
    for(Task doneTask in tasks){
      if(doneTask.isCompleted){
        i++;

      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final base = BaseWidget.of(context);

    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTask(),
        builder: (ctx, Box<Task> box,Widget? child)
        {
          var tasks = box.values.toList();

          // For sorting list
          tasks.sort((a,b)=> a.createdAtDate.compareTo(b.createdAtDate));

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: _buildHomeBody(textTheme, base, tasks),
          );
        }
    );
  }

  Widget _buildHomeBody(TextTheme textTheme, BaseWidget base, List<Task> tasks){
    final int doneTasks = checkDoneTask(tasks);
    final int totalTasks = tasks.isNotEmpty ? tasks.length : 1;
    final int percentage = tasks.isNotEmpty ? ((doneTasks / totalTasks)*100).toInt() : 0;

    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [

            40.h,

            // Custom AppBar
            SizedBox(
              width: double.infinity,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  25.w,

                  Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.primaryColor
                    ),
                    child: Image.asset('assets/images/app_icon_transparent.png'),

                  ),

                  20.w,

                  // Top Level Task Info
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                          AppStr.mainTitle,
                          style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.w700,
                          )),
                      3.h,
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          '${checkDoneTask(tasks)} of ${tasks.length} Tasks',
                          style: textTheme.titleMedium,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),

            10.h,

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                30.w,
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    '$percentage%',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),

                15.w,

                // Progress Bar
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          colors: [Colors.white, Colors.white],
                        ).createShader(Rect.fromLTWH(0, 0, rect.width, rect.height));
                      },
                      child: LinearProgressIndicator(
                        value: checkDoneTask(tasks) / valueOfIndicator(tasks),
                        minHeight: 20,
                        valueColor: const AlwaysStoppedAnimation(
                            AppColors.primaryColor
                        ),
                      ),
                    ),
                  ),
                ),

                30.w
              ],
            ),

            // Tasks
            Expanded(
              child: tasks.isNotEmpty ?
              // Task List is not Empty
              ListView.builder(
                  itemCount: tasks.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index){
                    // Get Single Task for showing in list
                    var task = tasks[index];
                    return Dismissible(
                        direction: DismissDirection.horizontal,
                        onDismissed: (_){
                          // We will remove task from the DB
                          base.dataStore.deleteTask(task: task);
                        },
                        background: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.delete_outline,
                              color: Colors.grey,
                            ),
                            8.w,
                            const Text(
                              AppStr.deletedTask,
                              style: TextStyle(
                                  color: Colors.grey
                              ),
                            )
                          ],
                        ),
                        key: Key(task.id),

                        // This is only for text we will load tasks from the db later
                        child: TaskWidget(task: task,));
                  }) :
              // Task List is empty
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lottie Animation
                  Center(
                    child: FadeInUp(
                      child: SizedBox(
                        width: 250,
                        height: 250,
                        child: Lottie.asset(
                            lottieURL,
                            animate: tasks.isNotEmpty ? false : true),
                      ),
                    ),
                  ),

                  // Sub Text
                  FadeInUp(
                    from: 30,
                    child: const Text(
                      "There Are No Task's Presently",
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],),
            )

          ],
        ),
      );
  }
}
