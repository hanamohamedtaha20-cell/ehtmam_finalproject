class SplashState {
  final bool navigate;

  const SplashState({
    this.navigate = false,
  });

  SplashState copyWith({
    bool? navigate,
  }) {
    return SplashState(
      navigate: navigate ?? this.navigate,
    );
  }
}