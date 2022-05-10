import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_animations/stateless_animation/play_animation.dart';

final auth = FirebaseAuth.instance;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final formKey = GlobalKey<FormState>();
  late String email, pw;
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  Future<bool> login(email, password) async {
    try{
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    }on Exception catch(e){
      print(e);
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PlayAnimation<Color?>(
                tween: ColorTween(begin: Colors.transparent, end: Colors.black),
                duration: Duration(milliseconds: 10),
                builder: (context, child, value) {
                  return Text('계정이 있나요?', style: TextStyle(
                      color: value,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      letterSpacing: -1.2
                  ),);
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'sample@example.com',
                        ),
                        validator: (text){
                          if(text==null||text.isEmpty){
                            return '이메일을 입력해주세요';
                          }
                          return null;
                        },
                        onSaved: (text){
                          if(text!=null){
                            email = text;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: pwController,
                        decoration: InputDecoration(
                            labelText: 'password'
                        ),
                        validator: (text){
                          if(text==null||text.isEmpty){
                            return '비밀번호를 입력해주세요';
                          }
                          return null;
                        },
                        onSaved: (text){
                          if(text!=null){
                            pw = text;
                          }
                        },
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                            onPressed: (){
                              emailController.clear();
                              pwController.clear();
                              GoRouter.of(context).push('/signUp');
                            },
                            child: Text('계정이 없다면?', style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                decoration: TextDecoration.underline,
                                decorationThickness: 0.6,
                                letterSpacing: -1.2
                            ),)
                        ),
                      )
                      ,
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft, end: Alignment.centerRight,
                                stops: const [0.0, 1.0],
                                colors: const <Color>[
                                  Colors.blue, Color(0xffB484FF)
                                ]
                            )
                        ),
                        child: ElevatedButton(
                            onPressed: () async {
                              if(formKey.currentState!.validate()){
                                formKey.currentState!.save();
                                bool result = false;
                                result = await login(email, pw);
                                if(result == true){
                                  GoRouter.of(context).go('/mainTab/0');
                                  print(auth.currentUser);//for log
                                }else{
                                  emailController.clear();
                                  pwController.clear();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('로그인 실패'))
                                  );
                                }
                              }
                            },
                            child: Text('로그인', style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)
                                ),
                                splashFactory: NoSplash.splashFactory,
                                primary: Colors.transparent,
                                onPrimary: Colors.transparent,
                                padding: EdgeInsets.all(15),
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.values[5]
                                ),
                                elevation: 0
                            )
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
