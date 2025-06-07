import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AppExceptionHandler {
  static void handle({
    required BuildContext context,
    required Object error,
  }) {
    String message = 'Unexpected error occurred.';

    if (error is SocketException) {
      message = 'No internet connection. Please check your network.';
    } else if (error is FirebaseException) {
      message = 'Firebase error: ${error.message}';
    } else if (error is HttpException) {
      message = 'HTTP error: ${error.message}';
    } else if (error is FormatException) {
      message = 'Invalid response format.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
