import 'package:flutter/material.dart';
import 'services/dog_api_service.dart';
import 'models/dog_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog Image Gallery by Noah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DogImageScreen(),
    );
  }
}

enum LoadingState { idle, loading, success, error }

class DogImageScreen extends StatefulWidget {
  const DogImageScreen({super.key});

  @override
  State<DogImageScreen> createState() => _DogImageScreenState();
}

class _DogImageScreenState extends State<DogImageScreen> {
  final DogApiService _apiService = DogApiService();
  LoadingState _loadingState = LoadingState.idle;
  DogImage? _currentDogImage;
  List<String> _breeds = [];
  String? _selectedBreed;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchRandomDogImage();
    _fetchBreeds();
  }

  Future<void> _fetchRandomDogImage() async {
    setState(() {
      _loadingState = LoadingState.loading;
      _errorMessage = '';
      _selectedBreed = null;
    });

    try {
      final dogImage = await _apiService.fetchRandomDogImage();
      setState(() {
        _currentDogImage = dogImage;
        _loadingState = LoadingState.success;
      });
    } catch (e) {
      setState(() {
        _loadingState = LoadingState.error;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Future<void> _fetchDogImageByBreed(String breed) async {
    setState(() {
      _loadingState = LoadingState.loading;
      _errorMessage = '';
    });

    try {
      final dogImage = await _apiService.fetchDogImageByBreed(breed);
      setState(() {
        _currentDogImage = dogImage;
        _loadingState = LoadingState.success;
        _selectedBreed = breed;
      });
    } catch (e) {
      setState(() {
        _loadingState = LoadingState.error;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Future<void> _fetchBreeds() async {
    try {
      final breedsList = await _apiService.fetchAllBreeds();
      setState(() {
        _breeds = breedsList.allBreedNames;
      });
    } catch (e) {
      // Silently fail for breeds list - not critical for main functionality
      debugPrint('Failed to fetch breeds: $e');
    }
  }

  void _showBreedSelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select a Breed',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _breeds.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: _breeds.length,
                  itemBuilder: (context, index) {
                    final breed = _breeds[index];
                    return ListTile(
                      title: Text(
                        breed.replaceAll('_', ' ').toUpperCase(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _fetchDogImageByBreed(breed);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Dog Image Gallery by Noah'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showBreedSelector,
            tooltip: 'Search by breed',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchRandomDogImage,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_selectedBreed != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Breed: ${_selectedBreed!.replaceAll('_', ' ').toUpperCase()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: _fetchRandomDogImage,
                            tooltip: 'Clear filter',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Expanded(
                    child: _buildContent(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _loadingState == LoadingState.loading
                              ? null
                              : () {
                            if (_selectedBreed != null) {
                              _fetchDogImageByBreed(_selectedBreed!);
                            } else {
                              _fetchRandomDogImage();
                            }
                          },
                          icon: const Icon(Icons.refresh),
                          label: Text(_selectedBreed != null
                              ? 'New ${_selectedBreed!.replaceAll('_', ' ').toUpperCase()}'
                              : 'Random Dog'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_loadingState) {
      case LoadingState.loading:
        return _buildLoadingState();
      case LoadingState.error:
        return _buildErrorState();
      case LoadingState.success:
        return _buildSuccessState();
      case LoadingState.idle:
        return _buildEmptyState();
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Fetching adorable dog...',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _selectedBreed != null
                ? () => _fetchDogImageByBreed(_selectedBreed!)
                : _fetchRandomDogImage,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    if (_currentDogImage == null) {
      return _buildEmptyState();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                _currentDogImage!.imageUrl,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 300,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 64,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '🐕 Woof! Here\'s your dog!',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pets,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No dog image yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to fetch one!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}