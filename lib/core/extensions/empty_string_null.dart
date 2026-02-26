extension EmptyStringOrNull on String? {
  String? get emptyOrNull => (this ?? '').isEmpty ? null : this;
}