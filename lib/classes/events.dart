class Events {
  final String id;
  final String title;
  final String description;
  final String status;

  Events({
    required this.id,
    required this.title,
    required this.description,
    this.status = 'active',
});
}