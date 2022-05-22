import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth/cubits/auth_cubits/auth_cubit.dart';
import 'package:phone_auth/cubits/auth_cubits/auth_state.dart';
import 'package:phone_auth/screens/SignInScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:phone_auth/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => AuthCubit()),
      child: MaterialApp(
        home: BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (old, news) {
            return old is AuthInitialState;
          },
          builder: (context, state) {
            if (state is AuthLoggedInState) {
              return HomePage();
            } else {
              return SignInScreen();
            }
          },
        ),
      ),
    );
  }
}
