import 'package:flutter/cupertino.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../main.dart';
import 'app_str.dart';

// Lottie assets address
String lottieURL = 'assets/lottie/1.json';


// Empty title or subtitle text-field warning
dynamic emptyWarning(BuildContext context){
  return FToast.toast(
      context,
      msg: AppStr.oopsMsg,
      subMsg: 'You Must Fill All Fields',
      corner: 20,
      duration: 2000,
      padding: const EdgeInsets.all(20),

  );
}

// Nothing entered when user tries to edit or update the current task
dynamic updateTaskWarning(BuildContext context){
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: 'You Must Edit The Tasks Then Try To Update It',
    corner: 20,
    duration: 5000,
    padding: const EdgeInsets.all(20),

  );
}

// No Task Warning Dialog For Deleting
dynamic noTaskWarning(BuildContext context){
  return PanaraInfoDialog.showAnimatedGrow(
      title: AppStr.oopsMsg,
      context,
      message: 'There Is No Task To Delete!! \n Try Adding Some',
      buttonText: 'Okay',
      onTapDismiss: (){
        Navigator.pop(context);
      },
      panaraDialogType: PanaraDialogType.warning,
  );
}

// Delete All Task From Db Dialog
dynamic deleteAllTaskWarning(BuildContext context){
  return PanaraConfirmDialog.show(
      title: AppStr.areYouSure,
      context,
      message: 'Do You Really Want To Delete All Tasks? You Will Not Be Able To Complete This Action!!',
      confirmButtonText: 'Yes',
      cancelButtonText: 'No',
      onTapConfirm: (){
        // We will clear all box data using this command later
        BaseWidget.of(context).dataStore.box.clear();
        Navigator.pop(context);
      },
      onTapCancel: (){ Navigator.pop(context);},
      panaraDialogType: PanaraDialogType.error, barrierDismissible: false);
}