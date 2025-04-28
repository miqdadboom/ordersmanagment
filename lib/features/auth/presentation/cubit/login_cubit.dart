import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void login(String username, String password) {
    emit(LoginLoading());

    // Simulate a login delay
    Future.delayed(Duration(seconds: 2), () {
      if (username == 'user' && password == '1234') {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure('Invalid username or password'));
      }
    });
  }
}
