import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:olbs/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmController = TextEditingController();
  var passwordob = true;
  var confirmpassob = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('SignUp Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: fullNameController,
            decoration: InputDecoration(
              hintText: 'Enter your Full Name',
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Enter your Email',
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: passwordController,
            obscureText: passwordob,
            decoration: InputDecoration(
                hintText: 'Enter your Password ',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                suffixIcon: IconButton(onPressed: (){
                  setState(() {
                    passwordob = !passwordob;
                  });
                }, icon: Icon(passwordob?
                Icons.visibility_off: Icons.visibility),
                  color: Colors.black,
                )

            ),

          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: confirmController,
            obscureText: confirmpassob,
            decoration: InputDecoration(
                hintText: 'Re-Enter your Password ',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),

                suffixIcon: IconButton(onPressed: (){
                  setState(() {
                    confirmpassob = !confirmpassob;
                  });
                }, icon: Icon(confirmpassob?
                Icons.visibility_off: Icons.visibility),
                  color: Colors.black,
                )

            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () async {
              //-> Validation

              var name = fullNameController.text.trim();
              var email = emailController.text.trim();
              var pass = passwordController.text.trim();
              var confirm = confirmController.text.trim();

              if (name.isEmpty ||
                  email.isEmpty ||
                  pass.isEmpty ||
                  confirm.isEmpty) {
                Fluttertoast.showToast(msg: 'Fill All Data');
                return;
              }

              if (pass.length < 6 || confirm.length < 6) {
                Fluttertoast.showToast(
                    msg: 'Password should not be less than 6');
                return;
              }

              if (pass != confirm) {
                Fluttertoast.showToast(msg: 'Password Does Not Match');
                return;
              }

              ProgressDialog dialog = ProgressDialog(context,
                  title: const Text('SingUp'), message: const Text('Please Wait'));

              dialog.show();

              //-> validation Ends

              //-> FireBase Auth

              try {
                FirebaseAuth auth = FirebaseAuth.instance;
                UserCredential userCredential =
                await auth.createUserWithEmailAndPassword(email: email, password: pass);

                if(userCredential.user != null) {


                  //-> Real time DataBase data storing Entry Starts

                  DatabaseReference userRef = FirebaseDatabase.instance.ref().child('users');

                  String uid  = userCredential.user!.uid;
                  int dt = DateTime.now().millisecondsSinceEpoch;

                  await userRef.child('uid').set({

                    "fullName": name,
                    "email": email,
                    "dt": dt,
                    "uid": uid,
                    "profile": "",

                  });

                  //-> Real time Database Data Storing ended






                  Fluttertoast.showToast(msg: "Successfully SignUp");


                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
                    return const LoginScreen();
                  }));
                }
                else{
                  Fluttertoast.showToast(msg: "Recheck Your Data");
                }
              }
              on FirebaseException catch (e){
                if(e.code == 'email-already-in-use') {
                  Fluttertoast.showToast(msg: 'Email Already in Use');
                  return dialog.dismiss();
                }

                if(e.code == 'invalid-email'){
                  Fluttertoast.showToast(msg: 'Invalid Email');
                  return dialog.dismiss();
                }


              }
              catch (e) {
                print(e);
                // TODO
              }

              //-> FireBase Auth Ended




            },
            child: const Text('Signup'),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('You already have an account,'),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
                    return const LoginScreen();
                  }));
                },
                child: const Text('Signup'),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
