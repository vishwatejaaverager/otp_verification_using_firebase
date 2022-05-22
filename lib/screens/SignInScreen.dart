import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth/cubits/auth_cubits/auth_cubit.dart';
import 'package:phone_auth/cubits/auth_cubits/auth_state.dart';
import 'package:phone_auth/screens/VerifyScreen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in with phone"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: TextFormField(
              controller: textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Phone number",
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthCodeSentState) {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: ((context) => VerifyScreenre())));
              }
            },
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container(
                margin: EdgeInsets.all(20),
                child: ElevatedButton(
                    onPressed: () {
                      String no = "+91" + textEditingController.text;
                      BlocProvider.of<AuthCubit>(context).sendOTP(no);
                    },
                    child: Center(
                      child: Text("Sign In"),
                    )),
              );
            },
          )
        ],
      ),
    );
  }
}
