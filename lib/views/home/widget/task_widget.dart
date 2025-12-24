import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/extensions/space_exs.dart';
import 'package:flutter_sandbox/utils/app_colors.dart';
import 'package:flutter_sandbox/views/home/widget/task_view.dart';
import 'package:intl/intl.dart';

import '../../../models/tasks.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({Key? key, required this.task}) : super( key: key);

  final Task task;

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {

  TextEditingController textEditingControllerForTitle = TextEditingController();
  TextEditingController textEditingControllerForSubTitle = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    textEditingControllerForTitle.text = widget.task.title;
    textEditingControllerForSubTitle.text = widget.task.subtitle;
    super.initState();
  }

  @override
  void dispose() {
    textEditingControllerForTitle.dispose();
    textEditingControllerForSubTitle.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        // Navigate to TaskView to see Task Details
        Navigator.push(
            context,
            CupertinoPageRoute(builder: (ctx)=> TaskView(
              titleTaskController: textEditingControllerForTitle,
              descriptionTaskController: textEditingControllerForSubTitle, task: widget.task,)
            )
        );
      },
      child: AnimatedContainer(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
              color: widget.task.isCompleted
                  ? const Color.fromARGB(154, 119, 144, 229)
                  : Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(.15),
                  offset: const Offset(0, 4),
                  blurRadius: 10
              )]
          ),
          duration: const Duration(milliseconds: 600),
          child: Container(
            padding: const EdgeInsets.only(left: 15, bottom: 10, right: 15, top: 8),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        // Check or Uncheck the task
                        widget.task.isCompleted = !widget.task.isCompleted;
                        widget.task.save();
                      },
                      child: AnimatedContainer(
                        width: 40,
                        height: 40,
                        duration: const Duration(milliseconds: 600),
                        decoration: BoxDecoration(
                          color: widget.task.isCompleted
                              ? AppColors.primaryColor
                              : Colors.white,
                          shape: BoxShape.rectangle,
                         borderRadius: BorderRadius.circular(10),
                          border:
                          Border.all(color: Colors.grey, width: .8,),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    15.w,

                     Container(
                       width: 250,
                       child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(

                            padding: const EdgeInsets.only(top: 3),
                            child:
                            // Title of task
                            Text(
                              textEditingControllerForTitle.text,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                  color: widget.task.isCompleted
                                      ? AppColors.primaryColor
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  decoration: widget.task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null
                              ),),
                          ),

                          // Description of Task
                          Text(
                            textEditingControllerForSubTitle.text,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            style: TextStyle(
                              overflow: TextOverflow.fade,
                                color: widget.task.isCompleted
                                    ? AppColors.primaryColor
                                    : Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                                decoration: widget.task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null
                            ),
                          ),

                        ],
                                           ),
                     )
                  ],
                ),

                3.h,
                //Date of Task
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('hh:mm a').format(widget.task.createdAtTime),
                        style: TextStyle(
                            fontSize: 12,
                            color: widget.task.isCompleted
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                      Text(
                        DateFormat.yMMMEd().format(widget.task.createdAtDate),
                        style: TextStyle(
                            fontSize: 11,
                            color: widget.task.isCompleted
                                ? Colors.white
                                : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),

      ),
    );
  }
}

