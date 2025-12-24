import 'package:flutter/material.dart';
import 'package:flutter_sandbox/extensions/space_exs.dart';
import 'package:flutter_sandbox/views/home/widget/tasks_summary_chart.dart';
import 'package:hive/hive.dart';

import '../../main.dart';
import '../../models/tasks.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  //Check Done Tasks
  int checkDoneTask(List<Task> tasks){
    int i = 0;
    for(Task doneTask in tasks){
      if(doneTask.isCompleted){
        i++;

      }
    }
    return i;
  }

  //Check Not Done Tasks
  int checkNotDoneTask(List<Task> tasks){
    int i = 0;
    for(Task doneTask in tasks){
      if(doneTask.isCompleted != true){
        i++;
      }
    }
    return i;
  }

  // Check value of circle indicator
  dynamic valueOfIndicator(List<Task> tasks){
    if(tasks.isNotEmpty){
      return tasks.length;
    } else{

      return 3;

    }
  }

  // return an int list with tasks
  List<int> allTasksInt(List<Task> tasks){
    List<int> tasksNum = [];
    int i = 0;
    for(Task task in tasks){
      tasksNum.add(i);
      i++;
    }
    return tasksNum;
  }
  
  List<int> test = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<int> test2 = [1, 2, 3, 4, 5];

  // return an int list with completed tasks
  List<int> allCompletedTasksInt(List<Task> tasks){
    List<int> tasksNum = [];
    int i = 0;
    for(Task doneTask in tasks){
      if(doneTask.isCompleted != true){
        tasksNum.add(i);
        i++;
      }
    }
    return tasksNum;
  }

  @override
  Widget build(BuildContext context) {

    BaseWidget base = BaseWidget.of(context);

    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTask(),
        builder: (ctx, Box<Task> box,Widget? child) {

          List<Task> tasks = box.values.toList();

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.h,
                  Container(
                    margin: const EdgeInsets.only( left: 25),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF9A6BFF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(Icons.settings, color: Colors.white),
                        ),
                        20.w,
                        const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 🔑 Expanded makes sure the scrollable area takes the rest of the screen
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [

                            TaskSummaryChartFixed(tasks: tasks),

                            20.h,

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                settingTile(
                                    const Icon( Icons.sunny, color: Colors.orangeAccent,),
                                    const Icon( Icons.dark_mode_outlined, color: Colors.grey,)
                                    , 'Dark Mode', 'Currently Light Mode'),
                                10.w,
                                settingTile(
                                    const Icon( Icons.notifications, color: Colors.blueAccent,),
                                    const Icon( Icons.notifications_active, color: Colors.grey,)
                                    , 'Notifications', 'Currently off'),
                              ],
                            ),

                            10.h,

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                settingTile(
                                    const Icon( Icons.backup_rounded, color: Colors.greenAccent,),
                                    const Icon( Icons.backup_outlined, color: Colors.grey,)
                                    , 'Auto Back Up', 'Currently off'),
                                10.w,
                                settingTile(
                                    const Icon( Icons.delete_outline_outlined, color: Colors.redAccent,),
                                    const Icon( Icons.clear_all, color: Colors.grey,)
                                    , 'Reset App', 'Clear everything'),
                              ],
                            ),


                            // for testing
                            20.h,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

    );
  }

  Widget settingTile(Icon firstIcon, Icon secondaryIcon, String titleSetting, String settingDescription){
    return Container(
      width: 160,
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.15),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey
                ),
                child: firstIcon,
              ),

              secondaryIcon,

            ],
          ),
          10.h,

          Text(
            titleSetting,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800
            ),
          ),
          Text(
            settingDescription,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500
            ),
          ),

          5.h,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Off',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                ),
              ),
              Switch(
                value: false,
                onChanged: (_){},

              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget reportTile(Icon icon, String heading, String description, Color value, List<Task> tasks){
    final int doneTasks = checkDoneTask(tasks);
    final int totalTasks = tasks.isNotEmpty ? tasks.length : 1;
    final int percentage = tasks.isNotEmpty ? ((doneTasks / totalTasks)*100).toInt() : 0;
    return SizedBox(
      height: 110,
      child: Expanded(
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ShaderMask(
                shaderCallback: (rect) {
                  return  LinearGradient(
                    colors: [Colors.white, const Color(0xFFEEE5FF).withValues(alpha: 0.4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(Rect.fromLTWH(0, 0, rect.width, rect.height));
                },
                child: LinearProgressIndicator(
                  value: checkDoneTask(tasks) / valueOfIndicator(tasks),
                  minHeight: 120,
                  valueColor: AlwaysStoppedAnimation(
                      value
                  ),
                ),
              ),
            ),
            Positioned(
              top: 27,
              left: 25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [ const Color(0xFF6C63FF), value],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    ),
                    child: icon,
                  ),
                  10.w,

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        description,
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      Text(
                        heading,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget legendTile(Icon icon, String heading, String description, Color value){

    return SizedBox(
      height: 110,
      child: Expanded(
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: 1,
                minHeight: 33,
                valueColor: AlwaysStoppedAnimation(
                    value
                ),
              ),
            ),
            Positioned(
              top: 4,
              left: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: value
                    ),
                    child: icon,
                  ),
                  10.w,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        description,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      5.w,
                      Text(
                        heading,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
