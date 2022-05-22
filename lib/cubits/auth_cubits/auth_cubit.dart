import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth/cubits/auth_cubits/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthCubit() : super(AuthInitialState()) {
    User? curentUser = _auth.currentUser;
    if (curentUser != null) {
      emit(AuthLoggedInState(curentUser));
    } else {
      emit(AuthLoggedOutState());
    }
  }

  String? _verificationID;

  void sendOTP(String phoneNumber) async {
    emit(AuthLoadingState());
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: (verificationId, forceResendingToken) {
          _verificationID = verificationId;
          emit(AuthCodeSentState());
        },
        verificationCompleted: (phoneAuthCredential) {
          signInWithPhone(phoneAuthCredential);
        },
        verificationFailed: (error) {
          emit(AuthErrorState(error: error.message.toString()));
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationID = verificationId;
        });
  }

  void verifyOTP(String otp) async {
    emit(AuthLoadingState());
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationID!, smsCode: otp);
    signInWithPhone(credential);
  }

  void signInWithPhone(PhoneAuthCredential credential) async {
    try {
      UserCredential user = await _auth.signInWithCredential(credential);
      if (user.user != null) {
        emit(AuthLoggedInState(user.user!));
      }
    } on FirebaseAuthException catch (ex) {
      emit(AuthErrorState(error: ex.message.toString()));
    }
  }

  void logout() async {
    await _auth.signOut();
    emit(AuthLoggedOutState());
  }
}
