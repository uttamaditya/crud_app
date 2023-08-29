
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_application/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';


import '../../provider/listing_screen_provider.dart';
import '../task_description_screen/task_description_screen.dart';

class ListingScreen extends StatefulWidget {
  const ListingScreen({Key? key}) : super(key: key);

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  HtmlEditorController controller = HtmlEditorController();

  String htmlString = "";

  late double height;
  late double width;

  Future<String> getText() async{
    htmlString = await controller.getText();
    return htmlString;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: width*0.01, vertical: height*0.01),
          child: Column(
            children: [
            getTextField(titleController, "Task name*"),
              // SizedBox(
              //   height: height*0.01,
              // ),
              // getTextField(descriptionController, "Description*"),

              SizedBox(
                height: height*0.02,
              ),
              Align(
                alignment: Alignment.centerLeft,
                  child: Text("Description*",style: Theme.of(context).textTheme.titleMedium,)),
              SizedBox(
                height: height*0.01,
              ),
              HtmlEditor(
                controller: controller,
                htmlEditorOptions: const HtmlEditorOptions(
                  hint: 'Your text here...',
                  shouldEnsureVisible: true,
                  //initialText: "<p>text content initial, if any</p>",
                ),
                htmlToolbarOptions: HtmlToolbarOptions(

                  toolbarPosition: ToolbarPosition.aboveEditor, //by default
                  toolbarType: ToolbarType.nativeScrollable, //by default
                  onButtonPressed:
                      (ButtonType type, bool? status, Function? updateStatus) {
                    return true;
                  },
                  onDropdownChanged: (DropdownType type, dynamic changed,
                      Function(dynamic)? updateSelectedItem) {
                    return true;
                  },
                  mediaLinkInsertInterceptor:
                      (String url, InsertFileType type) {
                        return true;
                      },
                ),
                otherOptions: const OtherOptions(height: 550),
                callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
                }, onChangeContent: (String? changed) {
                }, onChangeCodeview: (String? changed) {
                }, onChangeSelection: (EditorSettings settings) {

                }, onDialogShown: () {
                }, onEnter: () {
                }, onFocus: () {
                }, onBlur: () {
                }, onBlurCodeview: () {
                }, onInit: () {
                },
                    //this is commented because it overrides the default Summernote handlers
                    onImageLinkInsert: (String? url) {
                  },
                  onImageUpload: (FileUpload file) async {
                  },
                    onImageUploadError: (FileUpload? file, String? base64Str,
                        UploadError error) {

                      if (file != null) {

                      }
                    }, onKeyDown: (int? keyCode) {

                    }, onKeyUp: (int? keyCode) {
                    }, onMouseDown: () {
                    }, onMouseUp: () {
                    }, onNavigationRequestMobile: (String url) {
                      return NavigationActionPolicy.ALLOW;
                    }, onPaste: () {
                    }, onScroll: () {
                    }),
                plugins: [
                  SummernoteAtMention(
                      getSuggestionsMobile: (String value) {
                        var mentions = <String>['test1', 'test2', 'test3'];
                        return mentions
                            .where((element) => element.contains(value))
                            .toList();
                      },
                      mentionsWeb: ['test1', 'test2', 'test3'],
                      onSelect: (String value) {
                      }),
                ],
              ),
              SizedBox(
                height: height*0.02,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Image*",style: Theme.of(context).textTheme.titleMedium,)),
              Consumer<ListingProvider>(
                builder: (context,pro,_) =>
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: height*0.05,
                      width: width*0.85,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black,width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                          // image: (pro.taskImage == null)? null :DecorationImage(image: FileImage(pro.taskImage!),fit: BoxFit.cover)
                      ),
                      child: (pro.isUploadingImage == true)?const CircularProgressIndicator(color: Colors.black,strokeWidth: 3,):Text((pro.imageName),style: Theme.of(context).textTheme.titleSmall,)

                    ),
                    IconButton(onPressed: (){
                      Provider.of<ListingProvider>(context,listen: false).pickImage();
                    }, icon: const Icon(Icons.cloud_upload,size: 35,))
                  ],
                )
                ,

              ),
              SizedBox(
                height: height*0.01,
              ),
               ElevatedButton(
                   onPressed: () async{
                     String data = await getText();
                     if(titleController.text == "" || data == ""|| Provider.of<ListingProvider>(context,listen: false).imageName == "" )
                       {
                         Utils.showFailureSnackBar("Submit all required fields(*) and image", context);
                       }
                     else{

                       Provider.of<ListingProvider>(context,listen: false).addTaskData(titleController.text,data,);
                       Utils.showSuccessSnackBar("Task added successfully", context);

                     }
               }, child: const Text("Add")
               ),

              SizedBox(
                height: height*0.01,
              ),

              StreamBuilder(
                stream: Provider.of<ListingProvider>(context,listen: false).tasks.snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
                if(streamSnapshot.hasData)
                  {
                    final List<Map<String,dynamic>> tasksData = [];
                    streamSnapshot.data!.docs.map((DocumentSnapshot document){
                      Map<String,dynamic> currentData = document.data()! as Map<String,dynamic>;
                      tasksData.add(currentData);
                    }).toList();


                    // Text(streamSnapshot.data!.docs.length.toString())
                    return ListView.builder(
                      shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index){
                      return Dismissible(
                        onDismissed: (direction){
                          Provider.of<ListingProvider>(context,listen: false).deleteDocument(tasksData[index]['date_time'],context);
                        },
                        key: Key(tasksData[index]['date_time']),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: height*0.01),
                          child: ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: const BorderSide(color: Colors.black,width: 2)),
                            title: Text("${tasksData[index]['title']}",style: (tasksData[index]['isStrickedThrough'])?Theme.of(context).textTheme.displayLarge:Theme.of(context).textTheme.titleLarge),
                            // subtitle: Text('${tasksData[index]['description']}',style: Theme.of(context).textTheme.titleMedium,),
                            trailing: Checkbox(
                              value: tasksData[index]['isStrickedThrough'],
                              onChanged: (val) {
                                Provider.of<ListingProvider>(context,listen: false).updateDocument(tasksData[index]['date_time'],val!);
                              },
                            ),
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  TaskDescriptionScreen(title: tasksData[index]['title'], dateTime: tasksData[index]['date_time'], description: tasksData[index]['description'], imageUrl: tasksData[index]['pic_link'])),
                              );
                            },
                          ),
                        ),
                      );
                    });
                  }
                else if(streamSnapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }
                else{
                  return const Center(child: Text("Something Went Wrong"),);
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}



///Appbar
AppBar appBar(BuildContext context)
{
  return AppBar(
    flexibleSpace: Container(
      decoration: const BoxDecoration(
          color: Colors.white
      ),
    ),
    centerTitle: true,
    title:  Text("CRUD App",style: Theme.of(context).textTheme.titleLarge,),
  );
}


///TextFields
Widget getTextField(TextEditingController textEditingController, String hintText)
{
  return Material(
    elevation: 10.0,
    shadowColor: Colors.teal,
    borderRadius: BorderRadius.circular(50),
    child: TextFormField(
      style: const TextStyle(color: Colors.black),
      autofocus: false,
      controller: textEditingController,
      decoration: InputDecoration(
        icon:  Icon((hintText == "Description*")?Icons.description:Icons.title, color: Colors.black),
        hintText: hintText,

      ),
    ),
  ) ;
}