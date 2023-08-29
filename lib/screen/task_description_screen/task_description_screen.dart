import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class TaskDescriptionScreen extends StatelessWidget {
  String? title;
  String? description;
  String? imageUrl;
  String? dateTime;

   TaskDescriptionScreen({Key? key,required this.title,required this.dateTime,required this.description,required this.imageUrl}) : super(key: key);

   late double height;
  late double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: Padding(

          padding:  EdgeInsets.symmetric(vertical: height*0.02,horizontal: width*0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height*0.02,
              ),
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: width*0.3,
                  backgroundImage: NetworkImage(imageUrl!),
                ),
              ),
              SizedBox(
                height: height*0.01,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.01,vertical: height*0.01),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(width: 2,color: Colors.black),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title!,style: Theme.of(context).textTheme.titleLarge,),
                    SizedBox(
                      height: height*0.01,
                    ),
                    Text(dateTime!,style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(
                      height: height*0.01,
                    ),
                    HtmlWidget(description!,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
    ));
  }
}


