/// 失敗伝播用の Result 型。domain / use case の戻り値で利用する。
library;

/// 成功または失敗を表す sealed 型。
sealed class Result<T, E> {
  const Result();
}

/// 成功値を持つ結果。
final class Success<T, E> extends Result<T, E> {
  const Success(this.value);
  final T value;
}

/// エラーを持つ結果。
final class Failure<T, E> extends Result<T, E> {
  const Failure(this.error);
  final E error;
}

extension ResultExtension<T, E> on Result<T, E> {
  R when<R>({
    required R Function(T value) success,
    required R Function(E error) failure,
  }) {
    return switch (this) {
      Success(value: final v) => success(v),
      Failure(error: final e) => failure(e),
    };
  }

  Result<R, E> map<R>(R Function(T value) f) {
    return switch (this) {
      Success(value: final v) => Success(f(v)),
      Failure(error: final e) => Failure(e),
    };
  }

  Result<T, R> mapError<R>(R Function(E error) f) {
    return switch (this) {
      Success(value: final v) => Success(v),
      Failure(error: final e) => Failure(f(e)),
    };
  }

  T getOrThrow() {
    return switch (this) {
      Success(value: final v) => v,
      Failure(error: final e) => throw Exception(e),
    };
  }

  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is Failure<T, E>;
}
