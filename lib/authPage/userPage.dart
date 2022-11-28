import 'package:capstone1/providers/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

//-----------------------로그인-----------------------
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final formKey = GlobalKey<FormState>();
  late String email, pw;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _pwNode = FocusNode();

  onLoginButton(String email, String pw, BuildContext context) async {
    bool flag = await context.read<AuthProvider>().login(email, pw);
    if(flag){
      // GoRouter.of(context).replace('/mainTab/0');
      if(auth.currentUser!.emailVerified){
        GoRouter.of(context).go('/');
      }else{
        context.read<AuthProvider>().logout();
        _pwController.clear();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('이메일 인증을 진행해주세요'))
        );
      }
    }else{
      _emailController.clear();
      _pwController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(context.read<AuthProvider>().getLastFirebaseResponse())
          )
      );
    }
  }

  unfocusNodes(){
    if(_emailNode.hasFocus || _pwNode.hasFocus) {
      _emailNode.unfocus();
      _pwNode.unfocus();
    }
  }

  @override
  dispose(){
    _emailNode.dispose();
    _pwNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
         unfocusNodes();
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
                          focusNode: _emailNode,
                          controller: _emailController,
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
                          obscureText: true,
                          focusNode: _pwNode,
                          controller: _pwController,
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
                                _emailController.clear();
                                _pwController.clear();
                                unfocusNodes();
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
                                  onLoginButton(email, pw, context);
                                }
                              },
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
                              ),
                              child: Text('로그인', style: TextStyle(color: Colors.white),)
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

//-----------------------회원가입-----------------------
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final _nameNode = FocusNode();
  final _emailNode = FocusNode();
  final _pwNode = FocusNode();
  Map<String, String> userData = {
    'email' : '',
    'password' : '',
    'name' : '',
  };



  void onSignupButton(BuildContext context, Map<String, String> formData) async {
    bool flag = await context.read<AuthProvider>().signup(
        formData['email'], formData['password'], formData['name']
    );
    print(auth.currentUser);
    if(flag){
      showDialog(context: context, builder: (context){
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.values.first,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('환영합니다', style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.2
                ),),
                Divider(),
                Text('입력하신 ${formData['email']}으로\n인증 메일을 보냈어요!\n메일함을 확인해주세요 💌',
                  style: TextStyle(
                    fontSize: 17, letterSpacing: -1.2
                  ),
                  textAlign: TextAlign.end,
                ),
                Divider(thickness: 0.5, color: Colors.grey.withOpacity(0.6),),
                TextButton(
                    onPressed: (){
                      GoRouter.of(context).pop();
                      GoRouter.of(context).go('/tutorial');
                    },
                    style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        elevation: 0
                    ),
                    child: Text(
                      '확인', style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold,
                        foreground: Paint()..shader = LinearGradient(
                            colors: const [Colors.blue, Color(0xffB484FF)]
                        ).createShader(Rect.fromLTWH(180.0, 0, 150.0, 20.0)),
                    ),)
                ),
              ],
            ),
          ),
        );
      });
    }else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              context.read<AuthProvider>().getLastFirebaseResponse())
      ));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameNode.dispose();
    _emailNode.dispose();
    _pwNode.dispose();
  }

  unfocusForm(){
    if(_nameNode.hasFocus || _emailNode.hasFocus || _pwNode.hasFocus){
      _nameNode.unfocus();
      _emailNode.unfocus();
      _pwNode.unfocus();
    }
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
      body: GestureDetector(
        onTap: () => unfocusForm(),
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
                              focusNode: _nameNode,
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
                              focusNode: _emailNode,
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
                              focusNode: _pwNode,
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
                              colors: const <Color>[Colors.blue, Color(0xffB484FF)]
                          )
                      ),
                      child: ElevatedButton(
                          onPressed: (){
                            if(formKey.currentState!.validate()){
                              unfocusForm();
                              formKey.currentState!.save();
                              onSignupButton(context, userData);
                            }},
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
                          ),
                          child: Text('회원가입', style: TextStyle(color: Colors.white),)
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

