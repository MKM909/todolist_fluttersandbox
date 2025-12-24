import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_sandbox/extensions/space_exs.dart';
import 'package:flutter_sandbox/main.dart';
import 'package:flutter_sandbox/utils/app_colors.dart';
import 'package:flutter_sandbox/utils/app_str.dart';
import 'package:flutter_sandbox/utils/constants.dart';
import 'package:flutter_sandbox/views/home/widget/task_view_app_bar.dart';
import 'package:intl/intl.dart';

import '../../../models/tasks.dart';
import '../components/date_time_selection.dart';
import '../components/rep_textfield.dart';

class TaskView extends StatefulWidget {
  const TaskView({
    super.key,
    this.task,
    required this.titleTaskController,
    required this.descriptionTaskController});

  final TextEditingController? titleTaskController;
  final TextEditingController? descriptionTaskController;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {

  var title;
  var subTitle;
  DateTime? time;
  DateTime? date;

  // Show selected time as string format
  String showTime(DateTime? time){

    if(widget.task?.createdAtTime == null){

      if(time == null){
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      }else{
        return DateFormat('hh:mm a').format(time).toString();
      }

    }else{
      return DateFormat('hh:mm a').format(widget.task!.createdAtTime).toString();
    }

  }

  // Show date as a string format
  String showDate(DateTime? date){
    if(widget.task?.createdAtDate == null){

      if(date == null){
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      }else{
        return DateFormat.yMMMEd().format(date).toString();
      }

    }else{
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  // Show Selected Date as DateFormat for init Time
  DateTime showDateAsDateTime(DateTime? date){
    if(widget.task?.createdAtDate == null){
        if(date == null){
          return DateTime.now();
        } else{
          return date;
        }
    } else{
      return widget.task!.createdAtDate;
    }
  }

  // if any other tasks exist return true else false
  bool isTaskAlreadyExists(){
    if(widget.titleTaskController?.text == null && widget.descriptionTaskController?.text == null){
      return true;
    }else{
      return false;
    }
  }

  // Main Function for creating or update Tasks
  dynamic isTasksAlreadyExistUpdateOtherWiseCreate(){

    if(widget.titleTaskController?.text != null && widget.descriptionTaskController?.text != null){

      try{
        // HERE WE UPDATE CURRENT TASK
        widget.titleTaskController?.text = title;
        widget.descriptionTaskController?.text = subTitle;

        widget.task?.save();

        Navigator.pop(context);

      }catch(e){
        // If user wanted to update task but did nothing we will show nothing
        updateTaskWarning(context);
      }

    } else{

      // Here we create a new class
      if(title != null && subTitle != null){
        var task = Task.create(
            title: title,
            subtitle: subTitle,
            createdAtDate: date,
            createdAtTime: time
        );

        // We are adding this task to Hive Db using an inherited widget
        BaseWidget.of(context).dataStore.addTask(task: task);

        Navigator.pop(context);

      } else{
        emptyWarning(context);
      }

    }

  }

  // Delete Task
  dynamic deleteTask(){
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: ()=> FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(

        // AppBar
        appBar: const TaskViewAppBar(),


        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                // Top Side Texts
                _buildTopSideTexts(textTheme),

                // Main Task View Activity
                _buildMainTAskViewActivity(textTheme, context),

                // Bottom Side Buttons
                _buildBottomSideButtons()
                
              ],
            ),
          ),
        ),

      ),
    );
  }

  // Main Task View Activity
  Widget _buildMainTAskViewActivity(TextTheme textTheme, BuildContext context){
    return SizedBox(
      width: double.infinity,
      height:532,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          const Padding(
            padding: EdgeInsets.only(left:30),
            child: Text(AppStr.titleOfTitleTextField,
                style: TextStyle(
                  fontSize: 18,
                )),
          ),

          // Task Title
          RepTextField(controller: widget.titleTaskController,
            onFieldSubmitted: (String inputTitle) { title = inputTitle; },
            onChanged: (String inputTitle) { title = inputTitle; },),

          10.h,

          RepTextField(controller: widget.descriptionTaskController,
            isForDescription: true,
            onFieldSubmitted: (String inputSubTitle) { subTitle = inputSubTitle; },
            onChanged: (String inputSubTitle) { subTitle = inputSubTitle; },),

          // Time Selection
          DateTimeSelectionWidget( onTap: (){
            showModalBottomSheet(
                context: context, builder: (_)=> SizedBox(
              height: 280,
              child: TimePickerWidget(
                initDateTime: showDateAsDateTime(time),
                onChange: (_,__){},
                dateFormat: 'HH:mm',
                onConfirm: (dateTime,_){
                  setState(() {
                    if(widget.task?.createdAtTime == null){
                      time = dateTime;
                    }else{
                      widget.task!.createdAtTime = dateTime;
                    }
                  });
                  // will be completed soo
                }  ,
              ),
            )
            );
          }, title: AppStr.timeString,

            // For testing
            time: showTime(time),
          ),

          // Date Selection
          DateTimeSelectionWidget( onTap: (){
            DatePicker.showDatePicker(
                context,
                maxDateTime: DateTime(2030,4,5),
                minDateTime: DateTime.now(),
                initialDateTime: showDateAsDateTime(date),
                onConfirm: (dateTime, _){
                  setState(() {
                    if(widget.task?.createdAtDate == null){
                      date = dateTime;
                    }else{
                      widget.task!.createdAtDate = dateTime;
                    }
                  });
                  // will complete soon
                }
            );
          }, title: AppStr.dateString,
            // For testing
            time:showDate(date),
            isTime: true,
          ),
        ],
      ),
    );
  }

  // Top side texts
  Widget _buildTopSideTexts(TextTheme textTheme){
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
          // Later on according to the task conditions we
          // we will decide to "ADD NEW TASK" or "UPDATE CURRENT TASK"
          RichText(
              text: TextSpan(
                  text: isTaskAlreadyExists()
                  ? AppStr.addNewTask
                  : AppStr.updateCurrentTask,
                  style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w400,
                      color: Colors.black
                  ),
                  children: const [
                    TextSpan(
                      text: AppStr.taskString,
                      style: TextStyle(
                          fontWeight: FontWeight.w500
                      ),
                    )
                  ]
              )),
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Side Buttons
  Widget _buildBottomSideButtons(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExists() ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
        children: [
          isTaskAlreadyExists()
              ? Container()
              :
          // Delete Current Task Button
          MaterialButton(
            onPressed: (){
              // Delete task
              deleteTask();
              Navigator.pop(context);
            },
            minWidth: 150,
            height: 55,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                const Icon(
                  Icons.close,
                  color: AppColors.primaryColor,
                ),
                5.w,
                const Text(
                    AppStr.deleteTask,
                    style: TextStyle(
                        color: AppColors.primaryColor
                    )
                ),
              ],
            ),),

          // Add or Update Task
          MaterialButton(
            onPressed: (){
              // Add or update task activity
              isTasksAlreadyExistUpdateOtherWiseCreate();
            },
            minWidth: 150,
            height: 55,
            color: AppColors.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                5.w,
                Text(
                    isTaskAlreadyExists()
                        ? AppStr.addNewTask
                        : AppStr.updateCurrentTask,
                    style: const TextStyle(
                        color: Colors.white
                    )
                ),
              ],
            ),),
        ],
      ),
    );
  }
  
}






