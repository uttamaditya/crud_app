
import 'package:flutter/material.dart';

class Utils{

  ///Show success snackbar message
  static ScaffoldFeatureController showSuccessSnackBar(String message,BuildContext context){
    return  ScaffoldMessenger.of(context).
    showSnackBar(
         SnackBar(
        content: Text(message),
          backgroundColor: Colors.teal,
        ),
    );
  }

  ///Show failed snackbar message
  static ScaffoldFeatureController showFailureSnackBar(String message,BuildContext context){
    return  ScaffoldMessenger.of(context).
    showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

}