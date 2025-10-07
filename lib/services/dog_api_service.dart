import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dog_image.dart';

class DogApiService {
  static const String _baseUrl = 'https://dog.ceo/api';

  // Fetch a random dog image
  Future<DogImage> fetchRandomDogImage() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/breeds/image/random'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timed out. Please check your internet connection.');
        },
      );

      if (response.statusCode == 200) {
        return DogImage.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load dog image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching dog image: ${e.toString()}');
    }
  }

  // Fetch dog image by breed
  Future<DogImage> fetchDogImageByBreed(String breed) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/breed/$breed/images/random'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timed out. Please check your internet connection.');
        },
      );

      if (response.statusCode == 200) {
        return DogImage.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Breed not found: $breed');
      } else {
        throw Exception('Failed to load dog image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching dog image: ${e.toString()}');
    }
  }

  // Fetch all available breeds
  Future<DogBreedsList> fetchAllBreeds() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/breeds/list/all'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timed out. Please check your internet connection.');
        },
      );

      if (response.statusCode == 200) {
        return DogBreedsList.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load breeds. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching breeds: ${e.toString()}');
    }
  }
}