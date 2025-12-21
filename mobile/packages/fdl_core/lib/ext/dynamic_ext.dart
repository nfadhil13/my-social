extension DynamicExt<T extends dynamic> on T {
  /// Let The Value Be Used In Lambda
  /// [fun] : Lambda To Run
  /// ```dart
  /// final result = value.let((it) => it * 2);
  /// ```
  /// Result = 2
  Y let<Y>(Y Function(T value) fun) => fun(this);

  /// Run The Function
  /// [fun] : Function To Run
  /// ```dart
  /// value.run((it) => print(it));
  /// ```
  void run<Y>(void Function(T value) fun) => fun(this);
}
