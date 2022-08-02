import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:olbs/screens/signup_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailTextEditing = TextEditingController();
  var passwordTextEditing = TextEditingController();
  var passwordob = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
        // automaticallyImplyLeading: false,


      ),

      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(

          children: [
            const SizedBox(height: 10,),
            TextField(
              controller: emailTextEditing,
              decoration: InputDecoration(
                hintText: 'Enter your Email',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 2,),
                  borderRadius: BorderRadius.circular(20),
                ),

                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 2,),
                  borderRadius: BorderRadius.circular(20),
                ),

              ),
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: passwordTextEditing,
              obscureText: passwordob,
              decoration: InputDecoration(
                hintText: 'Enter your Password',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 2,),
                  borderRadius: BorderRadius.circular(20),
                ),

                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 2,),
                  borderRadius: BorderRadius.circular(20),
                ),

                suffixIcon: IconButton(onPressed: (){
                  setState(() {
                    passwordob = !passwordob;
                  });
                }, icon: Icon(passwordob ?
                Icons.visibility_off : Icons.visibility)
                ),
              ),

            ),


            ElevatedButton(onPressed: ()async{
              var email = emailTextEditing.text;
              var pass = passwordTextEditing.text;
              FirebaseAuth auth = FirebaseAuth.instance;
              if(email.isNotEmpty && pass.isNotEmpty){
                ProgressDialog progress = ProgressDialog(
                  context,
                  title: const Text('SigningIn'),
                  message: const Text('Please Wait'),
                );
                progress.show();
                try{
                  UserCredential userCred = await auth.signInWithEmailAndPassword(email: email, password: pass);
                  User? user = userCred.user;
                  if( user != null){
                    progress.dismiss();
                    Fluttertoast.showToast(msg: 'Login Successs');
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                      return const Placeholder();
                    }));
                  }
                }on FirebaseAuthException catch(e){
                  progress.dismiss();
                  if(e.code == 'user-not-found'){
                    Fluttertoast.showToast(msg: 'User not found');
                  }else if(e.code ==  'wrong-password'){
                    Fluttertoast.showToast(msg: 'incorrect password');
                  }

                }


              }
              else{
                Fluttertoast.showToast(msg: 'Please Provide Email or Data');
              }
            }, child: const Text('Login'),),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const Text('Create Account,'),
                TextButton(onPressed: (){

                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
                    return const SignupScreen();
                  }));
                }, child: const Text('Signup'),),

              ],
            )
          ],
        ),
      ),
    );
  }
}