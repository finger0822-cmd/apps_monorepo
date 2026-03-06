/// Result type for explicit success/failure without exceptions.
sealed class Result<T> {
  const Result();
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.error);
  final AppError error;
}

/// Application error hierarchy.
sealed class AppError {
  const AppError(this.message);
  final String message;
}

final class UnknownError extends AppError {
  const UnknownError(super.message);
}

final class ValidationError extends AppError {
  const ValidationError(super.message);
}

final class AiError extends AppError {
  const AiError(super.message);
}

final class StorageError extends AppError {
  const StorageError(super.message);
}
