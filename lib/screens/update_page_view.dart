import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:softwareproject/core/widgets/button_widget.dart';
import 'package:softwareproject/product/resources/content_method.dart';
import 'package:softwareproject/product/utils/utils.dart';
import 'package:softwareproject/product/widgets/textformfield_widget.dart';
import 'package:softwareproject/screens/profile_page_view.dart';


class UpdatePageView extends StatefulWidget {
  const UpdatePageView({super.key, required this.postId});
  final String postId;

  @override
  State<UpdatePageView> createState() => _UpdatePageViewState();
}

TextEditingController _titleController=TextEditingController();
TextEditingController _descriptionController=TextEditingController();
TextEditingController _directorController=TextEditingController();
TextEditingController _actorController=TextEditingController();
TextEditingController _maturityLevelController=TextEditingController();
TextEditingController _imdbController=TextEditingController();
TextEditingController _releaseDateController=TextEditingController();
TextEditingController _contentImageUrlController=TextEditingController();

List<String>actors=[];
bool _isLoading = false;
String dropdownValue="";

class _UpdatePageViewState extends State<UpdatePageView> {

       void updateContent() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await ContentMethod().updateContent(
        title: _titleController.text,
        description: _descriptionController.text,
        director: _directorController.text,
        actors: actors,
        maturityLevel: _maturityLevelController.text,
        imdb: _imdbController.text,
        releaseDate: _releaseDateController.text,
        contentImageUrl: _contentImageUrlController.text,
        type: dropdownValue, contentId: widget.postId,

       );
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ProfilePageView()
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
  }
bool isFirstBuild = true;
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("İçeriği Güncelle"),),
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(_auth.currentUser!.uid) // oturum açmış kullanıcının uid'si
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.black,),
                );
              }
            
              print(snapshot.data.data());
              print(snapshot.data.data()["myContentList"]);
            
              List<dynamic> myPostList = snapshot.data.data()["myContentList"];
              return 
                
                
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('content')
                        .doc(widget.postId) // myPostList içindeki ilan id'si
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        print("bura calisti");
                        return CircularProgressIndicator();
                      }
                      DocumentSnapshot advertisement = snapshot.data!;
                      if (isFirstBuild ){
                        for(int i = 0 ; i<advertisement['actors'].length ; i ++){
                        actors.add(advertisement['actors'][i]);
                        isFirstBuild=false;
                      }
                      }
                      
                      dropdownValue=advertisement['type'];
                     _titleController.text=advertisement['title'];
         _descriptionController.text=advertisement['description'];
         _directorController.text=advertisement['director'];
         _maturityLevelController.text=advertisement['maturityLevel'];
         _imdbController.text=advertisement['imdb'];
         _releaseDateController.text=advertisement['releaseDate'];
        _contentImageUrlController.text=advertisement['contentImageUrl'];
        
                      print("simdi bura calisti");
                      print(advertisement['title']);
                      
                      return Column(
                        children: [
                          TextFormFieldWidget(hintText: "${advertisement['title']}", size: size, icon: Icons.abc_outlined, isPasswordField: false, controller: _titleController, type: TextInputType.number, visible: false),
                          TextFormFieldWidget(hintText: "${advertisement['description']}", size: size, icon: Icons.abc_outlined, isPasswordField: false, controller: _descriptionController, type: TextInputType.multiline, visible: false,maxLines: 5,),
                          TextFormFieldWidget(hintText: "${advertisement['director']}", size: size, icon: Icons.abc_outlined, isPasswordField: false, controller: _directorController, type: TextInputType.name, visible: false),
                          TextFormFieldWidget(hintText: "Oyuncu Adı", size: size, icon: Icons.abc_outlined, isPasswordField: false, controller: _actorController, type: TextInputType.name, visible: false),
                  ButtonWidget(onPressed: (){
                    setState(() {
                      actors.add(_actorController.text);
                      _actorController.clear();
                    });
                  }, buttonText: "Oyuncu Ekle", size: size, backgroundColor: Colors.red),
                  //Text(actors.toString(),style: TextStyle(color: Colors.white),),
                  actors.length!=[] ? ListView.builder(
                    itemCount: actors.length,
                    shrinkWrap: true,
                    itemBuilder:(context, index) { 
                      return ListTile(
                        leading: Icon(Icons.person,color:Colors.red),
                        title: Text(actors[index] !=null ? actors[index] : "",style:TextStyle(color: Colors.white)),
                        trailing: IconButton(onPressed: (){
                          setState(() {
                            actors.removeAt(index);                    
                          });
                        },icon: Icon(Icons.remove,color: Colors.red,),),
                      );
                    },
                  ):Container(),
                          TextFormFieldWidget(hintText: "${advertisement['maturityLevel']}", size: size, icon: Icons.abc_outlined, isPasswordField: false, controller: _maturityLevelController, type: TextInputType.number, visible: false),
                          TextFormFieldWidget(hintText: "${advertisement['imdb']}", size: size, icon: Icons.abc_outlined, isPasswordField: false, controller: _imdbController, type: TextInputType.number, visible: false),
                          TextFormFieldWidget(hintText: "${advertisement['releaseDate']}", size: size, icon: Icons.abc_outlined, isPasswordField: false, controller: _releaseDateController, type: TextInputType.datetime, visible: false),
                          TextFormFieldWidget(hintText: "${advertisement['contentImageUrl']}", size: size, icon: Icons.abc_outlined, isPasswordField: false, controller: _contentImageUrlController, type: TextInputType.url, visible: false),
                        
                          !_isLoading ? ButtonWidget(onPressed: updateContent, buttonText: "İçeriği Güncelle", size: size, backgroundColor: Colors.red):
                          ButtonWidget(onPressed: (){}, buttonText: "Lütfen Bekleyin", size: size, backgroundColor: Colors.red)
                        ],
                      );
                    },
                  );
                
              
            },
          ),
        ),
      ),
    );
  }
}