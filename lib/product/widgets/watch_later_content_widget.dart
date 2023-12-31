import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:softwareproject/product/constant/icon.dart';
import 'package:softwareproject/product/resources/content_method.dart';


class MoviesPage extends StatefulWidget {
  const MoviesPage({ Key? key }) : super(key: key);

  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  CarouselController _carouselController = new CarouselController();
  int _current = 0;
  late String _selectedContentId;

  List<dynamic> _movies = [

  ];

List<String> favoriteContentList = [];
DocumentSnapshot? contentModelList;

List<DocumentSnapshot> contentDocumentList=[];

  Future<List<String>> getFavoriteContentMethod(User? user) async {
  List<String> favoriteContent = [];
  await FirebaseFirestore.instance
    .collection('users')
    .doc(user?.uid)
    .get()
    .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        favoriteContent = List<String>.from(documentSnapshot.get('myContentList'));
        favoriteContentList=favoriteContent;
      }

      for(int i = 0 ; i<favoriteContent.length; i++){
        setState(() {
          
          getContentById(favoriteContent[i]);
        });
      }

    
  });

  return favoriteContent;
}



 Future<void> getContentById(String id) async {
    final collectionRef = FirebaseFirestore.instance.collection('content');
    final doc = await collectionRef.doc(id).get();
    setState(() {
      
      contentModelList = doc.exists ? doc : null;
      contentDocumentList.add(contentModelList!);
      _selectedContentId=contentDocumentList[0]["uid"];
    });
  }




 @override
  void initState() {
    super.initState();
    getFavoriteContentMethod(FirebaseAuth.instance.currentUser);
  } 

  @override
  Widget build(BuildContext context) {
    setState(() {
      print(_current);
      contentDocumentList;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Listem"),
      ),
      body: Container( 
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [

           contentDocumentList.length > 0 ? Image.network(contentDocumentList[_current ]["contentImageUrl"], fit: BoxFit.cover) : Container(),           
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black,
                      Colors.black,
                      Colors.black,
                      Colors.black,
                      Colors.grey.shade50.withOpacity(0.0),
                      Colors.grey.shade50.withOpacity(0.0),
                      Colors.grey.shade50.withOpacity(0.0),
                      Colors.grey.shade50.withOpacity(0.0),
                    ]
                  )
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 500.0,
                  aspectRatio: 16/9,
                  viewportFraction: 0.70,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                      _selectedContentId=contentDocumentList[_current]["uid"];
                      _current;
                    });
                  },
                ),
                carouselController: _carouselController,

                items: contentDocumentList.map((movie) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                height: 320,
                                margin: EdgeInsets.only(top: 30),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Image.network(movie['contentImageUrl'], fit: BoxFit.cover),
                              ),
                              SizedBox(height: 20),
                              Text(movie['title'], style: 
                                TextStyle(
                                  fontSize: 16.0, 
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              // rating
                              SizedBox(height: 20),
                              Container(
                                child: Text(movie['description'], style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey.shade600
                                ), textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        )
                      );
                    },
                  );
                }).toList(),
              ),
            )
          
            ,Positioned(bottom: 30, child: IconButton(
              onPressed: ()async{
                setState(() {
                  _current!= 0 ? contentDocumentList.removeAt(_current) :contentDocumentList.removeAt(0) ;
                  print(_selectedContentId);
                  _current;
                //print(favoriteContentList[_current]);
                });
                await ContentMethod().favoriteContent(postId: _selectedContentId, userId: FirebaseAuth.instance.currentUser!.uid, likes: favoriteContentList);
              },
              icon: Icon(ProjectIcon().deleteIcon,color: Colors.red,size: 50,)))
          ],
        ),
      ),
    );
  }
}