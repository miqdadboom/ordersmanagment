import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';

InputOptions inputDecorationStyle() {
  return InputOptions(
    inputDecoration: InputDecoration(
      hintText: "Write a message...",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 1),
      ),
    ),
  );
}
