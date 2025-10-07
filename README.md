# Dog Image Gallery App

A Flutter application that fetches and displays random dog images from the Dog CEO API.

## API Used

**Dog CEO API** - https://dog.ceo/dog-api/

Example endpoints:
- Random dog image: `https://dog.ceo/api/breeds/image/random`
- Dog image by breed: `https://dog.ceo/api/breed/{breed}/images/random`
- All breeds list: `https://dog.ceo/api/breeds/list/all`

## Features

- ✅ Fetch random dog images from public API
- ✅ Search and filter by breed
- ✅ Pull-to-refresh functionality
- ✅ Loading states with spinner
- ✅ Error handling with retry action
- ✅ Responsive UI with proper spacing
- ✅ Empty state handling
- ✅ Network timeout handling (10 seconds)

## How to Run

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android Studio with Flutter plugin
- Android device/emulator or iOS device/simulator

### Steps

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd dog_image_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

   Or use Android Studio:
    - Open the project in Android Studio
    - Select your device/emulator
    - Click the Run button (▶️)

## User Actions

The app provides multiple ways to fetch/refresh data:

1. **Random Dog Button** - Tap the "Random Dog" button at the bottom to fetch a new random dog image
2. **Pull-to-Refresh** - Pull down on the screen to refresh and get a new random dog
3. **Search by Breed** - Tap the search icon (🔍) in the app bar to select a specific breed
4. **Retry on Error** - When an error occurs, tap the "Try Again" button to retry the request

## Edge Cases Handled

### 1. Network Timeout
**Scenario**: Slow or unstable internet connection causing request delays

**How it's handled**:
- All API requests have a 10-second timeout
- If timeout occurs, user sees clear error message: "Request timed out. Please check your internet connection."
- User can retry the request via "Try Again" button
- Prevents app from hanging indefinitely

### 2. Invalid Breed Search
**Scenario**: API returns 404 for an invalid or non-existent breed

**How it's handled**:
- Error state displays: "Breed not found: {breed_name}"
- User can retry with a different breed via breed selector
- App remains stable and functional

### 3. Network Unavailable
**Scenario**: No internet connection at all

**How it's handled**:
- Catches connection exceptions
- Displays user-friendly error message
- Provides retry button to attempt again once connection is restored
- No app crashes

### 4. Image Loading Failure
**Scenario**: Image URL is valid but image fails to load

**How it's handled**:
- Shows broken image icon placeholder
- App continues to function
- User can fetch a new image to try again

## Project Structure

```
lib/
├── main.dart                    # Main app entry and UI
├── models/
│   └── dog_image.dart          # Data models
└── services/
    └── dog_api_service.dart    # API service layer
```

## Code Quality

- **Async/Await**: All async operations use async/await pattern for clean, readable code
- **Separation of Concerns**: API logic separated into service layer, models in separate files
- **Error Handling**: Comprehensive try-catch blocks with meaningful error messages
- **State Management**: Clear state enum (idle, loading, success, error)
- **Type Safety**: Strong typing throughout with proper null safety
- **Documentation**: Code comments where needed

## Dependencies

- `http: ^1.1.0` - For making HTTP requests
- `flutter/material.dart` - Material Design widgets

## Screenshots & Demo

[Include your Loom video link here]

## Testing

The app has been tested for:
- ✅ Successful API calls
- ✅ Network timeouts
- ✅ Connection errors
- ✅ Invalid breed searches
- ✅ Image loading failures
- ✅ Pull-to-refresh functionality
- ✅ Breed filtering

## Future Enhancements

- Add favorites/bookmarking feature
- Implement image caching
- Add multiple image gallery view
- Include breed information and details
- Add image sharing capability

## License

This project is for educational purposes as part of Solo 3 assignment.
