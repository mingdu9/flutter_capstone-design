import 'package:capstone1/providers/authentication.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ModifyProfile extends StatefulWidget {
  const ModifyProfile({Key? key}) : super(key: key);

  @override
  State<ModifyProfile> createState() => _ModifyProfileState();
}

class _ModifyProfileState extends State<ModifyProfile> {
  final BoxDecoration shadowedBox = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 1,
        blurRadius: 8,
        offset: const Offset(4, 8),
      )
    ],
    borderRadius: BorderRadius.circular(8.0),
  );
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameNode = FocusNode();
  // final ImagePicker _picker = ImagePicker();
  // XFile? userImage;

  unfocusField(){
    if(_nameNode.hasFocus){
      _nameNode.unfocus();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentNode = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(
          onPressed: (){
            GoRouter.of(context).pop();
          }, icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
        ),
        title: Text('내 정보 수정', style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold
        ),),
        titleSpacing: 0,
      ),
      body: GestureDetector(
        onTap: (){
          if(currentNode.hasFocus){
            currentNode.unfocus();
          }
          unfocusField();
        },
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: EdgeInsets.all(20),
          primary: false,
          children: [
            Container(
              decoration: shadowedBox,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("이름", style: TextStyle(
                    fontSize: 17
                  ),),
                  Divider(thickness: 0.5, color: Colors.grey,),
                  Row(
                    children: [
                      Flexible(
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            focusNode: _nameNode,
                            decoration: InputDecoration(
                              hintText: auth.currentUser!.displayName,
                            ),
                            validator: (text) {
                              if(text == null || text.isEmpty){
                                return '바꿀 이름을 입력해주세요.';
                              }else if(text.length < 2){
                                return '이름은 최소 2자 이상이어야 합니다.';
                              }
                              return null;
                            },
                            onSaved: (text){
                              if(text!=null){
                                context.read<AuthProvider>().modifyName(text);
                              }
                            },
                          ),
                        )
                      ),
                      TextButton(
                          onPressed: (){
                            if(_formKey.currentState!.validate()){
                              _formKey.currentState!.save();
                            }
                          },
                          style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                            backgroundColor: Colors.white,
                          ),
                          child: Text("수정", style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            )
                          )
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: shadowedBox,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("이메일 정보", style: TextStyle(
                      fontSize: 17
                  ),),
                  Divider(thickness: 0.5,color: Colors.grey,height: 20,),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: auth.currentUser!.emailVerified ?
                          Icon(Icons.check_circle, color: Colors.green,) :
                          Icon(Icons.unpublished, color: Colors.red)
                      ),
                      Text('${auth.currentUser!.email}', style: TextStyle(
                        fontSize: 15
                      ),)
                    ],
                  )
                ],
              ),
            ),
            Container(
              decoration: shadowedBox,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("비밀번호 수정", style: TextStyle(
                      fontSize: 17
                  ),),
                  IconButton(onPressed: (){
                    context.read<AuthProvider>().sendPWResetEmail(auth.currentUser?.email);
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
                              Text('입력하신 ${auth.currentUser?.email}으로\n비밀번호 재설정 메일을 보냈어요!\n메일함을 확인해주세요 💌',
                                style: TextStyle(
                                    fontSize: 17, letterSpacing: -1.2
                                ),
                                textAlign: TextAlign.end,
                              ),
                              Divider(thickness: 0.5, color: Colors.grey.withOpacity(0.6),),
                              TextButton(
                                  onPressed: (){
                                    context.read<AuthProvider>().logout();
                                    GoRouter.of(context).go('/');
                                  },
                                  style: TextButton.styleFrom(
                                      splashFactory: NoSplash.splashFactory,
                                      elevation: 0
                                  ),
                                  child: Text(
                                    '다시 로그인하기', style: TextStyle(
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
                  }, icon: Icon(Icons.arrow_forward_ios, size: 20,))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
