part of 'factorial-screen.dart';

extension ExtensionSigninController on FactorialScreenState {
  int factorial(int num) {
    return _inputValue.value = num == 1 ? 1 : num * factorial(num - 1);
  }
}
