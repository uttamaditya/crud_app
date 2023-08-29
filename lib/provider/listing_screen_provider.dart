
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_application/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ListingProvider extends ChangeNotifier{

  bool isUploadingImage = false;

  String imageName = "";

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  late String downloadUrl;

  ///task image will be stored here...
  File? taskImage;

  ///picking image from gallery....
  Future pickImage() async
  {
    isUploadingImage = true;
    imageName = "";
    notifyListeners();

    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 50);

    if(pickedFile != null)
    {

        taskImage = File(pickedFile.path);
      notifyListeners();

      uploadToStorage(taskImage!.path.split("/").last, taskImage!);
    }
  }

  ///Adding the task data
  void addTaskData(String title,String description) async
  {
    String currentDateTime = DateTime.now().toString();
    await tasks.doc(currentDateTime).set({
      "title": title,
      'description': description,
      'pic_link' : downloadUrl,
      'date_time': currentDateTime,
      'isStrickedThrough': false
    });
  }

  ///Uploading image to firebase storage
  void uploadToStorage(String path, File file) async
  {
    var snapshot = await firebaseStorage.ref()
        .child('task_image/$path')
        .putFile(file);
    downloadUrl = await snapshot.ref.getDownloadURL();
    imageName = path;
    isUploadingImage = false;
    notifyListeners();
  }


  ///Deleting task from the list
  void deleteDocument(String docId, BuildContext context) async {
    await tasks
        .doc(docId)
        .delete().then((value) => Utils.showSuccessSnackBar("Task deleted successfully", context));
  }

  ///update the tasks...
  void updateDocument(String docId, bool val) async
  {
    await tasks.doc(docId).update({
      'isStrickedThrough':val
    });
  }
}