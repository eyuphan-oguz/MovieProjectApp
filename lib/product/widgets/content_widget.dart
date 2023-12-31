import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:softwareproject/core/widgets/button_widget.dart';
import 'package:softwareproject/product/constant/colors.dart';
import 'package:softwareproject/product/constant/icon.dart';
import 'package:softwareproject/product/constant/padding.dart';
import 'package:softwareproject/product/resources/content_method.dart';
import 'package:softwareproject/product/utils/utils.dart';
import 'package:softwareproject/product/widgets/showModalBottomSheet_text_widget.dart';
import 'package:softwareproject/product/widgets/showModalBottomSheet_title_widget.dart';

import 'circle_maturity_level_widget.dart';

class ContentWidget extends StatefulWidget {
  const ContentWidget({super.key, required this.size, required this.snapshot, required this.index, required this.favoriteContent});
  final Size size;
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int index;
  final List<String> favoriteContent;

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.size.width * 1,
          height: widget.size.height * 0.6,
          color: ProjectColor().showModalBottomSheetBackgroundColor,
          child: SafeArea(
            child: Padding(
              padding: ProjectPadding().showModalBottomSheetPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _firstRow(),
                  ShowModalBottomSheetTitleWidget(title: widget.snapshot.data!.docs[widget.index]["title"],),
                  buildSizedBox(height: widget.size.height*0.03),      
                  _thirdRow(),
                  buildSizedBox(height: widget.size.height*0.02), 
                  _fourthRow(),
                  buildSizedBox(height: widget.size.height*0.01),  
                  _fifthRow(),
                  buildSizedBox(height: widget.size.height*0.01),  
                  _sixthRow(),
                  buildSizedBox(height: widget.size.height*0.01),  
                  _seventhRow()
                  
                ],
              ),
            ),
          ),
        )
      ],
    );
  }


    ShapeBorder _showModalBottomSheetShapeBorder(){
    return const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
      topRight: Radius.circular(20),
      topLeft: Radius.circular(20)),
  );}

    Widget _showModalBottomSheetTitle({required String title}){
    return Text(title,style: TextStyle(color: Colors.grey));
  }

  SizedBox buildSizedBox({required double height}) => SizedBox(height: height,);


  Widget _firstRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            ProjectIcon().deleteIcon,
            color: Colors.white,
        )),
        CircleMaturityLevelWidget(age:widget.snapshot.data!.docs[widget.index]["maturityLevel"] ,)
        ],
        );
  }

  Widget _thirdRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            _showModalBottomSheetTitle(title: "Release Date"),
            ShowModalBottomSheetTextWidget(text: widget.snapshot.data!.docs[widget.index]["releaseDate"],),
          ],
        ),
        Column(
          children: [
            _showModalBottomSheetTitle(title: "Type"),
            ShowModalBottomSheetTextWidget(text: widget.snapshot.data!.docs[widget.index]["type"],),
          ],
        ),
        Column(
          children: [
            _showModalBottomSheetTitle(title: "IMDB"),
            ShowModalBottomSheetTextWidget(text: widget.snapshot.data!.docs[widget.index]["imdb"],),
          ],
        )
      ],
    );
  }

  Widget _fourthRow(){
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: _showModalBottomSheetTitle(title: "Description"),
      subtitle: Text(widget.snapshot.data!.docs[widget.index]["description"],
      style: TextStyle(color: ProjectColor().textColor)),
    );
  }

  Widget _fifthRow(){
    return Row(
      children: [
        _showModalBottomSheetTitle(title: "Director: "),
        Text(widget.snapshot.data!.docs[widget.index]["director"],
          style: TextStyle(color: ProjectColor().textColor))
      ],
    );
  }

  Widget _sixthRow(){
    return Column(children: [
      Text("Actors",
        style: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(color: Colors.grey)),
          buildSizedBox(height: widget.size.height*0.01),                    
      Container(
        height: widget.size.height*0.02,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (var item in widget.snapshot.data!.docs[widget.index]["actors"])
              Text("${item} | ", style: TextStyle(color: ProjectColor().textColor)),
                            
      ],
    ),
  ),
],);
  }

  Widget _seventhRow(){
    return ButtonWidget(
       onPressed: () async{
        if(FirebaseAuth.instance.currentUser==null){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.transparent,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cancel,color: Colors.red,size: 50,),
                    Text("Lütfen oturum açınız.",style: TextStyle(color: Colors.white),)
                 ],
           ),);}
        );
        showSnackBar(context, "Lütfen oturum açınız.");
         }else{
          await ContentMethod().favoriteContent(postId: widget.snapshot.data!.docs[widget.index]["uid"], userId: FirebaseAuth.instance.currentUser!.uid, likes: widget.favoriteContent);
          Navigator.pop(context);
          return showSnackBar(context, "Listeme Eklendi");
        }
      },
      buttonText: "Listeme Ekle",
      size: widget.size,
      backgroundColor: ProjectColor().redButtonColor);
  }
}