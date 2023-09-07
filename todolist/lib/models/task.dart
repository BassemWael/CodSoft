class Tasks {
  String name;
  String description;
  bool ischecked; // Include the checkbox state property

  Tasks({
    required this.name,
    required this.description,
    this.ischecked = false, // Initialize the checkbox state to false by default
  });

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      name: json['name'],
      description: json['description'],
      ischecked: json['ischecked'] ?? false, // Provide a default value of false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'ischecked': ischecked, // Save the checkbox state
    };
  }
}

List<Tasks> tasklist = [];
