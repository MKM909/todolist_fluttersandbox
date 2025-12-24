import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/utils/constants.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

import '../../../main.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key, required this.drawerKey});

  final GlobalKey<SliderDrawerState> drawerKey;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool isDrawerOpen = false;

  @override
  void initState() {
    // TODO: implement initState
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1)
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  // On Toggle
  void onDrawerToggle(){
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if(isDrawerOpen){
        animationController.forward();
        widget.drawerKey.currentState?.openSlider();
      }else{
        animationController.reverse();
        widget.drawerKey.currentState?.closeSlider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var base = BaseWidget.of(context).dataStore.box;

    return SizedBox(
      width: double.infinity,
      height: 120,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Drawer Button
            IconButton(
                onPressed: onDrawerToggle,
                icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  progress: animationController,
                  size: 35,

                )
            ),
            // Trash Button
            IconButton(
                onPressed: (){
                 base.isEmpty ? noTaskWarning(context) : deleteAllTaskWarning(context);
                  // We will Remove Task From Db

                },
                icon: const Icon( CupertinoIcons.trash_fill, size: 30)
            )
          ],
        ),
      ),
    );
  }
}
