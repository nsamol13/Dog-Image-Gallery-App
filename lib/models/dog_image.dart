class DogImage {
  final String message;
  final String status;

  DogImage({
    required this.message,
    required this.status,
  });

  factory DogImage.fromJson(Map<String, dynamic> json) {
    return DogImage(
      message: json['message'] as String,
      status: json['status'] as String,
    );
  }

  bool get isSuccess => status == 'success';
  String get imageUrl => message;
}

class DogBreedsList {
  final Map<String, List<String>> breeds;
  final String status;

  DogBreedsList({
    required this.breeds,
    required this.status,
  });

  factory DogBreedsList.fromJson(Map<String, dynamic> json) {
    final message = json['message'] as Map<String, dynamic>;
    final Map<String, List<String>> breedsMap = {};

    message.forEach((key, value) {
      breedsMap[key] = (value as List).map((e) => e.toString()).toList();
    });

    return DogBreedsList(
      breeds: breedsMap,
      status: json['status'] as String,
    );
  }

  List<String> get allBreedNames => breeds.keys.toList()..sort();
}