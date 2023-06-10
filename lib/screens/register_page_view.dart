import 'package:flutter/material.dart';
import 'package:softwareproject/core/widgets/button_widget.dart';
import 'package:softwareproject/product/constant/icon.dart';
import 'package:softwareproject/product/constant/padding.dart';
import 'package:softwareproject/product/resources/auth_method.dart';
import 'package:softwareproject/product/utils/utils.dart';
import 'package:softwareproject/product/widgets/textformfield_widget.dart';
import 'package:softwareproject/screens/splashScreen_page_view.dart';


class RegisterPageView extends StatefulWidget {
  const RegisterPageView({super.key});

  @override
  State<RegisterPageView> createState() => _RegisterPageViewState();
}
TextEditingController _emailController=TextEditingController();
TextEditingController _passwordController=TextEditingController();
TextEditingController _nameController=TextEditingController();
bool _isLoading = false;

class _RegisterPageViewState extends State<RegisterPageView> {


     void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
       );
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SplashScreenPageView()
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











  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("NETFLIX",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 25),),
        ),
        backgroundColor:(Colors.grey.shade900),
        body: Padding(
          padding: ProjectPadding().mainPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormFieldWidget(controller: _nameController, hintText: 'Adınız', icon: ProjectIcon().emailIcon, isPasswordField: false, size: size, type: TextInputType.emailAddress, visible: false,),
              SizedBox(height: size.height*0.03,),
              TextFormFieldWidget(controller: _emailController, hintText: 'E-posta', icon: ProjectIcon().emailIcon, isPasswordField: false, size: size, type: TextInputType.emailAddress, visible: false,),
              SizedBox(height: size.height*0.03,),
              TextFormFieldWidget(controller: _passwordController, hintText: 'Şifre', icon: ProjectIcon().passwordIcon, isPasswordField: true, size: size, type: TextInputType.text, visible: true,),
              SizedBox(height: size.height*0.04,),
              !_isLoading ? ButtonWidget(onPressed: signUpUser, buttonText: "Kayıt Ol", size: size/1, backgroundColor: Colors.transparent,):
              ButtonWidget(onPressed: (){}, buttonText: "LÜTFEN BEKLEYİN", size: size/1, backgroundColor: Colors.transparent,),
              SizedBox(height: size.height*0.02,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Text("Oturum açma işlemi, robot olmadığınızı kanıtlamak için Google reCAPTCHA ile korunuyor.",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.white),textAlign: TextAlign.center,),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}