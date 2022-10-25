import 'package:capstone1/constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

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
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _pwFocusNode = FocusNode();

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
  dispose(){
    super.dispose();
    _emailFocusNode.dispose();
    _pwFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentFocus = FocusScope.of(context);
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('계정이 있나요?', style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        letterSpacing: -1.2
                    ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFormField(
                          focusNode: _emailFocusNode,
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
                              email = text.trim();
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        TextFormField(
                          focusNode: _pwFocusNode,
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
                              pw = text.trim();
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
                                    GoRouter.of(context).replace('/mainTab/0');
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
                                  foregroundColor: Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)
                                  ),
                                  splashFactory: NoSplash.splashFactory,
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

  CollectionReference users = firestore.collection('users');
  Future<void> addUser(email, name){
    return users.doc(email).set({
      'name' : name,
      'balance' : INITBALANCE,
      'holdings' : [],
      'profit' : 0,
    }).then((_) => print('added')).catchError((e) => print('error: $e'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(
          onPressed: (){
            GoRouter.of(context).pop();
          }, icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('회원가입', style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          letterSpacing: -1.2
                      )
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
                                userData['name'] = name.trim();
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
                                userData['email'] = email.trim();
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
                                userData['password'] = password.trim();
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
                              addUser(userData['email'], userData['name']);
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
    );
  }
}

