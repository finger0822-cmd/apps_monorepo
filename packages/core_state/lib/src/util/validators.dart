int validateRating1to5(int value) {
  if (value < 1 || value > 5) {
    throw ArgumentError.value(value, 'value', 'Rating must be between 1 and 5.');
  }
  return value;
}

String? validateNoteLength(String? value, {int max = 200}) {
  if (value == null) {
    return null;
  }
  if (value.length > max) {
    throw ArgumentError.value(
      value,
      'value',
      'Note must be at most $max characters.',
    );
  }
  return value;
}
