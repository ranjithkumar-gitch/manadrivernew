class LoginState {
  final bool isLoading;
  final bool isNumberValid;
  final String errorMessage;

  LoginState({
    this.isLoading = false,
    this.isNumberValid = false,
    this.errorMessage = '',
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isNumberValid,
    String? errorMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isNumberValid: isNumberValid ?? this.isNumberValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
