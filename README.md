# cloud_bucket

# Activity Uploader

A Flutter application that allows users to upload various types of activities, including text-only, text with images, text with PDF files, text with both images and PDFs, as well as standalone images or PDFs. Users can also view their uploaded activities on a separate screen with distinct visual representations for each category.

## Features

- Upload activities with:
  - Text only
  - Text with images
  - Text with PDF files
  - Text with both images and PDFs
  - Standalone images
  - Standalone PDFs
- View uploaded activities listings.

## Architecture

The project adheres to the MVVM (Model-View-ViewModel) architectural pattern, ensuring separation of concerns and maintainable code. The project follows best practices in terms of coding conventions and Firebase integration.

## Firebase Integration

- **Firestore**: Used for data storage of activities.
- **Firebase Storage**: Used for storing images and PDF files.

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Firebase Account](https://firebase.google.com/)

### Setup Firebase

1. Create a new project on [Firebase Console](https://console.firebase.google.com/).
2. Add an Android app to your Firebase project.
3. Download the `google-services.json` file and place it in the `android/app` directory of your Flutter project.
4. Follow the instructions on [Firebase's Flutter setup page](https://firebase.flutter.dev/docs/overview) to complete the setup.

### Project Structure

lib/
├── main.dart
├── models/
│   └── intent_model.dart
├── viewmodels/
│   └── intent_viewmodel_provider.dart
└── views/
    ├── upload_screen.dart
    └── view_activities_screen.dart
