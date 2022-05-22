import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth/cubits/auth_cubits/auth_cubit.dart';
import 'package:phone_auth/cubits/auth_cubits/auth_state.dart';
import 'package:phone_auth/screens/SignInScreen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoggedOutState) {
              Navigator.popUntil(context, (route) => route.isFirst);
               Navigator.pushReplacement(context,
                    CupertinoPageRoute(builder: ((context) => SignInScreen())));
            }
          },
          builder: (context, state) {
            return ElevatedButton(
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).logout();
              },
              child: Text("Log out"),
            );
          },
        ),
      ),
    );
  }
}
