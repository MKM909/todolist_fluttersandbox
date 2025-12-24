import 'package:flutter/material.dart';

import 'package:flutter_sandbox/utils/app_str.dart';

class RepTextField extends StatelessWidget {
  const RepTextField({super.key, required this.controller, this.isForDescription = false, required this.onFieldSubmitted, required this.onChanged});

  final TextEditingController? controller;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;

  final bool isForDescription;

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: ListTile(
        title: TextFormField(
          controller: controller,
          maxLines: !isForDescription ? 6 : null,
          cursorHeight: !isForDescription ? 60 : null,
          style: const TextStyle(
              color: Colors.black
          ),
          decoration: InputDecoration(
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  style : BorderStyle.solid
                ),
                gapPadding: 4,

              ),
              counter: Container(),
              hintText: isForDescription ? AppStr.addNote : null,
              prefixIcon: isForDescription ? const Icon(Icons.bookmark_border, color: Colors.grey) :  null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    style : BorderStyle.solid
                ),
                gapPadding: 4,

              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    style : BorderStyle.solid
                ),
                gapPadding: 4,

              ),
          ),
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
        ),
      ),
    );
  }
}