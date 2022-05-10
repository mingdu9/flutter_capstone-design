import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

class StoreTabs extends ChangeNotifier{
  int tab = 0;

  setTab(int add){
    tab = add;
    notifyListeners();
  }
}

class RunPage extends StatefulWidget {
  const RunPage({Key? key,}) : super(key: key);

  @override
  State<RunPage> createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> pageList = [
      FirstPage(), FirstLogin(),
    ];

    return Scaffold(
      body: Container(
        height: size.height,
        padding: EdgeInsets.only(right: 18, left: 18, bottom: 20),
        alignment: Alignment.centerRight,
        child: pageList[context.watch<StoreTabs>().tab],
      ),
    );
  }
}


class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PlayAnimation<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 1300),
                  builder: (context, child, value){
                    return Text('안녕하세요.', textAlign: TextAlign.end, style: TextStyle(
                        letterSpacing: -1.2,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        foreground: Paint()..shader = LinearGradient(colors: <Color>[
                          Colors.blue.withOpacity(value), Color(0xffB484FF).withOpacity(value)
                        ]).createShader(Rect.fromLTWH(140.0, 0.0, 200.0, 0.0))
                    ),);
                  }
              ),
              Text('', style: TextStyle(fontSize: 15),),
              PlayAnimation<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  delay: Duration(milliseconds: 1300),
                  builder: (context, child, value){
                    return Column(
                      children: [
                        Text('본 앱은 주식 투자가', textAlign: TextAlign.end, style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.2,
                            fontSize: 25,
                            color: Colors.black.withOpacity(value)
                        ),),
                        Text('처음인 분들을 위한', textAlign: TextAlign.end, style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.2,
                            fontSize: 25,
                            color: Colors.black.withOpacity(value)
                        ),),
                      ],
                    );
                  }
              ),
              Text('', style: TextStyle(fontSize: 15),),
              PlayAnimation<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                delay: Duration(milliseconds: 1300*2),
                builder: (context, child, value) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('교육용 모의투자 ', style: TextStyle(
                          foreground: Paint()..shader = LinearGradient(colors: <Color>[
                            Colors.blue.withOpacity(value), Color(0xffB484FF).withOpacity(value)
                          ]).createShader(Rect.fromLTWH(90.0, 0.0, 200.0, 0.0)),
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          letterSpacing: -1.2
                      ),),
                      Text('앱입니다.', style: TextStyle(
                          color: Colors.black.withOpacity(value),
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          letterSpacing: -1.2
                      ))
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        Flexible(
          flex: 3,
          child: PlayAnimation<double>(
              tween: Tween<double>(begin: 0.0, end: 0.7),
              delay: Duration(milliseconds: 1300*2+1000),
              builder: (context, child, value) {
                return Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft, end: Alignment.centerRight,
                          stops: const [0.0, 1.0],
                          colors: <Color>[
                            Colors.blue.withOpacity(value), Color(0xffB484FF).withOpacity(value)
                          ]
                      )
                  ),
                  child: ElevatedButton(
                    child: Icon(Icons.arrow_forward_ios, size: 30, color: Colors.white,),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      onPrimary: Colors.transparent,
                      elevation: 0,
                      splashFactory: NoSplash.splashFactory,
                      shape: CircleBorder(
                      )
                    ),
                    onPressed: () {
                      context.read<StoreTabs>().setTab(1);
                    },
                  ),
                );
              }) ,
        ),
      ],
    );
  }
}

class FirstLogin extends StatefulWidget {
  const FirstLogin({Key? key}) : super(key: key);

  @override
  State<FirstLogin> createState() => _FirstLoginState();
}

class _FirstLoginState extends State<FirstLogin> {
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

    return ChangeNotifierProvider(
      create: (context) => StoreFirstRun(),
      child: Center(
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
                                colors: <Color>[
                                  Colors.blue.withOpacity(0.7), Color(0xffB484FF).withOpacity(0.7)
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
                                  GoRouter.of(context).go('/welcome');
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
                              splashFactory: NoSplash.splashFactory,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)
                              ),
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

//회원가입
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();

  Map<String, String> userData = {
    'email' : '',
    'password' : '',
    'name' : '',
  };

  signup(email, pw, name) async{
    try {
      await auth.createUserWithEmailAndPassword(
          email: email,
          password: pw
      ).then((value) => value.user!.updateDisplayName(name))
          .then((value) => print(auth.currentUser!.displayName));
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    CollectionReference users = firestore.collection('users');
    Future<void> addUser(email){
      return users.doc(email).set({
        'balance' : 3000000,
        'holdings' : [],
      }).then((value) => print('added')).catchError((e) => print('error: $e'));
    }

    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => StoreFirstRun(),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    PlayAnimation<Color?>(
                      tween: ColorTween(
                          begin: Colors.transparent, end: Colors.black
                      ),
                      duration: Duration(milliseconds: 10),
                      builder: (context, child, value) {
                        return Text('회원가입', style: TextStyle(
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
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: '이름(닉네임)',
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (text){
                                  if(text==null || text.isEmpty){
                                    return '이름을 입력해주세요';
                                  }else if(text.length < 2){
                                    return '이름은 두 글자 이상입니다.';
                                  }
                                  return null;
                                },
                              onSaved: (name){
                                if(name!=null){
                                  userData['name'] = name;
                                }
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'sample@example.com',
                              ),
                                textInputAction: TextInputAction.next,
                              validator: (text){
                                if(text==null || text.isEmpty){
                                  return '이메일을 입력해주세요';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (email){
                                if(email!=null){
                                  userData['email'] = email;
                                }
                              },
                            ),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: '비밀번호',
                               ),
                              validator: (text){
                                if(text==null || text.isEmpty){
                                  return '비밀번호를 입력해주세요';
                                }else if(text.length < 6){
                                  return '비밀번호는 최소 6자리 입니다';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (password){
                                if(password!=null){
                                  userData['password'] = password;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft, end: Alignment.centerRight,
                              stops: const [0.0, 1.0],
                              colors: <Color>[
                                Colors.blue.withOpacity(0.7), Color(0xffB484FF).withOpacity(0.7)
                              ]
                          )
                      ),
                      child: ElevatedButton(
                          onPressed: () async {
                            if(formKey.currentState!.validate()){
                              formKey.currentState!.save();
                              bool result = await signup(userData['email'], userData['password'], userData['name']);
                              if(result == true){
                                addUser(userData['email']);
                                GoRouter.of(context).pop();
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('회원가입 실패'))
                                );
                              }
                            }
                          },
                          child: Text('회원가입', style: TextStyle(color: Colors.white),),
                          style: ElevatedButton.styleFrom(
                              splashFactory: NoSplash.splashFactory,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)
                              ),
                              primary: Colors.transparent,
                              onPrimary: Colors.transparent,
                              padding: EdgeInsets.all(15),
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.values[5],
                              ),
                              elevation: 0
                          )
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
