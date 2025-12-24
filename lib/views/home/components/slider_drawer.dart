

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/extensions/space_exs.dart';
import 'package:flutter_sandbox/utils/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  // Icons
  final List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill
  ];

  //Texts
  final List<String> texts = [
    "Home",
    "Profile",
    "Settings",
    "Details"
  ];

  @override
  Widget build(BuildContext context) {
  //  var textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradientColor,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("assets/images/task_profile_pic.png"),
          ),
          8.h,
          const Text(
            "Timothy Olufemi",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w500
            ),),
          const Text(
            "Web Dev",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),),

          Container(
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            width: double.infinity,
            height: 300,
            child: ListView.builder(
              itemCount: icons.length,
                itemBuilder: (BuildContext context, int index){
                  return InkWell(
                    onTap: (){
                      log('${texts[index]} Item Tapped');
                    },
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                        backgroundBlendMode: BlendMode.lighten
                      ),
                      child: ListTile(
                        leading: Icon(
                          icons[index],
                          color: AppColors.primaryColor,
                          size: 25,
                        ),
                        title: Text(
                            texts[index],
                          style: const TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  );
                }
            ),
          )
        ],
      ),
    );
  }
}

