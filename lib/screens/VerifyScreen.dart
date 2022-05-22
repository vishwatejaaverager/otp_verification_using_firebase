import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth/cubits/auth_cubits/auth_state.dart';
import 'package:phone_auth/screens/home.dart';

import '../cubits/auth_cubits/auth_cubit.dart';

class VerifyScreenre extends StatefulWidget {
  const VerifyScreenre({Key? key}) : super(key: key);

  @override
  State<VerifyScreenre> createState() => _VerifyScreenreState();
}

class _VerifyScreenreState extends State<VerifyScreenre> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("verify phone number"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: TextFormField(
              controller: controller,
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
              if (state is AuthLoggedInState) {
                print("still loaded bruh");
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.push(context,
                    CupertinoPageRoute(builder: ((context) => HomePage())));
              } else if (state is AuthErrorState) {
                print("still Error bruh");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      backgroundColor: Colors.red, content: Text(state.error)),
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoadingState) {
                print("still loding bruh");
                return Center(
                  child: CircularProgressIndicator(),
                );
                
              }
              return Container(
                margin: EdgeInsets.all(20),
                child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AuthCubit>(context)
                          .verifyOTP(controller.text);
                    },
                    child: Center(
                      child: Text("Verify"),
                    )),
              );
            },
          )
        ],
      ),
    );
  }
}
